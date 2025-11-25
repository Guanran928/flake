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
  system.nixos-init.enable = true;

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
  system.stateVersion = "25.05";

  # TODO: move to 'core' profile
  system.etc.overlay.enable = true;
  system.etc.overlay.mutable = false;

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
    adb.enable = true;
    fish.enable = true;
    niri.enable = true;
    neovim.package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
    seahorse.enable = true;
    ssh.enableAskPassword = true;
    yubikey-manager.enable = true;
  };

  programs.gtklock = {
    enable = true;
    modules = with pkgs; [
      gtklock-playerctl-module
      gtklock-powerbar-module
    ];
  };

  programs.steam = {
    enable = true;
    package = pkgs.steam.override { extraArgs = "-system-composer"; };
  };

  services = {
    power-profiles-daemon.enable = true;
    gnome = {
      gnome-keyring.enable = true;
    };
    tailscale = {
      enable = true;
      extraDaemonFlags = [ "--no-logs-no-support" ];
    };
    speechd.enable = false;
  };

  services.greetd = {
    enable = true;
    settings.default_session.command = "${lib.getExe pkgs.tuigreet} --cmd niri-session";
  };

  services.upower = {
    enable = true;
    criticalPowerAction = "PowerOff";
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
