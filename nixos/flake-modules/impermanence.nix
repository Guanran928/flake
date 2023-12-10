{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./sops-nix.nix
  ];

  ### sops-nix
  sops.age.sshKeyPaths = lib.mkForce ["/nix/persist/system/etc/ssh/ssh_host_ed25519_key"];

  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib"

      "/etc/clash-meta" # clash-meta
      "/etc/secureboot" # sbctl, lanzaboote
    ];
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
    users.guanranwang = {
      directories = [
        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        #"Public"
        #"Templates"
        "Videos"

        ".cache"
        ".local/share" # ".local/bin" is managed through home-manager
        ".local/state"
        ".ssh"

        ".librewolf"
        ".config/chromium"
        ".config/fcitx5"
        ".config/Mumble"
        ".config/nvim" # not managed with git because my configuration is trash and i do not want other people to see it
      ];
      files = [
        ".config/sops/age/keys.txt"
        ".config/KDE/neochat.conf"
        ".config/neochatrc"
      ];
    };
  };
}
