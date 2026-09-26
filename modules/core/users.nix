{ vars, lib, pkgs, unstable, ... }:
let
  fishPackage = unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.fish;
in
{
  programs.fish.enable = true;
  programs.fish.package = fishPackage;
  # Fish 4.8 no longer ships the generator expected by NixOS 25.11.
  programs.fish.generateCompletions = false;

  users.users.${vars.user.name} = {
    isNormalUser = true;
    description = vars.user.description;
    extraGroups = vars.user.groups;
    shell = fishPackage;
    openssh.authorizedKeys.keys = builtins.filter (key: key != "") (lib.splitString "\n" (builtins.readFile ../../keys/infra.pub));
  };
}
