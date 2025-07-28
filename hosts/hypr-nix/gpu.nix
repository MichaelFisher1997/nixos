{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.rocmPackages.rpp
  ];
  # Removed deprecated hardware.opengl - already configured in hardware.graphics below

  hardware.graphics = {
    enable = true;
    #driSupport = true;
    #driSupport32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
      # Intel drivers removed - AMD system only
      libvdpau-va-gl
      vaapiVdpau
      mesa
    ];
  };
}
