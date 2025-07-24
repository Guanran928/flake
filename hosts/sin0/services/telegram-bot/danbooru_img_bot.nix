{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  systemd.services.tg-danbooru_img_bot = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = lib.getExe inputs.danbooru_img_bot.packages.${pkgs.stdenv.hostPlatform.system}.default;
      EnvironmentFile = config.sops.secrets."tg/danbooru_img_bot".path;

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

  sops.secrets."tg/danbooru_img_bot".restartUnits = [ "tg-danbooru_img_bot.service" ];
}
