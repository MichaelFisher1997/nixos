{ pkgs, ... }: {
  home.username = "micqdf";
  home.homeDirectory = "/home/micqdf";
  home.stateVersion = "24.11";

  programs.fish.enable = true;

  programs.git = {
    enable = true;
    userName = "MichaelFisher1997";
  };

  home.packages = with pkgs; [
#    neovim
#    firefox
#    ripgrep
    #zen-browser.packages.${pkgs.system}.twilight
    #zen-browser.packages."${system}".twilight
  ];
}

