{ config, ... }:
{
  services.samba = {
    enable = true;
    openFirewall = true;
    shares."external" = {
      "path" = "/mnt";
      "read only" = "no";
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  users.users."guanranwang" = {
    uid = 1000;
    isNormalUser = true;
    createHome = false;
    useDefaultShell = false;
    hashedPasswordFile = config.sops.secrets."hashed-passwd".path;
  };
}
