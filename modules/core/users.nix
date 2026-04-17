{ vars, lib, ... }:
{
  users.users.${vars.user.name} = {
    isNormalUser = true;
    description = vars.user.description;
    extraGroups = vars.user.groups;
    openssh.authorizedKeys.keys = builtins.filter (key: key != "") (lib.splitString "\n" (builtins.readFile ../../keys/infra.pub));
  };
}
