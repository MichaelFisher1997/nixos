# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./packages.nix
      ./mnt.nix
      ./docker.nix
      ./hyprland.nix
      ./networking.nix
      ./gpu.nix
      ./sunshine.nix
      #./i3.nix
    ];


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "btusb" "btintel" "btrtl" "xpad" "usbhid" "hid_generic" ]; # Load Bluetooth and Xbox controller modules
  boot.kernelPackages = pkgs.linuxPackages_latest;
  nix.package = pkgs.nixVersions.latest;

  # Optional but recommended:
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  boot.kernelParams = [
    "cgroup_enable=cpuset,cpu,cpuacct,blkio,devices,freezer,net_cls,perf_event,net_prio,hugetlb,pids"
    "usbcore.old_scheme_first=1"  # Fix for older USB devices on newer controllers
  ];
  boot.supportedFilesystems = [ "ntfs" ];
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;

  #  boot.supportedFilesystems = [ "zfs" ];
  #  boot.zfs.forceImportRoot = false;
  #  networking.hostId = "a44f5fde";
  #  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;
  networking.dhcpcd.enable = false; # Disable dhcpcd to speed up boot (NetworkManager handles DHCP)
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
    desktopManager = {
      plasma6 = {
        enable = true;
        enableQt5Integration = false; # Fix KDE logout hanging issue
      };
    };
    xserver = {
      enable = true;
      xkb.layout = "gb";
      xkb.variant = "";
      videoDrivers = [ "amdgpu" ];

      # Enable GDM as the display manager
      displayManager.gdm.enable = true;

      # Desktop Managers Configuration
      desktopManager = {
        gnome.enable = true; # GNOME
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

  # Disable GNOME desktop services that might conflict
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gnome-online-accounts.enable = lib.mkForce false;
  
  # Additional KDE logout fixes
  services.xserver.desktopManager.plasma6.notoPackage = pkgs.noto-fonts;
  environment.sessionVariables = {
    KWIN_DRM_NO_AMS = "1";
    MANGOHUD = "1";
  };

  # Add swap file to prevent system freezing at high memory usage
  swapDevices = [ 
    { device = "/swapfile"; size = 16384; } # 16GB swap file
  ];

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  #sound.enable = true;
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



  # Configure PipeWire to prefer A2DP and prevent profile switching
  services.pipewire.wireplumber.configPackages = with pkgs; [
    (writeTextDir "wireplumber/wireplumber.conf.d/50-bluetooth-policy.conf" ''
      monitor.bluez.properties = {
        bluez5.auto-switch-profile = [ "off" ]
        bluez5.prefer-a2dp = true
        bluez5.headset-roles = [ ]
        bluez5.hfphsp-backend = "none"
      }
    '')
  ];

  # Additional Bluetooth audio configuration to force A2DP
  environment.etc."wireplumber/bluetooth.lua.d/99-force-a2dp.lua" = {
    text = ''
      -- Force A2DP profile and disable HSP/HFP
      rule = {
        matches = {
          {
            { "device.name", "matches", "bluez_card.*" },
          },
        },
        apply_properties = {
          ["bluez5.auto-connect"] = "[ a2dp_sink ]",
          ["bluez5.auto-switch-profile"] = false,
          ["bluez5.disable-headset-profile"] = true,
        }
      }
      table.insert(bluez_monitor.rules, rule)
    '';
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.micqdf = {
    isNormalUser = true;
    description = "micqdf";
    extraGroups = [ "networkmanager" "wheel" "docker" "input" "video" "render" ];
  };

  # Install programs config
  programs.java.enable = true;
  programs.nix-ld.enable = true;
  programs.sway.enable = true;
  # Hyprland configured in ./hyprland.nix
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-33.4.11"
  ];

  #hardware.opengl.driSupport = true; # This is already enabled by default
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  
  
  # Add firmware for Intel AX210 and Realtek Bluetooth
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
    Policy = {
      AutoEnable = true;
    };
  };
  # Disable Realtek Bluetooth adapter, keep only Intel
  # Removed conflicting Bluetooth blacklist - we want Bluetooth to work
  boot.extraModprobeConfig = ''
    # Ensure btusb module works properly for Realtek adapter
    options btusb reset=1
  '';
  # Auto-connect Bluetooth headset after boot
  systemd.user.services.bluetooth-headset-autoconnect = {
    description = "Auto-connect Bluetooth headset after boot";
    after = [ "bluetooth.target" "pulseaudio.service" "pipewire.service" ];
    wants = [ "bluetooth.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bluez}/bin/bluetoothctl connect 41:42:32:63:0D:E8";
      RemainAfterExit = "yes";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # Use KDE's SSH askpass to resolve conflict
  programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";

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
  system.stateVersion = "24.11"; # Did you read the comment?
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

}
