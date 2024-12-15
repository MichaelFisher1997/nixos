{ pkgs, ... }:
#let
#  # When using easyCerts=true the IP Address must resolve to the master on creation.
# # So use simply 127.0.0.1 in that case. Otherwise you will have errors like this https://github.com/NixOS/nixpkgs/issues/59364
#  kubeMasterIP = "10.1.1.2";
#  kubeMasterHostname = "api.kube";
#  kubeMasterAPIServerPort = 6443;
#in
{
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
  	enable = true;
  	setSocketVariable = true;
  };
#  # resolve master hostname
#  networking.extraHosts = "${kubeMasterIP} ${kubeMasterHostname}";
#
#  # packages for administration tasks
#  environment.systemPackages = with pkgs; [
#    kompose
#    kubectl
#    kubernetes
#  ];
#
#  services.kubernetes = {
#    roles = ["master" "node"];
#    masterAddress = kubeMasterHostname;
#    apiserverAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";
#    easyCerts = true;
#    apiserver = {
#      securePort = kubeMasterAPIServerPort;
#      advertiseAddress = kubeMasterIP;
#    };
#
#    # use coredns
#    addons.dns.enable = true;
#
#    # needed if you use swap
#    kubelet.extraOpts = "--fail-swap-on=false";
#  };
}
