{ pkgs, ... }:
{
  home.stateVersion = "25.11";

  programs.fish.enable = true;

  programs.git.enable = true;

  home.packages = with pkgs; [ git ];
}
