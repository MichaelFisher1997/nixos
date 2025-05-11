{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.home-manager
  ];

#  home-manager.useGlobalPkgs = true;
#  home-manager.useUserPackages = true;

  #home-manager.users.micqdf = import ../../home/micqdf.nix;
}
