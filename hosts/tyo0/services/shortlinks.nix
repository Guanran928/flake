{ lib, ... }:
let
  makeCaddyConfig = lib.map (x: {
    match = [
      {
        host = [ "ny4.dev" ];
        path = x.from;
      }
    ];
    handle = [
      {
        handler = "static_response";
        status_code = 302;
        headers = {
          Location = [ x.to ];
        };
      }
    ];
  });
in
{
  services.caddy.settings.apps.http.servers.srv0.routes = makeCaddyConfig [
    {
      from = [
        "/telegram"
        "/tg"
      ];
      to = "https://t.me/guanranwang";
    }
    {
      from = [
        "/github"
      ];
      to = "https://github.com/guanran928";
    }
    {
      from = [
        "/mastodon"
        "/fedi"
      ];
      to = "https://mastodon.ny4.dev/@nyancat";
    }
    {
      from = [
        "/twitter"
        "/x"
      ];
      to = "https://x.com/Guanran928";
    }
    {
      from = [
        "/steam"
      ];
      to = "https://steamcommunity.com/profiles/76561198855505856";
    }
  ];
}
