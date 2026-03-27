{ pkgs, ... }:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      rocmPackages.rpp
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
      libvdpau-va-gl
      libva-vdpau-driver
      mesa
    ];
  };

  environment.sessionVariables = {
    MESA_LOADER_DRIVER_OVERRIDE = "radeonsi";
  };
}
