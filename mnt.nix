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
  #fileSystems."/mnt/BigNAS" = {
  #  device = "10.27.27.239:/BigNAS";
  #  fsType = "nfs";
  #  options = [ "x-systemd.automount" "noauto" ];
  #};

  #fileSystems."/mnt/MainPool" = {
  #  device = "10.27.27.12:/MainPool";
  #  fsType = "nfs";
  #};

  fileSystems."/mnt/NV1" = {
    device = "/dev/nvme1n1p1";
    fsType = "btrfs";
  };
}
