{ vars, lib, pkgs, ... }:
{
  programs.fish.enable = true;

  users.users.${vars.user.name} = {
    isNormalUser = true;
    description = vars.user.description;
    extraGroups = vars.user.groups;
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = builtins.filter (key: key != "") (lib.splitString "\n" (builtins.readFile ../../keys/infra.pub));
  };
}
