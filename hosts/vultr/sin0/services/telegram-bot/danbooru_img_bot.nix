{ pkgs, config, ... }:
{
  systemd.services."tg-danbooru_img_bot" = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      # TODO: un-vendor this file
      ExecStart = pkgs.writers.writePython3 "pytest" {
        doCheck = false;
        libraries = with pkgs.python3Packages; [
          python-telegram-bot
          aiohttp
        ];
      } (builtins.readFile ./danbooru_img_bot.py);
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
}
