{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  pkgs' = inputs.ip-checker.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  systemd.services."ip-checker" = {
    wantedBy = [ "multi-user.target" ];
    environment = {
      IP_CHECKER_ASN_DB = pkgs.dbip-asn-lite.mmdb;
      IP_CHECKER_CITY_DB = pkgs.dbip-city-lite.mmdb;
      IP_CHECKER_LISTEN = "unix//run/ip-checker/ip-checker.sock";
      IP_CHECKER_MODE = "prod";
      IP_CHECKER_SOCKET_PERMISSION = "0770";
    };
    serviceConfig = {
      ExecStart = lib.getExe pkgs'.api;
      RuntimeDirectory = "ip-checker";
      Group = "ip-checker";

      CapabilityBoundingSet = "";
      DynamicUser = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
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
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallErrorNumber = "EPERM";
      SystemCallFilter = "@system-service";
      UMask = "0077";
    };
  };

  systemd.services."caddy".serviceConfig.SupplementaryGroups = [ "ip-checker" ];

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "ip.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "subroute";
      routes = [
        # TODO: make `curl ip.ny4.dev` work
        {
          match = [ { path = [ "/api/v1/*" ]; } ];
          handle = lib.singleton {
            handler = "reverse_proxy";
            upstreams = lib.singleton { dial = "unix//run/ip-checker/ip-checker.sock"; };
          };
        }
        {
          handle = lib.singleton {
            handler = "file_server";
            root = pkgs'.ui;
          };
        }
      ];
    };
  };
}
