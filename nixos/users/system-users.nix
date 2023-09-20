{ ... }:

{
  users.users."clash-meta" = {
    isSystemUser = true;
    group = "clash-meta";
  };
  users.groups.clash-meta = {};
}