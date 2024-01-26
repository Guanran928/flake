{
  pkgs,
  config,
  inputs,
  ...
}: {
  services.clash = {
    enable = true;
    package = pkgs.clash-meta;
    configFile = config.sops.templates."clash.yaml".path;
    webui = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.metacubexd;
  };

  systemd.services.clash.serviceConfig.ExecStartPre = [
    "${pkgs.coreutils}/bin/ln -sf ${pkgs.v2ray-geoip}/share/v2ray/geoip.dat /var/lib/private/clash/GeoIP.dat"
    "${pkgs.coreutils}/bin/ln -sf ${pkgs.v2ray-domain-list-community}/share/v2ray/geosite.dat /var/lib/private/clash/GeoSite.dat"
  ];

  ### System proxy settings
  networking.proxy.default = "http://127.0.0.1:7890/";

  ### sops-nix
  sops.secrets = builtins.mapAttrs (_name: value: value // {restartUnits = ["clash.service"];}) {
    "clash/secret" = {};
    "clash/proxies/lon0" = {};
    "clash/proxy-providers/efcloud" = {};
    "clash/proxy-providers/spcloud" = {};
  };

  sops.templates."clash.yaml".content = let
    convert = url: "https://sub.maoxiongnet.com/sub?target=clash&list=true&url=${url}";
  in
    builtins.readFile ./config.yaml
    + ''
      secret: "${config.sops.placeholder."clash/secret"}"

      proxies:
        ${config.sops.placeholder."clash/proxies/lon0"}

      proxy-providers:
        efcloud:
          <<: *fetch
          url: "${config.sops.placeholder."clash/proxy-providers/efcloud"}"
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
