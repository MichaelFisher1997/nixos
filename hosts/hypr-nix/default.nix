{ pkgs, lib, vars, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/core/boot.nix
    ../../modules/core/nix.nix
    ../../modules/core/users.nix
    ../../modules/core/locale.nix
    ../../modules/core/system.nix

    ../../modules/desktop/gnome.nix
    ../../modules/desktop/hyprland.nix

    ../../modules/hardware/gpu-amd.nix
    ../../modules/hardware/audio.nix
    ../../modules/hardware/bluetooth.nix

    ../../modules/services/docker.nix
    ../../modules/services/sunshine.nix
    ../../modules/services/nfs.nix
    ../../modules/services/default.nix

    ../../modules/networking/default.nix
    ../../modules/gaming/default.nix
    ../../modules/packages/default.nix
  ];
}