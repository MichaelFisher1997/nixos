{ vars, ... }:
{
  users.users.${vars.user.name} = {
    isNormalUser = true;
    description = vars.user.description;
    extraGroups = vars.user.groups;
  };
}