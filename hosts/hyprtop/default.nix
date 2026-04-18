{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./laptop.nix

    ../../modules/profiles/desktop-base.nix

    ../../modules/hardware/gpu-intel.nix
  ];

  system.stateVersion = "23.11";
}
