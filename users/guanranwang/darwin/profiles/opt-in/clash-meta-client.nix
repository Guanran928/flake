{
  inputs,
  pkgs,
  ...
}: {
  environment.variables = {
    "http_proxy" = "http://127.0.0.1:7890";
    "https_proxy" = "http://127.0.0.1:7890";
    "ftp_proxy" = "http://127.0.0.1:7890";
    "rsync_proxy" = "http://127.0.0.1:7890";
  };

  launchd.daemons."nix-daemon".environment = {
    "http_proxy" = "http://127.0.0.1:7890";
    "https_proxy" = "http://127.0.0.1:7890";
    "ftp_proxy" = "http://127.0.0.1:7890";
    "rsync_proxy" = "http://127.0.0.1:7890";
  };

  launchd.daemons."clash-meta" = {
    command = "${pkgs.clash-meta}/bin/clash-meta -d /etc/clash-meta";
  };

  environment.etc."clash-meta/metacubexd".source = inputs.self.packages.${pkgs.system}.metacubexd;
}
