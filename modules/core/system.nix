{ lib, pkgs, vars, ... }:
let
  systemConfig = vars.system or {};
  swapConfig = systemConfig.swapfile or {};
  zramConfig = systemConfig.zram or {};
in
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

  swapDevices = lib.optional (swapConfig.enable or true) {
    device = "/swapfile";
    size = swapConfig.size or 16384;
  };

  zramSwap = {
    enable = zramConfig.enable or true;
    algorithm = zramConfig.algorithm or "zstd";
    memoryPercent = zramConfig.memoryPercent or 50;
    priority = zramConfig.priority or 999;
  };

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  powerManagement.cpuFreqGovernor = systemConfig.cpuFreqGovernor or "performance";
}
