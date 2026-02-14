{ pkgs, lib, ... }:
{
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  services.tumbler.enable = true;
  services.gvfs.enable = lib.mkForce false;

  services.printing.enable = true;

  services.flatpak.enable = true;

  security.polkit.enable = true;

  services.openssh.enable = true;

  programs.ssh.askPassword = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";

  programs.java.enable = true;
  programs.nix-ld.enable = true;
  programs.sway.enable = true;
}