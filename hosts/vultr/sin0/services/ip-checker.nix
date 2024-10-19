{
  lib,
  pkgs,
  inputs,
  ports,
  ...
}:
let
  port = ports.ip-checker;
in
{
  systemd.services."ip-checker" = {
    wantedBy = [ "multi-user.target" ];
    environment = {
      IP_CHECKER_LISTEN = "127.0.0.1:${toString port}";
      IP_CHECKER_COUNTRY_DB = "${pkgs.clash-geoip}/etc/clash/Country.mmdb";
    };
    serviceConfig = {
      ExecStart = lib.getExe inputs.ip-checker.packages.${pkgs.stdenv.hostPlatform.system}.default;
      WorkingDirectory = inputs.ip-checker;

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

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "ip.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = lib.singleton { dial = "127.0.0.1:${toString port}"; };
    };
  };
}
