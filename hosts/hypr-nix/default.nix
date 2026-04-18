{ pkgs, lib, vars, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/profiles/desktop-base.nix
    ../../modules/core/boot.nix
    ../../modules/hardware/gpu-amd.nix
  ];

  environment.systemPackages = [ pkgs.amdgpu_top ];
}
