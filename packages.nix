{ config, pkgs, ... }:
let
  unstable = import 
    (builtins.fetchTarball "channel:nixos-unstable")
    { config = config.nixpkgs.config; };
in
{
  environment.systemPackages = with pkgs; [
  # Applications you want to install with Nix.
  # You can remove these applications if you don't use them.
  vim
  neovim
  fish
  zsh
  curl
  wget
  neofetch
  kitty
  brave
  webcord
  vscode
  tor-browser
  monero-gui
  htop
  btop
  ranger
  tmux
  lsd
  nfs-utils
  tldr
  btrfs-progs
  golangci-lint
  golangci-lint-langserver
  google-chrome
  # gvfs
  git
  ipmitool
  go
  zig
  slack
  networkmanagerapplet
  spotify
  xorg.xkill
  ldmtool
  kitty
  flatpak
  libcanberra-gtk3
  docker
  docker-compose
  pamixer
  onlyoffice-bin
  svt-av1
  rav1e
  libaom
  slurp
  nix-prefetch-git
  ddev
  libsForQt5.kate
  sublime
  tailscale
  libcap 
  gcc
  go
  telegram-desktop
  falkon
  firefox
  php
  rcon
  rconc
  php83Packages.composer
  zip
  unzip
  gzip
  mangohud
  protonup
  lutris
  bottles
  wine
  #peazip
  _7zz
  unrar
  spice
  spice-gtk
  spice-vdagent
  haruna
  air
  tailwindcss
  betterdiscord-installer
  vesktop
  vencord
  fastfetch
  davinci-resolve-studio
  obs-studio
  lunarvim
  qbittorrent
  godot_4
  vlc
  python3
  gparted
  parted
  amdgpu_top
  unstable.zed-editor
  unstable.hyprshot
  guacamole-client
  ];

}

