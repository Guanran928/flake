{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  systemd.services.tg-ny4_rdict_bot = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = lib.getExe inputs.rdict.packages.${pkgs.stdenv.hostPlatform.system}.rdict-telegram;
      EnvironmentFile = config.sops.secrets."tg/ny4_rdict_bot".path;

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

  sops.secrets."tg/ny4_rdict_bot".restartUnits = [ "tg-ny4_rdict_bot.service" ];
}
