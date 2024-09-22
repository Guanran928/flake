{ config, ... }:
{
  sops.secrets = builtins.mapAttrs (_n: v: v // { sopsFile = ./secrets.yaml; }) {
    "restic/environment" = { };
    "restic/password" = { };
    "restic/repository" = { };
  };

  services.restic.backups.persist = {
    environmentFile = config.sops.secrets."restic/environment".path;
    passwordFile = config.sops.secrets."restic/password".path;
    repositoryFile = config.sops.secrets."restic/repository".path;
    paths = [ "/persist" ];
    extraBackupArgs = [
      "--one-file-system"
      "--exclude-caches"
      "--no-scan"
      "--retry-lock 2h"
    ];
    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = "4h";
      FixedRandomDelay = true;
      Persistent = true;
    };
  };
}
