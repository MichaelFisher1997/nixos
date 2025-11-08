{ ... }:

{
  services.rpcbind.enable = true; # needed for NFS
  boot.supportedFilesystems = [ "nfs" ]; # Enable NFS support
  
  # Create required NFS state directories and mount points
  systemd.tmpfiles.rules = [
    "d /var/lib/nfs 0755 root root -"
    "d /var/lib/nfs/sm 0755 root root -"
    "d /var/lib/nfs/sm.bak 0755 root root -"
    "d /mnt/BigNAS 0755 root root -"
  ];
  
  systemd.mounts = [{
    type = "nfs";
    what = "10.27.27.239:/BigNAS";
    where = "/mnt/BigNAS";
    mountConfig = {
      Options = "noatime,nofail,x-systemd.device-timeout=5s,nolock";
    };
  }];

  systemd.automounts = [{
    wantedBy = [ "multi-user.target" ];
    automountConfig = {
      TimeoutIdleSec = "600";
    };
    where = "/mnt/BigNAS";
  }];
  fileSystems."/mnt/NVME" = {
    device = "/dev/disk/by-uuid/15b96913-a018-4ecc-950c-b8cf74b93315";
    fsType = "btrfs";
    options = [ "compress=zstd" "nofail" "x-systemd.device-timeout=5s" ];
  };
  fileSystems."/mnt/ssd2" = {
    device = "/dev/disk/by-uuid/bc0d1423-5682-4150-906f-b1a154a316ea";
    fsType = "btrfs";
    options = [ "nofail" "x-systemd.device-timeout=5s" ];
  };
}
