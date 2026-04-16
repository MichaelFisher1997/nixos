{
  hostName = "hyprtop";

  nfs = {
    server = "10.27.27.239";
    exportPath = "/BigNAS";
  };

  user = {
    name = "micqdf";
    description = "micqdf";
    groups = [ "networkmanager" "wheel" "docker" "input" "video" "render" ];
  };
}
