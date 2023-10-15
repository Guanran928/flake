{ pkgs, config, ... }:

{
  users.users."guanranwang" = {
    isNormalUser = true;
    description = "Guanran Wang";
    extraGroups = [ "wheel" "networkmanager" "tss" "nix-access-tokens" ]; # tss = access to tpm devices
    hashedPasswordFile = config.sops.secrets."hashed-passwd".path;
    shell = pkgs.fish;
    packages = [];
  };



  # Flakes
  imports = [
    ../../flakes/nixos/home-manager.nix
    ../../flakes/nixos/sops-nix.nix
    ../../flakes/nixos/hosts.nix
    ../../flakes/nixos/berberman.nix
  ];
  ### home-manager
  home-manager.users.guanranwang = import ./home-manager/nixos;
  ### sops-nix
  nix.extraOptions = "!include ${config.sops.secrets.nix-access-tokens.path}";
  users.groups."nix-access-tokens" = {};
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    age.sshKeyPaths = [ "/nix/persist/system/etc/ssh/ssh_host_ed25519_key" ];
    gnupg.sshKeyPaths = [];
    secrets = {
      "hashed-passwd".neededForUsers = true;                # Hashed user password
      "wireless/home".path = "/var/lib/iwd/wangxiaobo.psk"; # Home wifi password
      "nix-access-tokens" = {
        group = config.users.groups."nix-access-tokens".name;
        mode = "0440";
      };
      "clash-config" = {                                    # Clash.Meta configuration
        owner = config.users.users."clash-meta".name;
        group = config.users.users."clash-meta".group;
        restartUnits = [ "clash-meta.service" ];
        path = "/etc/clash-meta/config.yaml";
      };
    };
  };
}