{ ... }:

{
  # Enable Docker program itself
  virtualisation.docker.enable = true;

  # Create a socket to lazy-load Docker
  systemd.sockets.docker = {
    wantedBy = [ "sockets.target" ];
    listenStreams = [ "/run/docker.sock" ];
    socketConfig = {
      SocketMode = "0660";
      SocketUser = "root";
      SocketGroup = "docker";
    };
  };

  # Override the Docker service to disable autostart
  systemd.services.docker = {
    enable = true;
    wants = [ "docker.socket" ];
    after = [ "docker.socket" ];
    serviceConfig = {
      ExecStartPre = "-/usr/bin/rm -f /run/docker.sock";
    };
  };
}

