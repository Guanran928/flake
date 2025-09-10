{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../profiles/restic
    ../../profiles/sing-box

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

  sops = {
    age.keyFile = "/persist/home/guanranwang/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
  };

  sops.secrets = {
    "hashed-passwd" = {
      neededForUsers = true;
    };
    "nix-access-tokens" = {
      owner = "guanranwang";
      mode = "0440";
    };
    "wireless/Galaxy S24 EC54" = { };
    "wireless/XYC-SEEWO" = { };
    "wireless/Svartalfheim" = { };
    "u2f" = { };
  };

  systemd.tmpfiles.settings =
    let
      inherit (config.sops) secrets;
    in
    {
      "10-iwd" = {
        "/var/lib/iwd/Svartalfheim.psk".C.argument = secrets."wireless/Svartalfheim".path;
        "/var/lib/iwd/XYC-SEEWO.psk".C.argument = secrets."wireless/XYC-SEEWO".path;
        "/var/lib/iwd/Galaxy S24 EC54.psk".C.argument = secrets."wireless/Galaxy S24 EC54".path;
      };
    };

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
  system.stateVersion = "25.05";

  # TODO: move to 'core' profile
  system.etc.overlay.enable = true;
  system.etc.overlay.mutable = false;
  # HACK: for impermanence
  environment.etc."secureboot/placeholder" = {
    source = pkgs.emptyFile;
    mode = "0644";
  };

  users.users."guanranwang" = {
    isNormalUser = true;
    description = "Guanran Wang";
    hashedPasswordFile = config.sops.secrets."hashed-passwd".path;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "dialout"
    ];
  };

  home-manager = {
    users.guanranwang = import ../../home;
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;
    fish.enable = true;
    neovim.package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
    seahorse.enable = true;
    ssh.enableAskPassword = true;
  };

  services = {
    power-profiles-daemon.enable = true;
    gnome = {
      gnome-keyring.enable = true;
    };
    tailscale = {
      enable = true;
      openFirewall = true;
      extraDaemonFlags = [ "--no-logs-no-support" ];
    };

    # yubikey
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
  };

  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      (inter.overrideAttrs {
        installPhase = ''
          runHook preInstall
          install -Dt $out/share/fonts/truetype/ InterVariable*.ttf
          runHook postInstall
        '';
      })
      (source-serif.overrideAttrs {
        installPhase = ''
          runHook preInstall
          install -Dt $out/share/fonts/variable/ VAR/*.otf
          runHook postInstall
        '';
      })
      iosevka
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
          "Iosevka"
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
      localConf =
        # xml
        ''
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
    settings.default_session.command = "${lib.getExe pkgs.tuigreet} --cmd niri-session";
  };

  security.polkit.enable = true;
  security.pam.u2f = {
    enable = true;
    control = "sufficient";
    settings = {
      cue = true;
      authfile = config.sops.secrets.u2f.path;
    };
  };

  security.pam.services.swaylock = { };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    configPackages = [ pkgs.niri ];
  };

  services.sing-box.settings.experimental.clash_api = rec {
    external_controller = "127.0.0.1:9090";
    external_ui = pkgs.metacubexd;
    secret = "hunter2";
    # https://www.v2ex.com/t/1076579
    access_control_allow_origin = [ "http://${external_controller}" ];
  };
}
