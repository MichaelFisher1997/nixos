{ pkgs, ... }:
{
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/nvme0n1";
      useOSProber = true;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.kernelModules = [
    "btusb"
    "btintel"
    "btrtl"
    "xpad"
    "usbhid"
    "hid_generic"
  ];

  boot.kernelParams = [
    "cgroup_enable=cpuset,cpu,cpuacct,blkio,devices,freezer,net_cls,perf_event,net_prio,hugetlb,pids"
    "usbcore.old_scheme_first=1"
    "split_lock_detect=off"
    "nowatchdog"
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 3;
    "vm.dirty_expire_centisecs" = 300;
    "vm.dirty_writeback_centisecs" = 100;
    "vm.max_map_count" = 2147483642;
    "kernel.perf_event_paranoid" = 1;
    "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    "net.core.netdev_max_backlog" = 30000;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "net.core.rmem_default" = 262144;
    "net.core.wmem_default" = 262144;
    "net.ipv4.tcp_rmem" = "4096 131072 16777216";
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";
    "fs.inotify.max_user_watches" = 1048576;
  };

  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "75%";

  boot.supportedFilesystems = [ "ntfs" ];
  boot.extraModprobeConfig = ''
    options btusb reset=1
  '';
}
