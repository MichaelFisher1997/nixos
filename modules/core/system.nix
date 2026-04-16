{ lib, pkgs, ... }:
{
  system.stateVersion = lib.mkDefault "25.11";

  system.autoUpgrade = {
    enable = false;
    allowReboot = false;
  };

  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "15s";
  };

  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableUserSlices = true;
    settings.OOM = {
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

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 999;
  };

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  powerManagement.cpuFreqGovernor = "performance";
}
