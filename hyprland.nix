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
    grim
    discocss
    themechanger
    catppuccin-kvantum
    dolphin
    nwg-drawer
	];

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
  	thunar-archive-plugin
  	thunar-volman
  ];
  # xdg.portal = {
	# 	enable = true;
	# 	wlr.enable = true;
	# 	extraPortals = with pkgs; [
	# 		xdg-desktop-portal-gtk
	# 	];
	# };
}
