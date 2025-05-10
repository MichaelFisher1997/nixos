{ pkgs, ... }:
{
  programs.hyprland = {
		enable = true;
		# package = inputs.hyprland.packages.${pkgs.system}.hyprland;
		xwayland.enable = true;
	};

  environment.systemPackages = with pkgs; [
		waypaper
    wl-clipboard
    blueman
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
    xfce.thunar-volman
    xfce.thunar-dropbox-plugin
    xfce.thunar-archive-plugin
    xfce.tumbler
    pavucontrol
    wlr-randr
    libcanberra-gtk3
    pamixer
    grim
    discocss
    themechanger
    catppuccin-kvantum
    nwg-drawer
    hyprpaper
	];

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
  	thunar-archive-plugin
  	thunar-volman
  ];
}
