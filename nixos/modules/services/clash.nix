{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.clash;
in {
  options.services.clash = {
    enable = lib.mkEnableOption "Whether to enable Clash, A rule-based proxy in Go.";
    package = lib.mkPackageOption pkgs "clash" {};
    configFile = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "Configuration file to use.";
    };
    webui = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = ''
        Local web interface to use.

        You can also use the following website, just in case:
        - metacubexd:
          - http://d.metacubex.one
          - https://metacubex.github.io/metacubexd
          - https://metacubexd.pages.dev
        - yacd:
          - https://yacd.haishan.me
        - clash-dashboard (buggy):
          - https://clash.razord.top
      '';
    };
    extraOpts = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = "Extra command line options to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    ### systemd service
    systemd.services."clash" = {
      description = "Clash daemon, A rule-based proxy in Go.";
      documentation = ["https://clash.wiki/" "https://wiki.metacubex.one/"];
      after = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = builtins.concatStringsSep " " [
          (lib.getExe cfg.package)
          "-d /var/lib/private/clash"
          (lib.optionalString (cfg.configFile != null) "-f \${CREDENTIALS_DIRECTORY}/configuration")
          (lib.optionalString (cfg.webui != null) "-ext-ui ${cfg.webui}")
          (lib.optionalString (cfg.extraOpts != null) cfg.extraOpts)
        ];

        DynamicUser = true;
        StateDirectory = "clash";
        LoadCredential = "configuration:${cfg.configFile}";

        ### Hardening
        CapabilityBoundingSet = "";
        DeviceAllow = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
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
        RestrictAddressFamilies = "AF_INET AF_INET6";
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service bpf";
        UMask = "0077";
      };
    };
  };
}
