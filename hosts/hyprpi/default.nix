{ pkgs, vars, home-manager, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core/nix.nix
    ../../modules/core/users.nix
    ../../modules/core/locale.nix
    ../../modules/services/docker.nix
    ../../modules/services/nfs.nix
    home-manager.nixosModules.home-manager
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = vars.hostName;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  nix.settings = {
    substituters = [
      "https://cache.nixos.org/"
      "https://arm.cachix.org/"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "arm.cachix.org-1:fGqEJIhp5D7HuvLP28J2Q8Mq0s2x5TBXMjJM/HqCT1Q="
    ];
  };

  environment.systemPackages = with pkgs; [
    fish
    neovim
    htop
    btop
    fastfetch
    wget
    curl
    git
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
  };

  hardware.enableRedistributableFirmware = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${vars.user.name} = import ./home.nix;

  system.stateVersion = "26.05";
}
