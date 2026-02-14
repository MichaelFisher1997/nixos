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
}