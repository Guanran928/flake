{
  inputs,
  pkgs,
  lib,
  ...
}: let
  env = {
    "http_proxy" = "http://127.0.0.1:7890";
    "https_proxy" = "http://127.0.0.1:7890";
    "ftp_proxy" = "http://127.0.0.1:7890";
    "rsync_proxy" = "http://127.0.0.1:7890";
  };
in {
  # TODO: not run as root

  # Proxy environment variables
  environment.variables = env;
  launchd.daemons."nix-daemon".environment = env;

  # launchd service
  launchd.daemons."clash-meta" = {
    command = "${lib.getExe pkgs.clash-meta} -d /etc/clash-meta";
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive.NetworkState = true;
    };
  };

  # Web interface
  environment.etc."clash-meta/metacubexd".source = inputs.self.packages.${pkgs.system}.metacubexd;
}
