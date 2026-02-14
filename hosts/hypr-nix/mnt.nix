{ ... }:

{
  services.rpcbind.enable = true; # needed for NFS
  boot.supportedFilesystems = [ "nfs" ]; # Enable NFS support
  
  # Create required NFS state directories and mount points
  systemd.tmpfiles.rules = [
    "d /var/lib/nfs 0755 root root -"
    "d /var/lib/nfs/sm 0755 root root -"
    "d /var/lib/nfs/sm.bak 0755 root root -"
    "d /mnt/BigNAS 0755 root root -"
    "d /mnt/NVME 0755 root root -"
  ];

  # NFS mount - on-demand with automount for faster boot
  fileSystems."/mnt/BigNAS" = {
    device = "10.27.27.239:/BigNAS";
    fsType = "nfs";
    options = [
      "noatime"
      "nofail"
      "x-systemd.automount"           # Mount on first access
      "x-systemd.idle-timeout=600"    # Unmount after 10min idle
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=10s"
      "soft"
      "timeo=50"
      "retrans=2"
    ];
  };

  # Workaround: Exclude NFS mounts from Flatpak sandbox to prevent bwrap errors
  # This creates a global Flatpak override that doesn't expose /mnt to sandboxes
  systemd.services.flatpak-nfs-workaround = {
    description = "Configure Flatpak to exclude NFS mounts";
    after = [ "network.target" "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      mkdir -p /var/lib/flatpak/overrides
      # Create global override to exclude problematic paths from sandbox
      cat > /var/lib/flatpak/overrides/global << 'EOF'
      [Context]
      filesystems=!/mnt;!/mnt/BigNAS;!/mnt/ssd2
      EOF
    '';
  };

  # NVME drive - currently disconnected (UUID not found)
  # Uncomment and update UUID when drive is reconnected
  # fileSystems."/mnt/NVME" = {
  #   device = "/dev/disk/by-uuid/15b96913-a018-4ecc-950c-b8cf74b93315";
  #   fsType = "btrfs";
  #   options = [ "compress=zstd" "nofail" "x-systemd.device-timeout=5s" ];
  # };
  fileSystems."/mnt/ssd2" = {
    device = "/dev/disk/by-uuid/bc0d1423-5682-4150-906f-b1a154a316ea";
    fsType = "btrfs";
    options = [ "nofail" "x-systemd.device-timeout=5s" ];
  };
}
