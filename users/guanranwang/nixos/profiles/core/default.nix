{
  pkgs,
  config,
  lib,
  ...
}: {
  users.users."guanranwang" = {
    isNormalUser = true;
    description = "Guanran Wang";
    extraGroups = [
      "wheel" # administrator
      "networkmanager" # access to networkmanager
      "tss" # access to tpm devices
      "vboxusers" # access to virtualbox
      "nix-access-tokens" # access to github tokens
      "libvirtd" # access to virt-manager
    ];
    hashedPasswordFile = config.sops.secrets."hashed-passwd".path;
    shell = pkgs.fish;
    packages = [];
  };

  ### for default shell
  programs.fish.enable = true;

  ### Options
  myFlake.nixos.networking.dns.provider = lib.mkDefault "alidns";

  ### Flakes
  imports = [
    ../../../../../nixos/flake-modules/sops-nix.nix
    ../../../../../nixos/flake-modules/home-manager.nix
  ];

  ### sops-nix
  nix.extraOptions = "!include ${config.sops.secrets.nix-access-tokens.path}";
  users.groups."nix-access-tokens" = {};
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    gnupg.sshKeyPaths = [];
    secrets = {
      "hashed-passwd".neededForUsers = true; # Hashed user password
      "nix-access-tokens" = {
        group = config.users.groups."nix-access-tokens".name;
        mode = "0440";
      };
    };
  };

  ### home-manager
  home-manager.users.guanranwang.imports = map (n: ../../../home-manager/${n}) [
    "default.nix"
    "profiles/command-line/nixos"
  ];
}
