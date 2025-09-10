{
  lib,
  config,
  ports,
  ...
}:
let
  port = ports.rustical;
in
{
  services.rustical = {
    enable = true;
    environmentFile = config.sops.secrets."rustical/environment".path;
    settings = {
      http = {
        inherit port;
        host = "127.0.0.1";
      };

      oidc = {
        name = "id.ny4.dev";
        issuer = "https://id.ny4.dev";
        client_id = "7d1dec55-1da7-44eb-a1ce-3ce24d73414b";
        scopes = [
          "openid"
          "profile"
          "groups"
        ];
        allow_sign_up = true;
      };
    };
  };

  sops.secrets."rustical/environment" = {
    restartUnits = [ "rustical.service" ];
  };

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "cal.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "127.0.0.1:${toString port}"; } ];
    };
  };
}
