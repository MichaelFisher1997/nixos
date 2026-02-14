{ pkgs, zen-browser, ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-33.4.11"
    ];
  };

  environment.systemPackages = with pkgs; [
    zen-browser.packages."${system}".twilight

    openjdk

    nixpkgs-fmt
    nixpkgs-review
    nurl

    curl
    wget
    tree
    fd
    bat
    lsd
    tldr

    btrfs-progs
    nfs-utils
    ntfs3g
    gvfs
    parted
    gparted
    gptfdisk
    ldmtool
    smartmontools

    tailscale
    ipmitool

    docker
    docker-compose
    kubectl
    minikube
    terraform
    awscli2
    kubernetes-helm
    sqlite
    postgresql
    virt-manager

    htop
    btop
    amdgpu_top

    xorg.xprop
    xorg.xkill

    networkmanagerapplet
    networkmanager_dmenu

    vault
    onlyoffice-bin
    rcon
    rconc
    monero-gui

    spice
    spice-gtk
    spice-vdagent

    kdePackages.dolphin
    kdePackages.filelight

    ddev

    calc
    rpi-imager
    light

    google-cloud-sdk-gce
    kubo

    megasync

    betterdiscord-installer
    air

    catppuccin-kvantum
    themechanger
  ];
}