{ ... }:
{
  imports = [
    ./boot-common.nix
  ];

  boot.initrd.kernelModules = [ "amdgpu" "vfio_pci" ];

  boot.kernelParams = [
    "amd_pstate=active"
    "vfio-pci.ids=1e4b:1202"
    "amdgpu.gpu_recovery=1"
    "amdgpu.lockup_timeout=10000"
  ];

  boot.extraModprobeConfig = ''
    options btusb reset=1
    options r8169 rx_copybreak=256
    softdep nvme pre: vfio-pci
  '';
}
