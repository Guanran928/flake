{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  services.minecraft-servers = {
    enable = true;
    eula = true;
    servers.survival = rec {
      enable = true;
      package =
        inputs.nix-minecraft.legacyPackages.${pkgs.stdenv.hostPlatform.system}.fabricServers.fabric-1_21_11;

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
      ];

      serverProperties =
        let
          c = color: str: "\u00A7" + color + str + "\u00A7" + "r";
        in
        {

          motd = ''
            ${c "8" "::"} ${c "a" "Evergreen"} ${c "f" "Survival"} ${c "8" "::"}
            Join with ${builtins.split "-" package.version |> (x: builtins.elemAt x 0)}
          '';
          white-list = true;
          max-players = 5;
          enforce-secure-profile = false;

          difficulty = "hard";
          gamemode = "survival";
          level-seed = "Nix";
        };

      whitelist = {
        "Guanran928" = "86dbb6c5-8d8b-4c45-b8eb-b3fdf03bfb27";
        "i_love_ravens" = "2788dd4b-b010-4a2f-9b5c-aad0c0e0cba5";
        "multimode_Liu" = "5bad0d97-1b6e-448f-87c4-350ee898cb68";
      };

      symlinks.mods =
        [
          {
            # Telegram Bridge
            url = "https://cdn.modrinth.com/data/QI59B2cO/versions/QgZI7iZs/tgbridge-0.9.1-fabric.jar";
            hash = "sha256-GXlY2ma0Io89ofvdcIgTQZUlWoHgezSNFp/3ofHZ148=";
          }
          {
            # Simple Voice Chat
            url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/T42QJY4i/voicechat-fabric-1.21.11-2.6.10.jar";
            hash = "sha256-Bw++uNpoCuu7bQE/PSagtVFLBgoNKbtbBzSNBmbrGO0=";
          }
          {
            # Fabric API
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/gB6TkYEJ/fabric-api-0.140.2%2B1.21.11.jar";
            hash = "sha256-t8RYO3/EihF5gsxZuizBDFO3K+zQHSXkAnCUgSb4QyE=";
          }
          {
            # Fabric Language Kotlin
            url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/N6D3uiZF/fabric-language-kotlin-1.13.8%2Bkotlin.2.3.0.jar";
            hash = "sha256-dglT2NPR+jKjU1k9dE4pF9ipHKiSOulRi17yZ2pjEAI=";
          }
        ]
        |> map pkgs.fetchurl
        |> pkgs.linkFarmFromDrvs "mods";
    };
  };
}
