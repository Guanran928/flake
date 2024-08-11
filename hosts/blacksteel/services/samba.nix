{
  services.samba = {
    enable = true;
    openFirewall = true;
    shares = {
      "share" = {
        path = "/srv/samba/share";
        "read only" = "no";
      };
      "external" = {
        path = "/mnt";
        "read only" = "no";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  systemd.tmpfiles.rules = [
    "d /srv/samba/share 0755 guanranwang root"
  ];
}
