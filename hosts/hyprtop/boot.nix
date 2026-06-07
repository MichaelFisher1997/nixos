{ lib, pkgs, ... }:
{
  imports = [
    ../../modules/core/boot-common.nix
    ../../modules/core/boot-grub.nix
  ];

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;
}
