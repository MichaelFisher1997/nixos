{ pkgs, ... }:

{
  #fileSystems."/mnt/BigNAS" = {
  #  device = "10.27.27.239:/BigNAS";
  #  fsType = "nfs";
  #};

  #fileSystems."/mnt/MainPool" = {
  #  device = "10.27.27.12:/MainPool";
  #  fsType = "nfs";
  #};

  #fileSystems."/mnt/NV1" = {
  #  device = "/dev/nvme1n1p2";
  #  fsType = "btrfs";
  #};
}
