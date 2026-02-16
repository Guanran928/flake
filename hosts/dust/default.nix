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

  services.flatpak = {
    enable = true;
  };

  boot.plymouth = {
    enable = true;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.desktopManager.plasma6 = {
    enable = true;
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
    ssh = {
      enableAskPassword = true;
      startAgent = true;
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
    power-profiles-daemon = {
      enable = true;
    };
    tailscale = {
      enable = true;
      extraDaemonFlags = [ "--no-logs-no-support" ];
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
