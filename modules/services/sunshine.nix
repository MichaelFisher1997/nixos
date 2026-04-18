{ pkgs, ... }:
{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  users.groups.video.members = [ "sunshine" ];
  users.groups.render.members = [ "sunshine" ];

  systemd.services.sunshine.environment = {
    GBM_BACKEND = "mesa";
    MESA_LOADER_DRIVER_OVERRIDE = "radeonsi";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  networking.firewall = {
    allowedTCPPorts = [ 47984 47989 47990 48010 ];
    allowedUDPPortRanges = [
      { from = 47998; to = 48000; }
      { from = 8000; to = 8010; }
    ];
  };
}
