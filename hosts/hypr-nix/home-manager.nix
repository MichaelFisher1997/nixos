{ pkgs, ... }:
{
  imports = [
    # Home Manager module from nixpkgs (not flake)
    "${pkgs.path}/nixos/modules/programs/home-manager.nix"
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.micqdf = import ../../home/micqdf.nix;
}
