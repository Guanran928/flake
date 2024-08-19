{
  lib,
  pkgs,
  config,
  ...
}: {
  services.mihomo = {
    enable = true;
    configFile = config.sops.templates."clash.yaml".path;
    webui = pkgs.metacubexd;
  };

  systemd.services.mihomo.preStart = ''
    ${pkgs.coreutils}/bin/ln -sf ${pkgs.v2ray-geoip}/share/v2ray/geoip.dat /var/lib/private/mihomo/GeoIP.dat
    ${pkgs.coreutils}/bin/ln -sf ${pkgs.v2ray-domain-list-community}/share/v2ray/geosite.dat /var/lib/private/mihomo/GeoSite.dat
  '';

  ### System proxy settings
  networking.proxy.default = "http://127.0.0.1:7890/";
  environment.shellAliases = let
    inherit (config.networking) proxy;
  in {
    "setproxy" = "export http_proxy=${proxy.httpProxy} https_proxy=${proxy.httpsProxy} all_proxy=${proxy.allProxy} ftp_proxy=${proxy.ftpProxy} rsync_proxy=${proxy.rsyncProxy}";
    "unsetproxy" = "set -e http_proxy https_proxy all_proxy ftp_proxy rsync_proxy";
  };

  ### sops-nix
  sops.secrets = lib.mapAttrs (_name: value:
    value
    // {
      restartUnits = ["mihomo.service"];
      sopsFile = ./secrets.yaml;
    }) {
    "clash/secret" = {};
    "clash/proxies/lightsail" = {};
    "clash/proxy-providers/efcloud" = {};
    "clash/proxy-providers/spcloud" = {};
  };

  sops.templates."clash.yaml".file = pkgs.replaceVars ./config.yaml {
    inherit
      (config.sops.placeholder)
      "clash/secret"
      "clash/proxies/lightsail"
      "clash/proxy-providers/efcloud"
      "clash/proxy-providers/spcloud"
      ;
  };
}
