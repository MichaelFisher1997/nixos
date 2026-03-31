{ pkgs, ... }:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      rocmPackages.rpp
      vulkan-loader
      vulkan-extension-layer
      libvdpau-va-gl
      libva-vdpau-driver
      mesa
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-loader
      libvdpau-va-gl
      libva-vdpau-driver
    ];
  };

  environment.sessionVariables = {
    MESA_LOADER_DRIVER_OVERRIDE = "radeonsi";
  };
}
