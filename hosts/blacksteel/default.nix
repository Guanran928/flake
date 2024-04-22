{
  pkgs,
  lib,
  ...
}: {
  imports = [
    # OS
    ../../nixos/profiles/laptop
    ../../nixos/profiles/common/opt-in/clash-meta-client

    # Hardware
    ./hardware-configuration.nix
    ./anti-feature.nix
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  networking.hostName = "blacksteel";
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "23.11";

  ######## Services
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  # Minecraft
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;

    # I should switch to vanilla/fabric one day...
    package = pkgs.papermc.overrideAttrs {
      version = "1.20.4-485";
      hash = "sha256-8bhlv/MU7KDmdL8Ngvg/zLMlGiO4Fswoyn/1diFE65k=";
    };
    # TODO: not working for some reason
    #.override {jre = pkgs.temurin-bin;};

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
    };
  };

  # Samba
  services.samba = {
    enable = true;
    openFirewall = true;
    shares."share" = {
      path = "/srv/samba/share";
      "read only" = "no";
    };
  };
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
  systemd.tmpfiles.rules = [
    "d /srv/samba/share 0700 guanranwang root"
  ];

  # qBitTorrent
  environment.systemPackages = with pkgs; [qbittorrent];
}
