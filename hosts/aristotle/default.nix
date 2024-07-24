{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../nixos/profiles/opt-in/mihomo
    ../../nixos/profiles/opt-in/wireless

    ./anti-feature.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./impermanence.nix
    ./lanzaboote.nix
  ];

  networking.hostName = "aristotle";
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "23.11";

  home-manager.users.guanranwang = import ./home;

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    yubikey-manager
    localsend
  ];

  programs.adb.enable = true;
  programs.anime-game-launcher.enable = true;
  programs.seahorse.enable = true;
  programs.steam.enable = true;
  programs.kdeconnect = {
    enable = true;
    package = pkgs.valent;
  };

  services.power-profiles-daemon.enable = true;
  services.gvfs.enable = true;
  services.gnome = {
    gnome-keyring.enable = true;
    gnome-online-accounts.enable = true;
    sushi.enable = true;
  };

  # https://wiki.archlinux.org/title/Gamepad#Connect_Xbox_Wireless_Controller_with_Bluetooth
  hardware.xone.enable = true; # via wired or wireless dongle
  hardware.xpadneo.enable = true; # via Bluetooth

  # yubikey
  services.pcscd.enable = true;
  services.udev.packages = [pkgs.yubikey-personalization];

  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = ["NerdFontsSymbolsOnly"];
      })
      (inter.overrideAttrs {
        installPhase = ''
          runHook preInstall
          install -Dm644 -t $out/share/fonts/truetype/ InterVariable*.ttf
          runHook postInstall
        '';
      })
      (jetbrains-mono.overrideAttrs {
        installPhase = ''
          runHook preInstall
          install -Dm644 -t $out/share/fonts/truetype/ fonts/variable/*.ttf
          runHook postInstall
        '';
      })
      (source-sans.overrideAttrs {
        installPhase = ''
          runHook preInstall
          install -Dm444 VF/*.otf -t $out/share/fonts/variable
          runHook postInstall
        '';
      })
      (source-serif.overrideAttrs {
        installPhase = ''
          runHook preInstall
          install -Dm444 VAR/*.otf -t $out/share/fonts/variable
          runHook postInstall
        '';
      })
      source-han-sans-vf-otf
      source-han-serif-vf-otf
      noto-fonts-color-emoji
    ];
    fontconfig.defaultFonts = {
      emoji = [
        "Noto Color Emoji"
      ];
      # Append emoji font for Qt apps, they might use the monochrome emoji
      monospace = [
        "JetBrains Mono"
        "Source Han Sans SC VF"
        "Symbols Nerd Font"
        "Noto Color Emoji"
      ];
      sansSerif = [
        "Inter Variable"
        "Source Han Sans SC VF"
        "Noto Color Emoji"
      ];
      serif = [
        "Source Serif 4 Variable"
        "Source Han Serif SC VF"
        "Noto Color Emoji"
      ];
    };
  };

  console = {
    earlySetup = true;
    keyMap = "dvorak";
  };

  services.greetd = {
    enable = true;
    settings.default_session.command = "${lib.getExe pkgs.greetd.tuigreet} --cmd sway";
  };

  # polkit
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  security.pam.services.swaylock = {};
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    # https://gitlab.archlinux.org/archlinux/packaging/packages/sway/-/blob/main/sway-portals.conf
    config."sway" = {
      default = "gtk";
      "org.freedesktop.impl.portal.ScreenCast" = "wlr";
      "org.freedesktop.impl.portal.Screenshot" = "wlr";
      "org.freedesktop.impl.portal.Inhibit" = "none";
    };
  };

  ### Removes debounce time
  # https://www.reddit.com/r/linux_gaming/comments/ku6gth
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Never Debounce]
    MatchUdevType=mouse
    ModelBouncingKeys=1
  '';
}
