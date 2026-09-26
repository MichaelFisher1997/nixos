{
  hostName = "hypr-nix";
  
  nfs = {
    server = "10.27.27.239";
    exportPath = "/BigNAS";
  };

  bluetooth = {
    headsetMac = "84:9D:4B:09:B0:3B";
  };

  mounts = {
    ssd2Uuid = "bc0d1423-5682-4150-906f-b1a154a316ea";
  };

  user = {
    name = "micqdf";
    description = "micqdf";
    groups = [ "networkmanager" "wheel" "docker" "input" "video" "render" ];
  };

  desktop = {
    gnome = {
      videoDrivers = [ "amdgpu" ];
    };
  };
}
