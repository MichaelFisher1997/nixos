{ pkgs, lib, vars, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/profiles/desktop-base.nix
    ../../modules/core/boot-systemd-boot.nix
    ../../modules/core/boot.nix
    ../../modules/hardware/gpu-amd.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  environment.systemPackages = [ pkgs.amdgpu_top ];
}
