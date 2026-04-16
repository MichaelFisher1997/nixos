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
      mesa
      libva-utils
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-loader
      mesa
    ];
  };

  environment.sessionVariables = {
    MESA_LOADER_DRIVER_OVERRIDE = "radeonsi";
  };
}
