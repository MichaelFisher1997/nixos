{ pkgs, ... }:
{
  hardware.brillo.enable = true;

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

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
  ];

  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;
  services.upower.enable = true;
}
