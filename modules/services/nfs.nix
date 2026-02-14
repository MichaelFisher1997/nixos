{ pkgs, vars, ... }:
{
  services.rpcbind.enable = true;
  boot.supportedFilesystems = [ "nfs" ];

  systemd.tmpfiles.rules = [
    "d /var/lib/nfs 0755 root root -"
    "d /var/lib/nfs/sm 0755 root root -"
    "d /var/lib/nfs/sm.bak 0755 root root -"
    "d /mnt/BigNAS 0755 root root -"
  ];

  fileSystems."/mnt/BigNAS" = {
    device = "${vars.nfs.server}:${vars.nfs.exportPath}";
    fsType = "nfs";
    options = [
      "noatime"
      "nofail"
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=10s"
      "soft"
      "timeo=50"
      "retrans=2"
    ];
  };

  fileSystems."/mnt/ssd2" = {
    device = "/dev/disk/by-uuid/${vars.mounts.ssd2Uuid}";
    fsType = "btrfs";
    options = [ "nofail" "x-systemd.device-timeout=5s" ];
  };

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
      cat > /var/lib/flatpak/overrides/global << 'EOF'
      [Context]
      filesystems=!/mnt;!/mnt/BigNAS;!/mnt/ssd2
      EOF
    '';
  };
}