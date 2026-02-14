{ lib, pkgs, ... }:
{
  networking = {
    hostName = "hypr-nix";
  };

  networking.networkmanager.unmanaged = [ "docker0" "br-*" "veth*" "tailscale0" ];

  environment.etc."NetworkManager/conf.d/10-globally-managed-devices.conf" = {
    text = ''
      [keyfile]
      unmanaged-devices=*,except:type:ethernet,except:type:wifi,except:type:wwan
    '';
  };

  systemd.services.ensure-ethernet-managed = {
    description = "Ensure ethernet devices are managed by NetworkManager";
    after = [ "NetworkManager.service" ];
    wants = [ "NetworkManager.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.networkmanager ];
    script = ''
      nmcli device set enp8s0 managed yes || true
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
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
  systemd.services.NetworkManager-wait-online.enable = false;
}
