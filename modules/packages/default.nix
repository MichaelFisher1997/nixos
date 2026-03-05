{ pkgs, zen-browser, ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-33.4.11"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
    htop
    btop
    pciutils
    usbutils

    btrfs-progs
    nfs-utils
    ntfs3g
    parted
    gptfdisk
    smartmontools

    tailscale
    ipmitool
  ];
}
