{
  lib,
  pkgs,
  config,
  nodes,
  ...
}:
let
  proxyServers = lib.filterAttrs (_name: value: lib.elem "proxy" value.tags) nodes;
in
{
  services.sing-box = {
    enable = true;
    settings = {
      log = {
        level = "info";
      };

      dns = {
        servers = [
          {
            tag = "cloudflare";
            address = "https://[2606:4700:4700::1111]/dns-query";
            strategy = "prefer_ipv6";
          }
          {
            tag = "local";
            address = "local";
            strategy = "prefer_ipv4";
          }
        ];
        rules = lib.singleton {
          rule_set = [
            "geoip-cn"
            "geosite-cn"
            "geosite-private"
          ];
          # avoid querying proxy server's dns from proxy server
          domain = lib.mapAttrsToList (_name: node: node.fqdn) proxyServers;
          ip_is_private = true;
          server = "local";
        };
        final = "cloudflare";
      };

      inbounds = lib.singleton {
        type = "http";
        tag = "inbound";
        listen = "127.0.0.1";
        listen_port = 1080;
        sniff = true;
        sniff_override_destination = true;
      };

      outbounds =
        lib.mapAttrsToList (n: v: {
          type = "vless";
          tag = n;
          server = v.fqdn;
          server_port = 27253;
          uuid._secret = config.sops.secrets."sing-box/uuid".path;
          flow = "xtls-rprx-vision";
          tls.enabled = true;
        }) proxyServers
        ++ [
          {
            type = "selector";
            tag = "select";
            outbounds = [
              "tyo0"
              "sin0"
              "direct"
            ];
            default = "tyo0";
          }
          {
            type = "direct";
            tag = "direct";
          }
        ];

      route = {
        rules = lib.singleton {
          rule_set = [
            "geoip-cn"
            "geosite-cn"
            "geosite-private"
          ];
          ip_is_private = true;
          outbound = "direct";
        };

        rule_set = [
          {
            tag = "geoip-cn";
            type = "local";
            format = "binary";
            path = "${pkgs.sing-geoip}/share/sing-box/rule-set/geoip-cn.srs";
          }
          {
            tag = "geosite-cn";
            type = "local";
            format = "binary";
            path = "${pkgs.sing-geosite}/share/sing-box/rule-set/geosite-cn.srs";
          }
          {
            tag = "geosite-private";
            type = "local";
            format = "binary";
            path = "${pkgs.sing-geosite}/share/sing-box/rule-set/geosite-private.srs";
          }
        ];

        final = "select";
      };
    };
  };

  ### System proxy settings
  networking.proxy = {
    httpProxy = "http://127.0.0.1:1080/";
    httpsProxy = "http://127.0.0.1:1080/";
  };

  programs.fish.shellAliases =
    let
      inherit (config.networking.proxy) httpProxy httpsProxy;
    in
    {
      "setproxy" = "export http_proxy=${httpProxy} https_proxy=${httpsProxy}";
      "unsetproxy" = "set -e http_proxy https_proxy";
    };

  ### sops-nix
  sops.secrets."sing-box/uuid" = {
    restartUnits = [ "sing-box.service" ];
    sopsFile = ./secrets.yaml;
  };
}
