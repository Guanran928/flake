{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  imports =
    [
      ./hardening.nix
      ./networking.nix
      ./nix.nix
      "${inputs.srvos}/nixos/common/well-known-hosts.nix"
    ]
    ++ (with inputs; [
      aagl.nixosModules.default
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      impermanence.nixosModules.impermanence
      lanzaboote.nixosModules.lanzaboote
      nixos-sensible.nixosModules.default
      nixos-sensible.nixosModules.zram
      nur.nixosModules.nur
      self.nixosModules.default
      sops-nix.nixosModules.sops
    ]);

  nixpkgs.overlays = [
    inputs.self.overlays.patches
  ];

  home-manager = {
    users.guanranwang = import ../../../home;
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
  programs.command-not-found.enable = false;
  environment.stub-ld.enable = false;

  documentation = {
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  # https://github.com/NixOS/nixpkgs/pull/308801
  # nixos/switch-to-configuration: add new implementation
  system.switch = {
    enable = false;
    enableNg = true;
  };

  ### sops-nix
  sops = {
    defaultSopsFile = ../../../secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    gnupg.sshKeyPaths = [];
    secrets."hashed-passwd".neededForUsers = true;
  };
}
