{ ... }:
{
  imports = [
    ../core/nix.nix
    ../core/users.nix
    ../core/locale.nix
    ../core/system.nix
    ../core/fonts.nix

    ../desktop/gnome.nix
    ../desktop/hyprland.nix

    ../hardware/audio.nix
    ../hardware/bluetooth.nix

    ../services/docker.nix
    ../services/sunshine.nix
    ../services/nfs.nix
    ../services/default.nix
    ../services/desktop-files.nix

    ../networking/default.nix
    ../gaming/default.nix
    ../packages/default.nix
  ];
}
