{ pkgs, vars, lib, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      Policy = {
        AutoEnable = true;
      };
    };
  };

  hardware.enableRedistributableFirmware = true;

  services.blueman.enable = true;
} // lib.optionalAttrs (vars ? bluetooth && vars.bluetooth ? headsetMac) {
  systemd.user.services.bluetooth-headset-autoconnect = {
    description = "Auto-connect Bluetooth headset after boot";
    after = [ "wireplumber.service" ];
    wants = [ "wireplumber.service" ];
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
