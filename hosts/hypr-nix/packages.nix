{ config, pkgs, zen-browser, ... }:
let
  unstable = import
    (builtins.fetchTarball "channel:nixos-unstable")
    { config = config.nixpkgs.config; };
in
{
  environment.systemPackages = with pkgs; [
    #flakes
    zen-browser.packages."${system}".twilight
    # Text Editors
    sublime
    vscode
    
    # Development Tools
    openjdk
    clang-tools
    gcc
    cmake
    glew
    glfw
    libGL
    sdl3
    vulkan-loader
    vulkan-tools
    vulkan-headers
    wayland-protocols
    python3
    php
    php83Packages.composer
    exercism
    betterdiscord-installer
    bun
    air
    tailwindcss
    google-cloud-sdk-gce
    kubo
    hashcat
    
    # Version Control
    git
    git-lfs
    nix-prefetch-git
    
    # Terminals
    kitty
    alacritty
    
    # Shell Utilities
    home-manager
    curl
    wget
    tree
    fd
    fzf
    bat
    thefuck
    tmux
    zellij
    lolcat
    lsd
    tldr
    
    # File Management
    ranger
    _7zz
    unrar
    zip
    unzip
    gzip
    gvfs
    btrfs-progs
    nfs-utils
    ntfs3g
    
    # System Utilities
    htop
    vault
    btop
    amdgpu_top
    parted
    gparted
    xorg.xprop
    xorg.xkill
    calc
    maim
    xclip
    xdotool
    networkmanager_dmenu
    virt-manager
    networkmanagerapplet
    polybarFull
    picom
    arandr
    nitrogen
    pywal
    ldmtool
    smartmontools
    gptfdisk
    
    # Window Managers
    i3
    eww
    vesktop
    hyprsunset
    
    # Web Browsers
    brave
    google-chrome
    firefox
    tor-browser
    
    # Communication
    discord
    webcord
    slack
    #telegram-desktop
    
    # Media
    vlc
    simplescreenrecorder
    obs-studio
    davinci-resolve-studio
    audacity
    haruna
    
    # Gaming
    mangohud
    protonup
    protontricks
    lutris
    bottles
    wine
    wine64
    
    # Fonts
		noto-fonts
    noto-fonts-color-emoji
    twemoji-color-font
    catppuccin-kvantum
    themechanger
    
    # Backup and Recovery
    pika-backup
    megasync
    
    # Networking
    ngrok
    ipmitool
    tailscale
    remmina
    ddev
    
    # Containers and Virtualization
    docker
    docker-compose
    kubectl
    terraform
    minikube
    
    # Security
    onlyoffice-bin
    rcon
    rconc
    monero-gui
    
    # Graphics
    spice
    spice-gtk
    spice-vdagent
    
    # Themes and Customization
    #kdePackages.qt6ct
    catppuccin-kvantum
    
    # Multimedia Tools
    svt-av1
    rav1e
    libaom
    sunshine
    
    # Miscellaneous
    fastfetch
    betterdiscord-installer
    ghostty
    guacamole-client
    rpi-imager
    light

    #games
    flightgear
#    unstable.luanti
    openttd
    endless-sky
    cataclysm-dda
    xonotic
    superTux
    superTuxKart
    airshipper
    mindustry-wayland
    speed_dreams
    simutrans_binaries
    #modrinth-app
    minecraft
    nsnake

    #kdePackages
    kdePackages.dolphin
    kdePackages.filelight
    kdePackages.kate
    kdePackages.falkon
  ];

}
