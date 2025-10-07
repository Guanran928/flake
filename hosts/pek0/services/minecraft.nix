{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers.survival = {
      enable = true;
      package =
        inputs.nix-minecraft.legacyPackages.${pkgs.stdenv.hostPlatform.system}.fabricServers.fabric;

      # Aikar's flag
      # https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/
      # https://docs.papermc.io/paper/aikars-flags
      jvmOpts = lib.concatStringsSep " " [
        "-Xms2G"
        "-Xmx2G"
        "-XX:+UseG1GC"
        "-XX:+ParallelRefProcEnabled"
        "-XX:MaxGCPauseMillis=200"
        "-XX:+UnlockExperimentalVMOptions"
        "-XX:+DisableExplicitGC"
        "-XX:+AlwaysPreTouch"
        "-XX:G1NewSizePercent=30"
        "-XX:G1MaxNewSizePercent=40"
        "-XX:G1HeapRegionSize=8M"
        "-XX:G1ReservePercent=20"
        "-XX:G1HeapWastePercent=5"
        "-XX:G1MixedGCCountTarget=4"
        "-XX:InitiatingHeapOccupancyPercent=15"
        "-XX:G1MixedGCLiveThresholdPercent=90"
        "-XX:G1RSetUpdatingPauseTimePercent=5"
        "-XX:SurvivorRatio=32"
        "-XX:+PerfDisableSharedMem"
        "-XX:MaxTenuringThreshold=1"
        "-Dusing.aikars.flags=https://mcflags.emc.gs"
        "-Daikars.new.flags=true"
      ];

      serverProperties = {
        motd = ''\u00A78::\u00A7r \u00A7aEvergreen\u00A7r \u00A7fSurvival \u00A78::\u00A7r\nJoin with ${config.services.minecraft-server.package.version}'';
        white-list = true;
        max-players = 5;

        difficulty = "hard";
        gamemode = "survival";
        level-seed = "Nix";
      };

      whitelist = {
        "Guanran928" = "86dbb6c5-8d8b-4c45-b8eb-b3fdf03bfb27";
        "i_love_ravens" = "2788dd4b-b010-4a2f-9b5c-aad0c0e0cba5";
        "multimode_Liu" = "5bad0d97-1b6e-448f-87c4-350ee898cb68";
      };

      symlinks.mods = pkgs.linkFarmFromDrvs "mods" [
        # Matrix Bridge
        (pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/dPf5THEO/versions/gL6xGcgj/matrix-bridge-1.21-1.4.jar";
          hash = "sha256-vzPTTXHYJBFjafz6LUPHBCKbKgvPhVkYwPnW/Vrhqps=";
        })
        # Simple Voice Chat
        (pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/s1rczw8x/voicechat-fabric-1.21.8-2.6.4.jar";
          hash = "sha256-mIPQx7y3B3+XWtywclbP9DTE2kh0xe5hYsE9KkxXuvk=";
        })
        # Fabric API
        (pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/e9QZFLr0/fabric-api-0.134.0%2B1.21.8.jar";
          hash = "sha256-SsPy3cHTvJ2d/+iD4zIZw+9WmNuOUQNrj7ucHcSul2Y=";
        })
        # Fabric Language Kotlin
        (pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/iqWDz8qt/fabric-language-kotlin-1.13.3%2Bkotlin.2.1.21.jar";
          hash = "sha256-0d58143zqMbIazgji/1pFA0b8OrV2O9bukjPPKE0LYs=";
        })
      ];
    };
  };

  # Required by Simple Voice Chat
  networking.firewall.allowedUDPPorts = [ 24454 ];
}
