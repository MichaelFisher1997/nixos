{ pkgs, lib, ... }:
{
  hardware.brillo.enable = true;

  boot.kernel.sysctl."net.ipv4.tcp_mtu_probing" = 1;

  systemd.services.nix-daemon.environment = {
    OPENSSL_CONF = pkgs.writeText "openssl-tls12.conf" ''
      openssl_conf = openssl_init
      [openssl_init]
      ssl_conf = ssl_sect
      [ssl_sect]
      system_default = system_default_sect
      [system_default_sect]
      MaxProtocol = TLSv1.2
      MinProtocol = TLSv1.2
    '';
  };

  nix.settings = {
    connect-timeout = 12;
    stalled-download-timeout = 90;
    http-connections = 10;
    download-attempts = 6;
    http2 = false;
  };

  networking.enableIPv6 = false;

  networking.networkmanager.wifi.powersave = true;

  systemd.services.disable-wifi-tso = {
    description = "Disable TCP Segmentation Offload on WiFi to fix iwlwifi TLS 1.3 bug";
    after = [ "NetworkManager.service" ];
    wants = [ "NetworkManager.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.ethtool pkgs.iproute2 ];
    script = ''
      for attempt in $(seq 1 30); do
        if ip link show wlp0s20f3 > /dev/null 2>&1; then
          state=$(cat /sys/class/net/wlp0s20f3/operstate 2>/dev/null || echo "unknown")
          if [ "$state" = "up" ]; then
            ethtool -K wlp0s20f3 tso off gso off 2>/dev/null || true
            echo "Disabled TSO/GSO on wlp0s20f3"
            exit 0
          fi
        fi
        sleep 2
      done
      echo "Timed out waiting for wlp0s20f3 to come up"
      exit 1
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  networking.networkmanager.dispatcherScripts = [
    {
      type = "basic";
      source = pkgs.writeShellScript "nm-disable-wifi-tso" ''
        if [ "$1" = "wlp0s20f3" ] && [ "$2" = "up" ]; then
          ethtool -K wlp0s20f3 tso off gso off 2>/dev/null || true
        fi
      '';
    }
  ];

  services.thermald.enable = true;
  services.sunshine.autoStart = lib.mkForce false;

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  systemd.services.fix-backlight-permissions = {
    description = "Allow video group to control ThinkPad backlights";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-udevd.service" ];
    path = [ pkgs.coreutils ];
    script = ''
      for brightness in \
        /sys/class/backlight/intel_backlight/brightness \
        /sys/class/leds/tpacpi::kbd_backlight/brightness
      do
        if [ -e "$brightness" ]; then
          chgrp video "$brightness"
          chmod g+w "$brightness"
        fi
      done
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  systemd.services.set-battery-thresholds = {
    description = "Set ThinkPad battery charge thresholds";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    path = [ pkgs.coreutils ];
    script = ''
      if [ -w /sys/class/power_supply/BAT0/charge_control_start_threshold ]; then
        echo 75 > /sys/class/power_supply/BAT0/charge_control_start_threshold
      fi

      if [ -w /sys/class/power_supply/BAT0/charge_control_end_threshold ]; then
        echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  systemd.services.set-default-power-profile = {
    description = "Set laptop power profile from AC state";
    wantedBy = [ "multi-user.target" ];
    wants = [ "power-profiles-daemon.service" ];
    after = [ "power-profiles-daemon.service" ];
    path = with pkgs; [ bash coreutils power-profiles-daemon ];
    script = ''
      set -eu

      on_ac=0

      for supply in /sys/class/power_supply/*; do
        [ -d "$supply" ] || continue

        if [ -r "$supply/type" ] && [ "$(cat "$supply/type")" = "Mains" ]; then
          if [ -r "$supply/online" ] && [ "$(cat "$supply/online")" = "1" ]; then
            on_ac=1
            break
          fi
        fi
      done

      if [ "$on_ac" -eq 1 ]; then
        powerprofilesctl set performance || true
      else
        powerprofilesctl set power-saver || true
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_TYPE}=="Mains", RUN+="${pkgs.systemd}/bin/systemctl --no-block start set-default-power-profile.service"
  '';

  systemd.user.services.hdmi-audio-auto-switch = {
    description = "Auto-switch laptop audio between HDMI and speakers";
    after = [ "wireplumber.service" "pipewire.service" ];
    wants = [ "wireplumber.service" "pipewire.service" ];
    wantedBy = [ "default.target" ];
    path = with pkgs; [
      bash
      coreutils
      gnugrep
      gnused
      gawk
      pipewire
      wireplumber
    ];
    script = ''
      set -eu

      current_target=""

      get_card_id() {
        wpctl status | sed -n 's/.* \([0-9][0-9]*\)\. Built-in Audio[[:space:]]*\[alsa\].*/\1/p' | head -n1
      }

      get_sink_id() {
        label="$1"
        wpctl status | sed -n "/Sinks:/,/Sources:/ s/.* \([0-9][0-9]*\)\. ''${label}.*/\1/p" | head -n1
      }

      hdmi_available() {
        pw-dump | grep -A16 -E '"name": "hdmi-output-[0-9]+"' | grep -q '"available": "yes"'
      }

      switch_target() {
        target="$1"
        card_id="$(get_card_id)"
        [ -n "$card_id" ] || return 0

        if [ "$target" = "hdmi" ]; then
          wpctl set-profile "$card_id" 3 || return 0
          sleep 1
          sink_id="$(get_sink_id 'Built-in Audio Digital Stereo (HDMI)')"
        else
          wpctl set-profile "$card_id" 1 || return 0
          sleep 1
          sink_id="$(get_sink_id 'Built-in Audio Analog Stereo')"
        fi

        [ -n "$sink_id" ] && wpctl set-default "$sink_id" || true
      }

      while true; do
        if hdmi_available; then
          target="hdmi"
        else
          target="analog"
        fi

        if [ "$target" != "$current_target" ]; then
          switch_target "$target"
          current_target="$target"
        fi

        sleep 5
      done
    '';
    serviceConfig = {
      Restart = "always";
      RestartSec = 2;
    };
  };

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    dmidecode
  ];

  services.pipewire.wireplumber.configPackages = [
    (pkgs.writeTextDir "wireplumber/wireplumber.conf.d/90-laptop-audio-suspend.conf" ''
      monitor.alsa.rules = [
        {
          matches = [
            { node.name = "~alsa_input.*" }
            { node.name = "~alsa_output.*" }
            { node.name = "~bluez_*" }
          ]
          actions = {
            update-props = {
              session.suspend-timeout-seconds = 10
            }
          }
        }
      ]
    '')
    (pkgs.writeTextDir "wireplumber/wireplumber.conf.d/70-hdmi-auto-switch.conf" ''
      monitor.alsa.rules = [
        {
          matches = [
            { device.name = "alsa_card.pci-0000_00_1f.3" }
          ]
          actions = {
            update-props = {
              api.acp.auto-profile = true
              api.acp.auto-port = true
            }
          }
        }
      ]
    '')
  ];

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
}
