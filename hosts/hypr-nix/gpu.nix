{ pkgs, ... }:
{
  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];
  environment.systemPackages = [
    pkgs.rocmPackages.rpp
	];

}
