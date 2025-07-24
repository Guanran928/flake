{
  lib,
  inputs,
  pkgs,
  ...
}:
let
  pkgs' = inputs.chicken-box.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "cxk.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "file_server";
      root = pkgs'.default;
    };
  };
}
