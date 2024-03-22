{
  pkgs,
  config,
  ...
}: {
  services.mihomo = {
    enable = true;
    configFile = config.sops.templates."clash.yaml".path;
    webui = config.nur.repos.guanran928.metacubexd;
  };

  systemd.services.mihomo.serviceConfig.ExecStartPre = [
    "${pkgs.coreutils}/bin/ln -sf ${pkgs.v2ray-geoip}/share/v2ray/geoip.dat /var/lib/private/mihomo/GeoIP.dat"
    "${pkgs.coreutils}/bin/ln -sf ${pkgs.v2ray-domain-list-community}/share/v2ray/geosite.dat /var/lib/private/mihomo/GeoSite.dat"
  ];

  ### System proxy settings
  networking.proxy.default = "http://127.0.0.1:7890/";
  environment.shellAliases = let
    inherit (config.networking) proxy;
  in {
    "setproxy" = "export http_proxy=${proxy.httpProxy} https_proxy=${proxy.httpsProxy} all_proxy=${proxy.allProxy} ftp_proxy=${proxy.ftpProxy} rsync_proxy=${proxy.rsyncProxy}";
    "unsetproxy" = "set -e http_proxy https_proxy all_proxy ftp_proxy rsync_proxy";
  };

  ### sops-nix
  sops.secrets = builtins.mapAttrs (_name: value: value // {restartUnits = ["mihomo.service"];}) {
    "clash/secret" = {};
    "clash/proxy-providers/flyairport" = {};
    "clash/proxy-providers/efcloud" = {};
    "clash/proxy-providers/kogeki" = {};
    "clash/proxy-providers/spcloud" = {};
  };

  sops.templates."clash.yaml".content = let
    convert = url: "https://sub.maoxiongnet.com/sub?target=clash&list=true&url=${url}";
  in
    builtins.readFile ./config.yaml
    + ''
      secret: "${config.sops.placeholder."clash/secret"}"
      proxy-providers:
        flyairport:
          <<: *fetch
          url: "${config.sops.placeholder."clash/proxy-providers/flyairport"}"
        efcloud:
          <<: *fetch
          url: "${config.sops.placeholder."clash/proxy-providers/efcloud"}"
        kogeki:
          <<: *fetch
          url: "${config.sops.placeholder."clash/proxy-providers/kogeki"}"
        spcloud:
          <<: *fetch
          url: "${config.sops.placeholder."clash/proxy-providers/spcloud"}"

        # Free servers that I dont really care about
        pawdroid:
          <<: *fetch
          url: "${convert "https://cdn.jsdelivr.net/gh/Pawdroid/Free-servers@main/sub"}"
        ermaozi:
          <<: *fetch
          url: "${convert "https://cdn.jsdelivr.net/gh/ermaozi/get_subscribe@main/subscribe/v2ray.txt"}"
        #jsnzkpg:
        #  <<: *fetch
        #  url: "${convert "https://cdn.jsdelivr.net/gh/Jsnzkpg/Jsnzkpg@Jsnzkpg/Jsnzkpg"}"
    '';
}
