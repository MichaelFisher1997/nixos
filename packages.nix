{ config, pkgs, ... }:
let
  unstable = import
    (builtins.fetchTarball "channel:nixos-unstable")
    { config = config.nixpkgs.config; };
in
{
  environment.systemPackages = with pkgs; [
    # Text Editors
    vim
    neovim
    libsForQt5.kate
    sublime
    lunarvim
    vscode
    #unstable.zed-editor
    
    # Development Tools
    openjdk
    clang-tools
    gcc
    cmake
    glew
    glfw
    libGL
    SDL2
    unstable.sdl3
    SDL2_image
    vulkan-loader
    vulkan-tools
    vulkan-headers
    wayland-protocols
    golangci-lint
    golangci-lint-langserver
    python3
    php
    php83Packages.composer
    libsForQt5.kdenlive
    exercism
    betterdiscord-installer
    unstable.nodejs_23
    unstable.go
    unstable.bun
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
    fish
    zsh
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
    unstable.hyprsunset
    unstable.hyprshot
    
    # Web Browsers
    brave
    google-chrome
    firefox
    falkon
    tor-browser
    
    # Communication
    discord
    webcord
    slack
    telegram-desktop
    
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
    minecraft
    
    # Fonts
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
    kdePackages.qt6ct
    catppuccin-kvantum
    
    # Multimedia Tools
    svt-av1
    rav1e
    libaom
    sunshine
    
    # Miscellaneous
    fastfetch
    betterdiscord-installer
    unstable.ghostty
    guacamole-client
    rpi-imager
    kdePackages.filelight

  ];

}
