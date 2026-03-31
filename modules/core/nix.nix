{ pkgs, ... }:
{
  nix.package = pkgs.nixVersions.latest;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "micqdf" ];
    auto-optimise-store = true;
    max-jobs = "auto";
    cores = 0;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}