{ pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core/nix.nix
    ../../modules/core/users.nix
    ../../modules/core/locale.nix
    ../../modules/networking/default.nix
    ../../modules/services/docker.nix
    ../../modules/services/nfs.nix
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.interfaces.enu1u1.mtu = 1500;

  networking.networkmanager.ensureProfiles.profiles."Wired connection 1" = {
    connection = {
      id = "Wired connection 1";
      type = "802-3-ethernet";
      interface-name = "enu1u1";
    };
    "802-3-ethernet".mtu = 1500;
    ethtool.feature-gro = "off";
    ethtool.feature-gso = "off";
    ethtool.feature-tso = "off";
    ipv4.method = "auto";
    ipv6.method = "auto";
  };

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
    home-manager
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
  };

  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "26.05";
}
