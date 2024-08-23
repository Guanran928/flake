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
      ./zram.nix
    ]
    ++ (with inputs; [
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      impermanence.nixosModules.impermanence
      lanzaboote.nixosModules.lanzaboote
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
    extraSpecialArgs = {inherit inputs;};
  };

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    unzip
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

  users.mutableUsers = false;
  users.users = {
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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmd/uqiBahzKcKMJ+gT3dkUIdrWQgudspsDchDlx1E/ guanran928@outlook.com"
      ];
    };
  };

  boot.initrd.systemd.enable = true;
  environment.stub-ld.enable = false;

  programs.command-not-found.enable = false;
  programs.dconf.enable = true;
  programs.fish.enable = true;
  programs.nano.enable = false;
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  # Avoid TOFU MITM with github by providing their public key here.
  programs.ssh.knownHosts = {
    "github.com".hostNames = ["github.com"];
    "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

    "gitlab.com".hostNames = ["gitlab.com"];
    "gitlab.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";

    "git.sr.ht".hostNames = ["git.sr.ht"];
    "git.sr.ht".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZvRd4EtM7R+IHVMWmDkVU3VLQTSwQDSAvW0t2Tkj60";
  };

  # https://archlinux.org/news/making-dbus-broker-our-default-d-bus-daemon/
  services.dbus.implementation = lib.mkDefault "broker";

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = lib.mkDefault "no"; # mkDefault for colmena
    settings.PasswordAuthentication = false;
  };

  security.sudo.execWheelOnly = true;
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

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
