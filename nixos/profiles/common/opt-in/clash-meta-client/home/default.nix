{osConfig, ...}: let
  inherit (osConfig.networking) proxy;
in {
  home.shellAliases = {
    "setproxy" = "export http_proxy=${proxy.httpProxy} https_proxy=${proxy.httpsProxy} all_proxy=${proxy.allProxy} ftp_proxy=${proxy.ftpProxy} rsync_proxy=${proxy.rsyncProxy}";
    "unsetproxy" = "set -e http_proxy https_proxy all_proxy ftp_proxy rsync_proxy";
  };
}
