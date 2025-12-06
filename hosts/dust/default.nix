{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../profiles/sing-box

    ./disko.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./preservation.nix
  ]
  ++ (with inputs; [
    disko.nixosModules.disko
    home-manager.nixosModules.home-manager
    lanzaboote.nixosModules.lanzaboote
    preservation.nixosModules.preservation
  ]);

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
    "u2f" = { };
  };

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_testing;

  nix.extraOptions = "!include ${config.sops.secrets.nix-access-tokens.path}";

  networking.hostName = "dust";
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "25.11";

  # TODO: move to 'core' profile
  system = {
    nixos-init.enable = true;
    etc.overlay.enable = true;
    etc.overlay.mutable = false;
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
    users.guanranwang = import ./home-manager.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
  };

  programs = {
    # keep-sorted start block=yes
    adb = {
      enable = true;
    };
    fish = {
      enable = true;
    };
    gtklock = {
      enable = true;
      modules = with pkgs; [
        gtklock-playerctl-module
        gtklock-powerbar-module
      ];
    };
    neovim = {
      package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
    };
    niri = {
      enable = true;
    };
    seahorse = {
      enable = true;
    };
    ssh = {
      enableAskPassword = true;
    };
    steam = {
      enable = true;
      package = pkgs.steam.override { extraArgs = "-system-composer"; };
    };
    yubikey-manager = {
      enable = true;
    };
    # keep-sorted end
  };

  services = {
    # keep-sorted start block=yes
    gnome = {
      gnome-keyring.enable = true;
    };
    greetd = {
      enable = true;
      settings.default_session.command = "${lib.getExe pkgs.tuigreet} --cmd niri-session";
    };
    power-profiles-daemon = {
      enable = true;
    };
    speechd = {
      enable = false;
    };
    tailscale = {
      enable = true;
      extraDaemonFlags = [ "--no-logs-no-support" ];
    };
    upower = {
      enable = true;
      criticalPowerAction = "PowerOff";
    };
    # keep-sorted end
  };

  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      # keep-sorted start
      inter
      iosevka
      nerd-fonts.symbols-only
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      # keep-sorted end
    ];
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        # NOTE: Append emoji font for Qt apps, they might use the monochrome emoji
        monospace = [
          "Iosevka"
          "Noto Sans"
          "Noto Sans CJK SC"
          "Symbols Nerd Font"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Inter"
          "Noto Sans"
          "Noto Sans CJK SC"
          "Noto Color Emoji"
        ];
        serif = [
          "Noto Serif"
          "Noto Serif CJK SC"
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

  security.pam.u2f = {
    enable = true;
    control = "sufficient";
    settings = {
      cue = true;
      authfile = config.sops.secrets.u2f.path;
    };
  };
}
