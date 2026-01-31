{ lib, config, ... }:
{
  services.samba = {
    enable = true;
    settings."external" = {
      "path" = "/mnt";
      "read only" = "no";
    };
  };

  services.samba-wsdd = {
    enable = true;
  };

  systemd.targets.samba = {
    bindsTo = [ "mnt.mount" ];
    after = [ "mnt.mount" ];
    wantedBy = [ "mnt.mount" ];
  };

  # NOTE: this defaults to multi-user.target, maybe upstream?
  systemd.services.samba-wsdd = {
    partOf = [ "samba.target" ];
    wantedBy = lib.mkForce [ "samba.target" ];
  };

  users.users."guanranwang" = {
    uid = 1000;
    isNormalUser = true;
    createHome = false;
    useDefaultShell = false;
    hashedPasswordFile = config.sops.secrets."hashed-passwd".path;
  };
}
