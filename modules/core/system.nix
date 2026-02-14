{ lib, pkgs, ... }:
{
  system.stateVersion = "24.11";
  
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=15s
  '';

  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableUserSlices = true;
    extraConfig = {
      DefaultMemoryPressureDurationSec = "5s";
    };
  };

  systemd.services.swap-off = {
    description = "Turn off swap before shutdown";
    wantedBy = [ "shutdown.target" ];
    before = [ "umount.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/swapoff -a";
      RemainAfterExit = true;
    };
  };

  swapDevices = [ 
    { device = "/swapfile"; size = 16384; }
  ];

  powerManagement.cpuFreqGovernor = "performance";
}