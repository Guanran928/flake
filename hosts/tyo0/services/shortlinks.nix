{ lib, ... }:
{
  services.caddy.settings.apps.http.servers.srv0.routes =
    [
      {
        from = [
          "/telegram"
          "/tg"
        ];
        to = "https://t.me/guanranwang";
      }
      {
        from = [ "/github" ];
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
        from = [ "/steam" ];
        to = "https://steamcommunity.com/profiles/76561198855505856";
      }
    ]
    |> lib.map (x: {
      match = lib.singleton {
        host = [ "ny4.dev" ];
        path = x.from;
      };
      handle = lib.singleton {
        handler = "static_response";
        status_code = 302;
        headers = {
          Location = [ x.to ];
        };
      };
    });
}
