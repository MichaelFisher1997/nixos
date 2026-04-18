{ pkgs, lib, ... }:
{
  hardware.brillo.enable = true;

  powerManagement.cpuFreqGovernor = lib.mkForce "powersave";

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
    description = "Set default laptop power profile";
    wantedBy = [ "multi-user.target" ];
    after = [ "power-profiles-daemon.service" ];
    path = [ pkgs.power-profiles-daemon ];
    script = ''
      powerprofilesctl set balanced || true
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
  ];

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
}
