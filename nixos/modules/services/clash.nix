{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.clash;
in {
  options.services.clash = {
    enable = lib.mkEnableOption "Whether to enable Clash, A rule-based proxy in Go";
    package = lib.mkPackageOption pkgs "clash" {};

    # TODO
    webui = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
    };
    configFile = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
    };
    extraOpts = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.string;
    };
  };

  config = lib.mkIf cfg.enable {
    ### User running clash
    users.groups."clash" = {};
    users.users."clash" = {
      isSystemUser = true;
      group = config.users.groups."clash".name;
    };

    ### systemd service
    # https://en.clash.wiki/introduction/service.html#systemd
    # https://wiki.metacubex.one/startup/service/#systemd
    systemd.services."clash" = {
      description = "Clash daemon, A rule-based proxy in Go.";
      after = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        # TODO: DynamicUser
        # DynamicUser = true;
        # LoadCredential = "credentials:${config.sops.secrets."clash-config".path}";

        # https://man.archlinux.org/man/systemd.exec.5
        ConfigurationDirectory = "clash";
        User = config.users.users."clash".name;
        Group = config.users.groups."clash".name;
        ExecStart = builtins.replaceStrings ["\n"] [" "] ''
          ${lib.getExe cfg.package}
          -d /etc/clash
          ${lib.optionalString (cfg.webui != null) "-ext-ui ${cfg.webui}"}
          ${lib.optionalString (cfg.configFile != null) "-f ${cfg.configFile}"}
          ${lib.optionalString (cfg.extraOpts != null) cfg.extraOpts}
        '';

        # Capability, inherited from Clash wiki
        # https://man.archlinux.org/man/core/man-pages/capabilities.7.en
        CapabilityBoundingSet = ["CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" "CAP_NET_RAW"];
        AmbientCapabilities = ["CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" "CAP_NET_RAW"];

        # Hardening, experimental since I have no idea what am I doing
        NoNewPrivileges = true;
        MemoryDenyWriteExecute = true;
        LockPersonality = true;

        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        ProtectSystem = "strict";
        ProtectProc = "noaccess";
        ProtectHome = true;
        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectHostname = true;
        ProtectKernelTunables = true;

        PrivateDevices = true;
        #PrivateNetwork = true;
        PrivateTmp = true;
        PrivateUsers = true;
        PrivateMounts = true;
      };
    };
  };
}
