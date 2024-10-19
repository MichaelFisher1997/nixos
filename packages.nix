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
  ngrok
  fish
  zsh
  curl
  i3
  wget
  ccache
  appstream
  neofetch
  kitty
  discord
  brave
  simplescreenrecorder
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
  git-lfs
  golangci-lint
  golangci-lint-langserver
  google-chrome
  # gvfs
  git
  ipmitool
  #go
  zig
  slack
  networkmanagerapplet
  spotify
  xorg.xkill
  ldmtool
  kitty
  flatpak
  flatpak-builder
  noto-fonts-color-emoji
  twemoji-color-font
  #whatsapp-emoji-font
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
  unstable.go
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
  bottles
  wine
  wine64
  appstream-glib
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
  rpi-imager
  vesktop
  vencord
  fastfetch
  davinci-resolve-studio
  obs-studio
  lunarvim
  qbittorrent
  vlc
  python3
  gparted
  parted
  amdgpu_top
  unstable.zed-editor
  unstable.hyprshot
  guacamole-client
  mono
  pika-backup
  lutris
  audacity
  tree
  ldmtool
  ntfs3g
  exercism
  cmake
  glew
  glfw
  libGL
  unityhub
  cmake
  SDL2
  vulkan-loader
  vulkan-tools
  vulkan-headers
  wayland-protocols
  minecraft
  ];

}
