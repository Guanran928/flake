{
  lib,
  pkgs,
  config,
  nodes,
  ports,
  ...
}:
let
  targets = lib.mapAttrsToList (_name: node: node.fqdn) nodes ++ [ "pek0.ny4.dev" ];
in
{
  services.prometheus = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = ports.prometheus;
    webExternalUrl = "https://prom.ny4.dev";

    exporters.blackbox = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = ports.blackbox;
      configFile = (pkgs.formats.yaml { }).generate "config.yaml" {
        modules.http_2xx = {
          prober = "http";
          http.fail_if_not_ssl = true;
        };
      };
    };

    scrapeConfigs = [
      {
        job_name = "node_exporter";
        scheme = "https";
        metrics_path = "/metrics";
        basic_auth = {
          username = "prometheus";
          password_file = config.sops.secrets."prometheus/auth".path;
        };
        static_configs = lib.singleton { inherit targets; };
      }
      {
        job_name = "caddy";
        scheme = "https";
        metrics_path = "/caddy";
        basic_auth = {
          username = "prometheus";
          password_file = config.sops.secrets."prometheus/auth".path;
        };
        static_configs = lib.singleton { inherit targets; };
      }
      {
        job_name = "blackbox_exporter";
        static_configs = lib.singleton { targets = [ "127.0.0.1:${toString ports.blackbox}" ]; };
      }
      {
        job_name = "blackbox_probe";
        metrics_path = "/probe";
        params = {
          module = [ "http_2xx" ];
        };
        static_configs = lib.singleton {
          targets = [
            "https://blog.ny4.dev"
            "https://cinny.ny4.dev"
            "https://cxk.ny4.dev"
            "https://element.ny4.dev"
            "https://git.ny4.dev"
            "https://id.ny4.dev"
            "https://immich.ny4.dev"
            "https://ip.ny4.dev"
            "https://mastodon.ny4.dev"
            "https://matrix.ny4.dev"
            "https://ntfy.ny4.dev"
            "https://pb.ny4.dev"
            # FIXME: too flakey, suppressed
            # "https://reddit.ny4.dev"
            "https://rss.ny4.dev"
            "https://vault.ny4.dev"
          ];
        };
        relabel_configs = [
          {
            source_labels = [ "__address__" ];
            target_label = "__param_target";
          }
          {
            source_labels = [ "__param_target" ];
            target_label = "instance";
          }
          {
            target_label = "__address__";
            replacement = "127.0.0.1:${toString ports.blackbox}";
          }
        ];
      }

    ];

    rules = lib.singleton (
      builtins.toJSON {
        groups = lib.singleton {
          name = "metrics";
          rules = [
            {
              alert = "NodeDown";
              expr = ''up{job="node_exporter"} == 0'';
              for = "5m";
              annotations.summary = "Node exporter down on {{ $labels.instance }}";
            }
            {
              alert = "HTTPDown";
              expr = ''up{job="blackbox_probe"} == 0 or probe_success{job="blackbox_probe"} == 0'';
              for = "5m";
              annotations.summary = "HTTP probe failure on {{ $labels.instance }}";
            }
            {
              alert = "MemoryFull";
              expr = ''node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes < 0.1'';
              for = "5m";
              annotations.summary = "Low available memory on {{ $labels.instance }}";
            }
            {
              alert = "DiskFull";
              expr = ''node_filesystem_avail_bytes{mountpoint=~"/|/persist|/mnt"} / node_filesystem_size_bytes < 0.1'';
              annotations.summary = "Low disk space on {{ $labels.instance }}";
            }
            {
              alert = "UnitFailed";
              expr = ''node_systemd_unit_state{state="failed"} == 1'';
              annotations.summary = "Systemd unit {{ $labels.name }} failure on {{ $labels.instance }}";
            }
          ];
        };
      }
    );

    alertmanagers = lib.singleton {
      static_configs = lib.singleton { targets = [ "127.0.0.1:${toString ports.alertmanager}" ]; };
    };

    alertmanager = {
      enable = true;
      checkConfig = false;
      listenAddress = "127.0.0.1";
      port = ports.alertmanager;

      configuration = {
        receivers = lib.singleton {
          name = "telegram";
          telegram_configs = lib.singleton {
            bot_token_file = "/run/credentials/alertmanager.service/telegram";
            chat_id = 7672225115;
          };
        };
        route.receiver = "telegram";
      };
    };
  };

  sops.secrets = {
    "prometheus/auth" = {
      owner = config.systemd.services.prometheus.serviceConfig.User;
      restartUnits = [ "prometheus.service" ];
    };
    "alertmanager/telegram-token" = {
      restartUnits = [ "alertmanager.service" ];
    };
  };

  systemd.services.alertmanager.serviceConfig.LoadCredential = [
    "telegram:${config.sops.secrets."alertmanager/telegram-token".path}"
  ];

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "prom.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "127.0.0.1:${toString ports.prometheus}"; } ];
    };
  };
}
