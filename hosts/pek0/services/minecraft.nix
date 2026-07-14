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
        inputs.nix-minecraft.legacyPackages.${pkgs.stdenv.hostPlatform.system}.fabricServers.fabric-26_2.override
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
            url = "https://cdn.modrinth.com/data/QI59B2cO/versions/84vGfeQP/tgbridge-0.9.10-fabric.jar";
            hash = "sha256-gTcJSl8STSepgyeQmaQ6kaZRjxVLiNXmcP02APPJwqE=";
          }
          {
            # Simple Voice Chat
            url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/bvaEHE2T/voicechat-fabric-2.6.20%2B26.2.jar";
            hash = "sha256-Y1emeQirNSx7hN3tcqwaUfJVAo7xP5jcEJVBuU/jRkU=";
          }
          {
            # Fabric API
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/Kr4WG5mG/fabric-api-0.154.2%2B26.2.jar";
            hash = "sha256-BebDzJi8U0rvfx8Eg8C7/RRUvRzzd1GHH4/xpm6ddEY=";
          }
          {
            # Fabric Language Kotlin
            url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/Pd0xrHCw/fabric-language-kotlin-1.13.12%2Bkotlin.2.4.0.jar";
            hash = "sha256-NsXdi3KONHDSiCrmMRm5OiBQD8Dqb1yUXBK/ZbWrGDI=";
          }
          {
            # Distant Horizon
            url = "https://cdn.modrinth.com/data/uCdwusMi/versions/gBf0SaV1/DistantHorizons-3.2.0-b-26.2-fabric-neoforge.jar";
            hash = "sha256-+3pg+gZ3XSCP9HzkuYxmjNxSdEnDfaSoBoaVeURWNJ8=";
          }
        ]
        |> map pkgs.fetchurl
        |> pkgs.linkFarmFromDrvs "mods";
    };
  };
}
