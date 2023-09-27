{ pkgs, config, ... }:

{
  users.users."guanranwang" = {
    isNormalUser = true;
    description = "Guanran Wang";
    extraGroups = [ "wheel" "networkmanager" "tss" ]; # tss = access to tpm devices
    #passwordFile = config.sops.secrets."user-password-guanranwang".path;
    hashedPassword = "$y$j9T$D7kBBBGwxw1XmPApAHIsx/$hcB64v3/kvPB7nIM9wXFiaSSBfhSp9k/JQ4R9G3guk6";
    shell = pkgs.fish;
    packages = [];
  };


  # Flakes.
  home-manager.users.guanranwang = import ../../users/guanranwang/home-manager/nixos;

  sops = {
    defaultSopsFile = ../../users/guanranwang/secrets/secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      "clash-config" = {
        #mode = "0444"; # readable
        owner = config.users.users."clash-meta".name;
        group = config.users.users."clash-meta".group;
        restartUnits = [ "clash-meta.service" ];
        path = "/etc/clash-meta/config.yaml";
      };
      "user-password-guanranwang".neededForUsers = true;
    };
  };
}