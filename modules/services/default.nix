{ pkgs, lib, vars, ... }:
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

  security.sudo.extraRules = [
    {
      users = [ vars.user.name ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  services.openssh.enable = true;

  programs.ssh = {
    askPassword = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
    extraConfig = ''
      Match localuser ${vars.user.name}
        IdentityFile %d/.ssh/infra
        IdentitiesOnly yes
    '';
  };

  programs.java.enable = true;
  programs.nix-ld.enable = true;

  services.fwupd.enable = true;
}
