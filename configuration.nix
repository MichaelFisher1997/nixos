# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./packages.nix
      ./mnt.nix
      ./docker.nix
      ./hyprland.nix
      ./networking.nix
      #./i3.nix
    ];
    

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "cgroup_enable=cpuset,cpu,cpuacct,blkio,devices,freezer,net_cls,perf_event,net_prio,hugetlb,pids"
  ];
  boot.supportedFilesystems = [ "ntfs" ];
#  boot.supportedFilesystems = [ "zfs" ];
#  boot.zfs.forceImportRoot = false;
#  networking.hostId = "a44f5fde";
#  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;
  nixpkgs.config.allowBroken = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services = {
    # Enable X11 and configure Wayland support
    xserver = {
      enable = true;
      xkb.layout = "gb";
      xkb.variant = "";
      videoDrivers = ["amdgpu"];

      # Enable GDM as the display manager
      displayManager.gdm.enable = true;

      # Desktop Managers Configuration
      desktopManager = {
        gnome.enable = true;       # GNOME
        plasma6.enable = true;     # Use plasma5 for KDE6 as well
      };

      # Window Managers Configuration
      windowManager = {
        i3 = {
          enable = true;
          package = pkgs.i3-gaps; # Optional: use i3-gaps for gaps support
          extraPackages = with pkgs; [
            i3lock
            rofi
            lxappearance
          ];
        };
        # Note: No need to enable Hyprland here, as it's done in hyprland.nix
      };
    };
  };

  # XDG Portals Configuration for Wayland
  xdg.portal = {
    enable = flase;
    extraPortals = [
      pkgs.xdg-desktop-portal
    ];
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  sound.enable = true;
  services.flatpak.enable = true;
  services.blueman.enable = true;
  security.rtkit.enable = true;
  services.gvfs.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    #alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.micqdf = {
    isNormalUser = true;
    description = "micqdf";
    extraGroups = [ "networkmanager" "wheel" "docker"];
  };
 # environment.systemPackages = [
 #   pkgs.home-manager
 # ];

  # Install programs config
  programs.java.enable = true;
  programs.sway.enable = true;


  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
    #nixpkgs.overlays = [
    #  (import ./godot4-overlay.nix)
    #];

  #hardware.opengl.driSupport = true; # This is already enabled by default
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };
  #cosmic
  #hardware.system76.enableAll = true;
  #services.desktopManager.cosmic.enable = true;
  #services.displayManager.cosmic-greeter.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  programs.gamemode.enable = true;
    programs.ssh.askPassword = lib.mkForce "/nix/store/qjl45ra2yaqn88h6s9f7b79zpja9dy8b-seahorse-43.0/libexec/seahorse/ssh-askpass";

#  # List services that you want to enable:
#  environment.sessionVariables = {
#  	STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/micqdf/.steam/root/compatibilitytools.d";
#  	hyprshot = "/home/micqdf/flakes/hyprshot/Hyprshot";
#  };
#
  security.polkit.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.tumbler.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

}
