{ pkgs, config, ... }:

{
  users.users."guanranwang" = {
    isNormalUser = true;
    description = "Guanran Wang";
    extraGroups = [
      "wheel"             # administrator
      "networkmanager"    # access to networkmanager
      "tss"               # access to tpm devices
      "vboxusers"         # access to virtualbox
      "nix-access-tokens" # access to github tokens
    ];
    hashedPasswordFile = config.sops.secrets."hashed-passwd".path;
    shell = pkgs.fish;
    packages = [];
  };



  imports = [
    ### Overrides (overrides global config)
    ../networking
    ### Flakes
    ../../../../flakes/nixos/sops-nix.nix
    ../../../../flakes/nixos/hosts.nix
  ];
  ### sops-nix
  nix.extraOptions = "!include ${config.sops.secrets.nix-access-tokens.path}";
  users.groups."nix-access-tokens" = {};
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.sshKeyPaths = [ "/nix/persist/system/etc/ssh/ssh_host_ed25519_key" ];
    gnupg.sshKeyPaths = [];
    secrets = {
      "hashed-passwd".neededForUsers = true;                # Hashed user password
      "wireless/home".path = "/var/lib/iwd/wangxiaobo.psk"; # Home wifi password
      "nix-access-tokens" = {
        group = config.users.groups."nix-access-tokens".name;
        mode = "0440";
      };
    };
  };
}