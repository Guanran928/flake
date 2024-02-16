{pkgs, ...}: {
  imports = [
    # OS
    ../../nixos/profiles/laptop
    ../../nixos/profiles/common/opt-in/zram-generator.nix
    ../../nixos/profiles/common/opt-in/clash-meta-client

    # Hardware
    ./hardware-configuration.nix
    ./anti-feature.nix
  ];

  networking.hostName = "blacksteel";
  time.timeZone = "Asia/Shanghai";

  # TODOs:
  # [x] networkmanager - > iwd
  # [ ] nouveau -> nvidia
  # [ ] secureboot (???)
  # [ ] impermanence
  # [ ] backlight is always 33% when booted up
  # [ ] fan is *blasting* even after I installed mbpfans
  # [ ] audio quality isnt too great (compared to macOS, or i might have wooden ears)


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
    package = pkgs.papermc;
    jvmOpts = "-Xms2G -Xmx2G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true";

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
}
