{ lib, ... }:
{
  networking = {
    hostName = "hypr-nix";
    useDHCP = lib.mkDefault true;

    interfaces = {
      enp0s31f6.useDHCP = true;
    };
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 47984 47989 47990 48010 ];
    allowedUDPPortRanges = [
      { from = 47998; to = 48000; }
      { from = 8000; to = 8010; }
    ];
  };
  services.tailscale.enable = true;
}
