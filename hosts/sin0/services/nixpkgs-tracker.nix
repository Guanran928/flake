{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "nix.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "file_server";
      root = inputs.nixpkgs-tracker.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };
}
