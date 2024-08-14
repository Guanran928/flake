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

  # why not substituteAll? see https://github.com/NixOS/nixpkgs/issues/237216
  sops.templates."clash.yaml".file = let
    substituteAll' = {src, ...} @ args: let
      args' = lib.removeAttrs args ["src"];
    in
      pkgs.substitute {
        inherit src;
        substitutions = lib.flatten (lib.mapAttrsToList (n: v: ["--subst-var-by" n v]) args');
      };
  in
    substituteAll' {
      src = ./config.yaml;
      inherit
        (config.sops.placeholder)
        "clash/secret"
        "clash/proxies/lightsail"
        "clash/proxy-providers/efcloud"
        "clash/proxy-providers/spcloud"
        ;
    };
}
