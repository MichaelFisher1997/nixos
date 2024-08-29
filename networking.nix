{ config, pkgs, ... }:
{
  networking.hostName = "hypr-nix";
  networking = {
    interfaces = {
      enp0s31f6.useDHCP = true;
    };
  };
}
