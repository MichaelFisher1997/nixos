{ config, pkgs, lib, ... }:
{
  networking = {
    hostName = "hypr-nix";
    useDHCP = lib.mkDefault true;

    interfaces = {
      enp0s31f6.useDHCP = true;
    };
  };

  services.tailscale.enable = true;
}
