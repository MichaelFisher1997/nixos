{ pkgs, ... }:

{
  services.rpcbind.enable = true; # needed for NFS
  systemd.mounts = [{
    type = "nfs";
    mountConfig = {
      Options = "noatime";
    };
    what = "100.105.0.115:/BigNAS";
    where = "/mnt/BigNAS";
  }];

  systemd.automounts = [{
    wantedBy = [ "multi-user.target" ];
    automountConfig = {
      TimeoutIdleSec = "600";
    };
    where = "/mnt/BigNAS";
  }];
  fileSystems."/mnt/NV1" = {
    device = "/dev/disk/by-uuid/a41cc08d-10f2-40dd-b76a-976764a50cea";
    fsType = "btrfs";
  };
  fileSystems."/mnt/ssd2" = {
    device = "/dev/disk/by-uuid/bc0d1423-5682-4150-906f-b1a154a316ea";
    fsType = "btrfs";
  };
#  fileSystems."/mnt/ntfs" = {
#    device = "/dev/disk/by-uuid/c51b755c-24d3-11e6-a186-408d5c1ea148";
#    fsType = "ntfs-3g";
#    options = ["rw""uid=1000"];
#  };
}
