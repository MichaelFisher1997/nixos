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
    # Core Languages & Runtimes (that need to be global)
    openjdk

    # Nix & Nix tools
    nixpkgs-fmt
    nixpkgs-review
    nurl

    # Core CLI & Networking Tools
    curl
    wget
    tree
    fd
    bat
    lsd
    tldr

    # File systems, Mounts, Partitions
    btrfs-progs
    nfs-utils
    ntfs3g
    gvfs
    parted
    gparted
    gptfdisk
    ldmtool
    smartmontools

    # Network & VPN
    tailscale
    ipmitool

    # Containers & Virtualization
    docker
    docker-compose
    kubectl
    minikube
    terraform
    helm
    pulumi
    pulumiPackages.pulumi-go
    pulumiPackages.pulumi-aws-native
    awscli2
    sqlite
    postgresql
    virt-manager

    # System monitoring
    htop
    btop
    amdgpu_top

    # Xorg/WM system utils
    xorg.xprop
    xorg.xkill

    # Login/session management
    networkmanagerapplet
    networkmanager_dmenu

    # System Security
    vault
    onlyoffice-bin
    rcon
    rconc
    monero-gui

    # Spice/QEMU/VM graphics
    spice
    spice-gtk
    spice-vdagent

    # KDE core system apps (for Plasma systems)
    kdePackages.dolphin
    kdePackages.filelight

    # ddev (if used for multiple users/projects)
    ddev

    # Misc System
    calc
    rpi-imager
    light

    # Games & GPU/driver helpers (if system-wide needed)
    mangohud

    # Google Cloud tools (system use)
    google-cloud-sdk-gce
    kubo

    # Backup/recovery (system-wide, headless or cron use)
    megasync

    # Misc/other core system-wide apps
    betterdiscord-installer # if you want it everywhere
    air # if needed globally

    # Themes and customization (for display manager, greeter, or global theming)
    catppuccin-kvantum
    themechanger


  ];

}
