{ ... }:
{
  imports = [
    ../../modules/core/boot-common.nix
  ];

  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/nvme0n1";
      useOSProber = true;
    };
  };

  boot.extraModprobeConfig = ''
    options btusb reset=1
  '';
}
