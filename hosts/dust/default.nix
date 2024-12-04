{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports =
    [
      ../../nixos/profiles/restic
      ../../nixos/profiles/sing-box

      ./anti-feature.nix
      ./disko.nix
      ./hardware-configuration.nix
      ./lanzaboote.nix
      ./preservation.nix
    ]
    ++ (with inputs; [
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      lanzaboote.nixosModules.lanzaboote
      preservation.nixosModules.preservation
    ]);

  sops.secrets = lib.mapAttrs (_n: v: v // { sopsFile = ./secrets.yaml; }) (
    lib.listToAttrs (
      lib.map (x: lib.nameValuePair "wireless/${x}" { path = "/var/lib/iwd/${x}.psk"; }) [
        "Galaxy S24 EC54"
        "ImmortalWrt"
        "XYC-SEEWO"
        "wangxiaobo"
      ]
    )
    // {
      "hashed-passwd" = {
        neededForUsers = true;
      };
      "nix-access-tokens" = {
        owner = "guanranwang";
        mode = "0440";
      };
    }
  );

  networking = {
    useNetworkd = true;
    useDHCP = false;
  };

  systemd.network.networks = {
    "10-wlan0" = {
      name = "wlan0";
      DHCP = "yes";
      dhcpV4Config.RouteMetric = 2048;
      dhcpV6Config.RouteMetric = 2048;
    };
    "11-eth" = {
      matchConfig = {
        Kind = "!*";
        Type = "ether";
      };
      DHCP = "yes";
    };
  };

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_testing;

  nix.extraOptions = "!include ${config.sops.secrets.nix-access-tokens.path}";

  networking.hostName = "dust";
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "24.05";

  # TODO: move to 'core' profile
  services.userborn.enable = true;
  system.etc.overlay.enable = true;
  system.etc.overlay.mutable = false;
  # HACK: for impermanence
  environment.etc =
    lib.genAttrs
      [
        "ssh/ssh_host_rsa_key"
        "ssh/ssh_host_rsa_key.pub"
        "ssh/ssh_host_ed25519_key"
        "ssh/ssh_host_ed25519_key.pub"
        "secureboot/placeholder"
      ]
      (_n: {
        source = pkgs.emptyFile;
        mode = "0644";
      });

  users.users."guanranwang" = {
    isNormalUser = true;
    description = "Guanran Wang";
    hashedPasswordFile = config.sops.secrets."hashed-passwd".path;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
  };

  home-manager = {
    users.guanranwang = import ../../home;
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
    };
  };

  boot.tmp.useTmpfs = true;

  environment.systemPackages = with pkgs; [ yubikey-manager ];

  programs = {
    adb.enable = true;
    dconf.enable = true;
    fish.enable = true;
    gamemode.enable = true;
    localsend.enable = true;
    seahorse.enable = true;
    steam.enable = true;
    ssh = {
      startAgent = true;
      enableAskPassword = true;
    };
  };

  services = {
    power-profiles-daemon.enable = true;
    gvfs.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      sushi.enable = true;
    };
    tailscale = {
      enable = true;
      openFirewall = true;
    };

    # yubikey
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
  };

  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      (ibm-plex.override { families = [ "mono" ]; })
      (inter.overrideAttrs {
        installPhase = ''
          runHook preInstall
          install -Dm644 -t $out/share/fonts/truetype/ InterVariable*.ttf
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
      nerd-fonts.symbols-only
      noto-fonts
      noto-fonts-color-emoji
      source-han-sans-vf-otf
      source-han-serif-vf-otf
    ];
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        # Append emoji font for Qt apps, they might use the monochrome emoji
        monospace = [
          "IBM Plex Mono"
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
      # GitHub prefers Noto Sans...
      # DejaVu Sans from nixpkgs#fontconfig.out
      localConf = ''
        <selectfont>
          <rejectfont>
            <pattern>
              <patelt name="family">
                <string>Noto Sans</string>
              </patelt>
            </pattern>
          </rejectfont>
          <rejectfont>
            <pattern>
              <patelt name="family">
                <string>DejaVu Sans</string>
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
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  security.pam.services.swaylock = { };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    # https://gitlab.archlinux.org/archlinux/packaging/packages/sway/-/blob/main/sway-portals.conf
    config."sway" = {
      default = "gtk";
      "org.freedesktop.impl.portal.ScreenCast" = "wlr";
      "org.freedesktop.impl.portal.Screenshot" = "wlr";
      "org.freedesktop.impl.portal.Inhibit" = "none";
    };
  };

  services.sing-box.settings = {
    outbounds = [
      {
        type = "selector";
        tag = "select";
        outbounds = [
          "tyo0"
          "sin0"
          "direct"
        ];
        default = "tyo0";
      }
    ];

    route = {
      final = "select";
    };

    experimental = {
      clash_api = rec {
        external_controller = "127.0.0.1:9090";
        external_ui = pkgs.metacubexd;
        secret = "hunter2";
        # https://www.v2ex.com/t/1076579
        access_control_allow_origin = [ "http://${external_controller}" ];
      };
    };
  };

  services.restic.backups.persist.exclude = [ "/persist/home/guanranwang/.local/share/Steam" ];
}
