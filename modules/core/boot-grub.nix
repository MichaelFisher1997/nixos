{ vars, ... }:
let
  grubConfig = (vars.boot or {}).grub or {};
in
{
  boot.loader.grub = {
    enable = true;
    device = grubConfig.device or "/dev/nvme0n1";
    useOSProber = grubConfig.useOSProber or true;
  };
}
