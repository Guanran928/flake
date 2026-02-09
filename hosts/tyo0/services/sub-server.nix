{ lib, ... }:
{
  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "sub.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "subroute";
      routes = [
        {
          handle = [
            {
              handler = "headers";
              response.set.Content-Type = [ "text/plain" ];
            }
            { handler = "templates"; }
          ];
        }
        {
          match = [ { not = [ { query.token = [ "*" ]; } ]; } ];
          handle = [
            {
              body = "Missing 'token' query parameter";
              handler = "static_response";
              status_code = 400;
            }
          ];
        }
        {
          handle = [
            {
              body = ''
                vless://{{.Req.URL.Query.Get "token"}}@lax0.ny4.dev:27253/?type=tcp&encryption=none&flow=xtls-rprx-vision&security=tls#Los%20Angeles
                vless://{{.Req.URL.Query.Get "token"}}@tyo0.ny4.dev:27253/?type=tcp&encryption=none&flow=xtls-rprx-vision&security=tls#Tokyo
              '';
              handler = "static_response";
            }
          ];
        }
      ];
    };
  };
}
