{ pkgs, config, ... }:

{
  users.users."guanranwang" = {
    isNormalUser = true;
    description = "Guanran Wang";
    extraGroups = [ "wheel" "networkmanager" "tss" ]; # tss = access to tpm devices
    hashedPasswordFile = config.sops.secrets."hashed-passwd".path;
    shell = pkgs.fish;
    packages = [];
  };



  # Flakes.
  home-manager.users.guanranwang = import ./home-manager/nixos;

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    age.sshKeyPaths = [ "/nix/persist/system/etc/ssh/ssh_host_ed25519_key" ];
    gnupg.sshKeyPaths = [];
    secrets = {
      "clash-config" = {
        #mode = "0444"; # readable
        owner = config.users.users."clash-meta".name;
        group = config.users.users."clash-meta".group;
        restartUnits = [ "clash-meta.service" ];
        path = "/etc/clash-meta/config.yaml";
      };
      "hashed-passwd".neededForUsers = true;
    };
  };
}