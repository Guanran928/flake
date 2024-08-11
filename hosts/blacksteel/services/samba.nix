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
}
