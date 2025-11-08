{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.rocmPackages.rpp
  ];
  # Removed deprecated hardware.opengl - already configured in hardware.graphics below

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
      # Intel drivers removed - AMD system only
      libvdpau-va-gl
      vaapiVdpau
      mesa
      mesa.drivers
    ];
  };

  # Environment variables for proper GBM backend
  environment.sessionVariables = {
    GBM_BACKEND = "mesa";
    MESA_LOADER_DRIVER_OVERRIDE = "radeonsi";
  };
}
