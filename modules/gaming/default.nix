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
    settings = {
      general = {
        renice = 10;
        desiredgov = "performance";
        softrealtime = "off";
        inhibit_screensaver = 1;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    protonup-qt
    gamescope
  ];
}
