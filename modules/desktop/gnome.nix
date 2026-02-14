{ pkgs, lib, ... }:
{
  services.xserver = {
    enable = true;
    xkb.layout = "gb";
    xkb.variant = "";
    videoDrivers = [ "amdgpu" ];

    displayManager.gdm.enable = true;

    desktopManager.gnome.enable = true;
  };

  services.gnome = {
    gnome-keyring.enable = true;
    gnome-online-accounts.enable = lib.mkForce false;
    gnome-browser-connector.enable = false;
  };

  environment.sessionVariables = {
    KWIN_DRM_NO_AMS = "1";
    MANGOHUD = "1";
  };
}