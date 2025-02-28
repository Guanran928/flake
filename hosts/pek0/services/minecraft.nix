{ lib, pkgs, ... }:
{
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    package = pkgs.minecraftServers.vanilla-1-21;

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

    declarative = true;
    serverProperties = {
      motd = "NixOS Minecraft server!";
      white-list = true;

      difficulty = 3;
      gamemode = 0;
      max-players = 5;
    };
    whitelist = {
      "Guanran928" = "86dbb6c5-8d8b-4c45-b8eb-b3fdf03bfb27";
      "i_love_ravens" = "2788dd4b-b010-4a2f-9b5c-aad0c0e0cba5";
      "EmonliPC" = "291d3704-47c3-41e0-a6cc-5543c3d86292";
    };
  };
}
