{ pkgs, ... }:
{
  nix.package = pkgs.nixVersions.latest;
  
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "micqdf" ];
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}