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
        inputs.nix-minecraft.legacyPackages.${pkgs.stdenv.hostPlatform.system}.fabricServers.fabric-26_1_1.override
          { jre_headless = pkgs.openjdk25.headless; };

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

      serverProperties = {
        motd =
          let
            c = color: str: "\\u00A7" + color + str + "\\u00A7" + "r";
          in
          [
            "${c "8" "::"} ${c "a" "Evergreen"} ${c "f" "Survival"} ${c "8" "::"}"
            "Join with ${builtins.split "-" package.version |> (x: builtins.elemAt x 0)}"
          ]
          |> lib.concatStringsSep "\\n";

        white-list = true;
        max-players = 5;
        enforce-secure-profile = false;

        difficulty = "hard";
        gamemode = "survival";
        level-seed = "Nix";
      };

      whitelist = {
        "Guanran928" = "86dbb6c5-8d8b-4c45-b8eb-b3fdf03bfb27";
        "Moe_Kafu_Chino" = "0b036845-c18d-4349-be89-7f8705b5f65b";
        "i_love_ravens" = "2788dd4b-b010-4a2f-9b5c-aad0c0e0cba5";
        "multimode_Liu" = "5bad0d97-1b6e-448f-87c4-350ee898cb68";
      };

      symlinks.mods =
        [
          {
            # Telegram Bridge
            url = "https://cdn.modrinth.com/data/QI59B2cO/versions/7sbOIfCX/tgbridge-0.9.6-fabric.jar";
            hash = "sha256-pxzPhnfgBZe4EIFm1b1gPC37EB4slaooN3ywx7oPjcQ=";
          }
          {
            # Simple Voice Chat
            url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/4cjovAfF/voicechat-fabric-2.6.15+26.1.1.jar";
            hash = "sha256-fqIWVG6KO+hpDeOQaQ4ctTzO4blWeiNb0s+EoV+yMiY=";
          }
          {
            # Fabric API
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/G0yfY6x2/fabric-api-0.145.3+26.1.1.jar";
            hash = "sha256-oOKFvhTKFWtImPCTQrKRrerzSSrC36juhwLLM7HqujQ=";
          }
          {
            # Fabric Language Kotlin
            url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/21TRTKmh/fabric-language-kotlin-1.13.10+kotlin.2.3.20.jar";
            hash = "sha256-8ojwJz+p1ZKweGn6K7173KJ0mYo4uH64SFwQlCCSHio=";
          }
        ]
        |> map pkgs.fetchurl
        |> pkgs.linkFarmFromDrvs "mods";
    };
  };
}
