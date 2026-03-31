{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
    # Add Proton-GE for better NixOS compatibility
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
        desiredgov = "performance";
        softrealtime = "off";
        inhibit_screensaver = 1;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
    };
  };

  services.udev.extraRules = ''
    KERNEL=="event[0-9]*", SUBSYSTEM=="input", MODE="0664", GROUP="input"
    KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
  '';

  environment.systemPackages = with pkgs; [
    protonup-qt
    gamescope
  ];
}
