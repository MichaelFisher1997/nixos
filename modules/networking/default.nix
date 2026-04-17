{ pkgs, vars, lib, unstable, ... }:
{
  networking = {
    hostName = vars.hostName;
    nameservers = [
      "1.1.1.1#cloudflare-dns.com"
      "1.0.0.1#cloudflare-dns.com"
      "9.9.9.9#dns.quad9.net"
      "149.112.112.112#dns.quad9.net"
    ];
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      unmanaged = [ "docker0" "br-*" "veth*" "tailscale0" ];
    };
    dhcpcd.enable = false;
  };

  services.resolved = {
    enable = true;
    fallbackDns = [
      "8.8.8.8#dns.google"
      "8.8.4.4#dns.google"
      "2606:4700:4700::1111#cloudflare-dns.com"
      "2606:4700:4700::1001#cloudflare-dns.com"
      "2001:4860:4860::8888#dns.google"
      "2001:4860:4860::8844#dns.google"
    ];
  };

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

  systemd.services.NetworkManager-wait-online.enable = false;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 47984 47989 47990 48010 ];
    allowedUDPPortRanges = [
      { from = 47998; to = 48000; }
      { from = 8000; to = 8010; }
    ];
  };

  services.tailscale = {
    enable = true;
    package = unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.tailscale;
  };
}
