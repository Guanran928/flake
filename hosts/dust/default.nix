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

  networking.hostName = "dust";
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "24.05";

  home-manager.users.guanranwang = import ./home;

  boot.tmp.useTmpfs = true;

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    yubikey-manager
  ];

  networking.firewall.allowedTCPPorts = [53317];
  networking.firewall.allowedUDPPorts = [53317];

  programs.adb.enable = true;
  programs.localsend.enable = true;
  programs.seahorse.enable = true;
  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
  };

  services.power-profiles-daemon.enable = true;
  services.gvfs.enable = true;
  services.gnome = {
    gnome-keyring.enable = true;
    sushi.enable = true;
  };

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
      (source-serif.overrideAttrs {
        installPhase = ''
          runHook preInstall
          install -Dm444 VAR/*.otf -t $out/share/fonts/variable
          runHook postInstall
        '';
      })
      source-han-sans-vf-otf
      source-han-serif-vf-otf
      noto-fonts
      noto-fonts-color-emoji
    ];
    fontconfig = {
      defaultFonts = {
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
      # GitHub perfers Noto Sans...
      localConf = ''
        <selectfont>
          <rejectfont>
            <pattern>
              <patelt name="family">
                <string>Noto Sans</string>
              </patelt>
            </pattern>
          </rejectfont>
        </selectfont>
      '';
    };
  };

  console = {
    earlySetup = true;
    keyMap = "dvorak";
  };

  services.greetd = {
    enable = true;
    settings.default_session.command = "${lib.getExe pkgs.greetd.tuigreet} --cmd ${pkgs.writeShellScript "sway" ''
      dbus-update-activation-environment --all --systemd
      exec systemd-cat --identifier=sway sway
    ''}";
  };

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
}
