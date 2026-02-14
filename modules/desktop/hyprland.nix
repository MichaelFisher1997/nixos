{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    waypaper
    wl-clipboard
    rofi-wayland
    waybar
    polybar
    wttrbar
    hackgen-nf-font
    playerctl
    swaybg
    swww
    nwg-look
    dunst
    udiskie
    hyprshot
    hyprland-protocols
    pavucontrol
    wlr-randr
    libcanberra-gtk3
    pamixer
    grim
    discocss
    nwg-drawer
    hyprpaper
  ];
}