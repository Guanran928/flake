{
  lib,
  inputs,
  pkgs,
  ports,
  ...
}:
let
  port = ports.sub-server;
  template =
    ''
      vless://{{ . }}@lax0.ny4.dev:27253/?type=tcp&encryption=none&flow=xtls-rprx-vision&security=tls#Los%20Angeles
      vless://{{ . }}@tyo0.ny4.dev:27253/?type=tcp&encryption=none&flow=xtls-rprx-vision&security=tls#Tokyo
    ''
    |> builtins.toFile "sub-server-template";
in
{
  systemd.services.sub-server = {
    wantedBy = [ "multi-user.target" ];
    environment = {
      SUB_SERVER_LISTEN = ":" + toString port;
      SUB_SERVER_TEMPLATE_PATH = template;
    };
    serviceConfig = {
      ExecStart = lib.getExe inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.sub-server;

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
    match = lib.singleton { host = [ "sub.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "[::1]:${toString port}"; } ];
    };
  };
}
