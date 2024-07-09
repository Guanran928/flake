{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  imports =
    [
      ./nix
      ./fun.nix
      ./hardening.nix
      ./networking.nix
    ]
    ++ (with inputs; [
      aagl.nixosModules.default
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      impermanence.nixosModules.impermanence
      lanzaboote.nixosModules.lanzaboote
      nixos-sensible.nixosModules.default
      nur.nixosModules.nur
      self.nixosModules.default
      sops-nix.nixosModules.sops
    ]);

  nixpkgs.overlays = [
    inputs.self.overlays.patches
  ];

  ### home-manager
  home-manager.users.guanranwang = import ../../../home;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;}; # ??? isnt specialArgs imported by default ???
  };

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  ### Default Programs
  # In addition of https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/system-path.nix
  environment.systemPackages = with pkgs; [
    unzip
    wget
    tree
    file
    htop

    lsof
    ltrace
    strace

    dnsutils
    pciutils
    usbutils
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = lib.mkDefault "no"; # mkDefault for colmena
    settings.PasswordAuthentication = false;
  };

  users.users = rec {
    "guanranwang" = {
      isNormalUser = true;
      description = "Guanran Wang";
      hashedPasswordFile = config.sops.secrets."hashed-passwd".path;
      shell = pkgs.fish;
      extraGroups = [
        "wheel"
        "nix-access-tokens"
      ];
      openssh.authorizedKeys.keys = [
        # same as git signing
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmd/uqiBahzKcKMJ+gT3dkUIdrWQgudspsDchDlx1E/ guanran928@outlook.com"
      ];
    };

    "root" = {
      openssh.authorizedKeys.keys = guanranwang.openssh.authorizedKeys.keys;
    };
  };

  programs.dconf.enable = true;
  programs.fish.enable = true;
  users.groups."nix-access-tokens" = {};
  nix.extraOptions = "!include ${config.sops.secrets.nix-access-tokens.path}";

  ### sops-nix
  sops = {
    defaultSopsFile = ../../../secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    gnupg.sshKeyPaths = [];
    secrets = {
      "hashed-passwd" = {
        neededForUsers = true;
      };
      "nix-access-tokens" = {
        group = config.users.groups."nix-access-tokens".name;
        mode = "0440";
      };
    };
  };
}
