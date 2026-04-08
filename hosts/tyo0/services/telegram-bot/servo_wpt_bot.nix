{ pkgs, config, ... }:
{
  systemd.timers.tg-servo_wpt_bot = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

  systemd.services.tg-servo_wpt_bot = {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writers.writePython3 "servo_wpt" { doCheck = false; } /* python */ ''
        import json
        import urllib.request
        import urllib.parse
        import os

        req = urllib.request.Request(
            "https://wpt.servo.org/scores.json",
            headers={
                "User-Agent": "servo-wpt-client (+https://t.me/servo_wpt)"
            },
        )

        with urllib.request.urlopen(req) as resp:
            data = json.load(resp)

        runs = data["runs"]
        latest = runs[-1]["scores"][0]

        token = os.environ["TELEGRAM_TOKEN"]
        chat_id = "@servo_wpt"

        data = urllib.parse.urlencode({
            "chat_id": chat_id,
            "text": f"""Score: {latest["total_score"] / latest["total_tests"] * 100:.2f}%
        Subtests pass: {latest["total_subtests_passed"] / latest["total_subtests"] * 100:.2f}%
        """}).encode()

        req = urllib.request.Request(f"https://api.telegram.org/bot{token}/sendMessage", data=data)

        with urllib.request.urlopen(req) as resp:
            print(resp.read().decode())
      '';
      EnvironmentFile = config.sops.secrets."tg/servo_wpt_bot".path;

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

  sops.secrets."tg/servo_wpt_bot" = { };
}
