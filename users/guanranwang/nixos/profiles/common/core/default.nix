{
  pkgs,
  config,
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

  programs.fish.enable = true;
  users.groups."nix-access-tokens" = {};
  nix.extraOptions = "!include ${config.sops.secrets.nix-access-tokens.path}";

  ### sops-nix
  sops = {
    defaultSopsFile = ../../../../secrets.yaml;
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

  ### home-manager
  home-manager.users.guanranwang = import ./home;
}
