{ pkgs, vars, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  hardware.enableRedistributableFirmware = true;

  services.blueman.enable = true;

  systemd.user.services.bluetooth-headset-autoconnect = {
    description = "Auto-connect Bluetooth headset after boot";
    after = [ "bluetooth.target" "pipewire.service" ];
    wants = [ "bluetooth.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bluez}/bin/bluetoothctl connect ${vars.bluetooth.headsetMac}";
      RemainAfterExit = "yes";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}