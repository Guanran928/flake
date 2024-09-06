{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (config.lib) ports;
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
        modules = {
          http_2xx = {
            prober = "http";
          };
        };
      };
    };

    scrapeConfigs = [
      {
        job_name = "metrics";
        scheme = "https";
        basic_auth = {
          username = "prometheus";
          password_file = config.sops.secrets."prometheus/auth".path;
        };
        static_configs = lib.singleton {
          targets = [
            "tyo0.ny4.dev"
            "pek0.ny4.dev"
          ];
        };
      }
      {
        job_name = "http";
        scheme = "http";
        metrics_path = "/probe";
        params = {
          module = [ "http_2xx" ];
        };
        static_configs = lib.singleton {
          targets = [
            "https://blog.ny4.dev"
            "https://cinny.ny4.dev"
            "https://element.ny4.dev"
            "https://git.ny4.dev"
            "https://id.ny4.dev"
            "https://mastodon.ny4.dev"
            "https://matrix.ny4.dev"
            "https://ntfy.ny4.dev"
            "https://pb.ny4.dev"
            "https://reddit.ny4.dev"
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
              expr = ''up == 0'';
              for = "5m";
            }
            {
              alert = "HTTPDown";
              expr = ''probe_http_status_code < 200 or probe_http_status_code > 299'';
              for = "5m";
            }
            {
              alert = "MemoryFull";
              expr = ''node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes < 0.1'';
              for = "5m";
            }
            {
              alert = "DiskFull";
              expr = ''node_filesystem_avail_bytes{mountpoint=~"/|/mnt"} / node_filesystem_size_bytes < 0.1'';
            }
            {
              alert = "UnitFailed";
              expr = ''node_systemd_unit_state{state="failed"} == 1'';
            }
          ];
        };
      }
    );

    alertmanagers = lib.singleton {
      static_configs = lib.singleton {
        targets = [
          "127.0.0.1:${toString ports.alertmanager}"
        ];
      };
    };

    alertmanager = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = ports.alertmanager;

      configuration = {
        receivers = lib.singleton {
          name = "ntfy";
          webhook_configs = lib.singleton {
            url = "https://ntfy.ny4.dev/alert";
          };
        };
        route = {
          receiver = "ntfy";
        };
      };
    };
  };

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton {
      host = [ "prom.ny4.dev" ];
    };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "127.0.0.1:${toString ports.prometheus}"; } ];
    };
  };
}
