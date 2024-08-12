{pkgs, ...}: {
  services.keycloak = {
    enable = true;
    settings = {
      cache = "local";
      hostname = "id.ny4.dev";
      http-host = "127.0.0.1";
      http-port = 8800;
      proxy = "edge";
      # proxy-headers = "xforwarded"; # FIXME: Key material not provided to setup HTTPS.
    };
    database.passwordFile = toString (pkgs.writeText "password" "keycloak");
  };
}
