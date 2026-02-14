{
  hostName = "hypr-nix";
  
  nfs = {
    server = "10.27.27.239";
    exportPath = "/BigNAS";
  };

  bluetooth = {
    headsetMac = "41:42:32:63:0D:E8";
  };

  mounts = {
    ssd2Uuid = "bc0d1423-5682-4150-906f-b1a154a316ea";
  };

  user = {
    name = "micqdf";
    description = "micqdf";
    groups = [ "networkmanager" "wheel" "docker" "input" "video" "render" ];
  };
}