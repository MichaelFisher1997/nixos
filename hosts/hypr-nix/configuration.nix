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
    "usbcore.old_scheme_first=1"
    "amd_pstate=active"
    "split_lock_detect=off"
    "nowatchdog"
  ];
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_ratio" = 3;
    "vm.dirty_background_ratio" = 1;
    "kernel.perf_event_paranoid" = 1;
    "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    "net.core.netdev_max_backlog" = 30000;
  };
  boot.supportedFilesystems = [ "ntfs" ];
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;

  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableUserSlices = true;
    extraConfig = {
      DefaultMemoryPressureDurationSec = "5s";
    };
  };

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
    earlyoom = {
      enable = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 10;
      enableNotifications = true;
    };

    desktopManager = {
      plasma6 = {
        enable = false;
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

  services.gnome.gnome-keyring.enable = true;
  services.gnome.gnome-online-accounts.enable = lib.mkForce false;
  services.gnome.gnome-browser-connector.enable = false;
  environment.sessionVariables = {
    KWIN_DRM_NO_AMS = "1";
    MANGOHUD = "1";
  };

  swapDevices = [ 
    { device = "/swapfile"; size = 16384; }
  ];

  # zramSwap = {
  #   enable = false;  # Disabled - conflicting with swapfile
  # };

  virtualisation.waydroid.enable = false;

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  #sound.enable = true;
  services.flatpak.enable = true;
  services.blueman.enable = true;
  security.rtkit.enable = true;
  services.gvfs.enable = lib.mkForce false;
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

    # Low-latency audio configuration (safer settings to prevent crackling)
    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;
        default.clock.quantum = 512;      # ~10.7ms latency (safer)
        default.clock.min-quantum = 256;  # Minimum buffer size
        default.clock.max-quantum = 1024; # Maximum buffer size for stability
      };
    };
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
    # Disable audio suspension to prevent startup delays
    (writeTextDir "wireplumber/wireplumber.conf.d/60-no-suspend.conf" ''
      monitor.alsa.rules = [
        {
          matches = [
            { node.name = "~alsa_input.*" }
            { node.name = "~alsa_output.*" }
            { node.name = "~bluez_*" }
          ]
          actions = {
            update-props = {
              session.suspend-timeout-seconds = 0
            }
          }
        }
      ]
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
    after = [ "bluetooth.target" "pipewire.service" ];
    wants = [ "bluetooth.target" ];
    wantedBy = [ "default.target" ];
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

  # Faster shutdown - reduce timeout for services
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=15s
  '';

  # Ensure swap deactivates cleanly before unmount
  systemd.services.swap-off = {
    description = "Turn off swap before shutdown";
    wantedBy = [ "shutdown.target" ];
    before = [ "umount.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/swapoff -a";
      RemainAfterExit = true;
    };
  };

  # Make Docker start on-demand instead of at boot
  systemd.services.docker.wantedBy = lib.mkForce [];

  # Gaming performance optimizations
  powerManagement.cpuFreqGovernor = "performance";

}
