{ lib, ... }:
{
  virtualisation.docker.enable = true;

  systemd.sockets.docker = {
    wantedBy = [ "sockets.target" ];
    listenStreams = [ "/run/docker.sock" ];
    socketConfig = {
      SocketMode = "0660";
      SocketUser = "root";
      SocketGroup = "docker";
    };
  };

  systemd.services.docker = {
    enable = true;
    wants = [ "docker.socket" ];
    after = [ "docker.socket" ];
    wantedBy = lib.mkForce [];
    serviceConfig = {
      ExecStartPre = "-/usr/bin/rm -f /run/docker.sock";
    };
  };
}