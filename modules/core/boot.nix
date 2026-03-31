{ pkgs, ... }:
{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.initrd.kernelModules = [ "amdgpu" "vfio_pci" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  boot.kernelModules = [ 
    "btusb" "btintel" "btrtl" 
    "xpad" "usbhid" "hid_generic" 
  ];

  boot.kernelParams = [
    "cgroup_enable=cpuset,cpu,cpuacct,blkio,devices,freezer,net_cls,perf_event,net_prio,hugetlb,pids"
    "usbcore.old_scheme_first=1"
    "amd_pstate=active"
    "split_lock_detect=off"
    "nowatchdog"
    "elevator=none"
    "vfio-pci.ids=1e4b:1202"
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 3;
    "vm.dirty_expire_centisecs" = 300;
    "vm.dirty_writeback_centisecs" = 100;
    "kernel.perf_event_paranoid" = 1;
    "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    "net.core.netdev_max_backlog" = 30000;
  };

  boot.supportedFilesystems = [ "ntfs" ];
  boot.extraModprobeConfig = ''
    options btusb reset=1
    softdep nvme pre: vfio-pci
  '';
}
