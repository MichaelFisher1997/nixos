{ pkgs, ... }:
{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # Add sunshine to video and render groups for hardware access
  users.groups.video.members = [ "sunshine" ];
  users.groups.render.members = [ "sunshine" ];

  # Environment variables for Sunshine
  systemd.services.sunshine.environment = {
    GBM_BACKEND = "mesa";
    MESA_LOADER_DRIVER_OVERRIDE = "radeonsi";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  #security.wrappers.sunshine = {
  #        owner = "root";
  #        group = "root";
  #        capabilities = "cap_sys_admin+p";
  #        source = "${pkgs.sunshine}/bin/sunshine";
  # };
}

