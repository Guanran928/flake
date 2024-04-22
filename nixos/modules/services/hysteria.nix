{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.services.hysteria;
in {
  options.services.hysteria = {
    enable = lib.mkEnableOption "Hysteria, a powerful, lightning fast and censorship resistant proxy";

    package = lib.mkPackageOption pkgs "hysteria" {};

    mode = lib.mkOption {
      type = lib.types.enum ["server" "client"];
      default = "server";
    };

    configFile = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "Configuration file to use.";
    };

    credentials = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Extra credentials loaded by systemd, you can access them by `/run/credentials/hysteria.service/foobar`.";
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services."hysteria" = {
      description = "Hysteria daemon, a powerful, lightning fast and censorship resistant proxy.";
      documentation = ["https://hysteria.network/docs/getting-started/Installation/"];
      wantedBy = ["multi-user.target"];
      after = ["network-online.target"];
      wants = ["network-online.target"];
      serviceConfig = {
        ExecStart = lib.concatStringsSep " " [
          (lib.getExe cfg.package)
          cfg.mode
          "--disable-update-check"
          "--config $\{CREDENTIALS_DIRECTORY}/config.yaml"
        ];

        DynamicUser = true;
        StateDirectory = "hysteria";
        LoadCredential = ["config.yaml:${cfg.configFile}"] ++ cfg.credentials;

        ### Hardening
        AmbientCapabilities = ["CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" "CAP_NET_RAW"];
        CapabilityBoundingSet = ["CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" "CAP_NET_RAW"];
        NoNewPrivileges = true;
        PrivateMounts = true;
        PrivateTmp = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service bpf";
        UMask = "0077";
      };
    };
  };
}
