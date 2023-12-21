{lib, ...}: {
  ### sops-nix
  sops.age.sshKeyPaths = lib.mkForce ["/persist/etc/ssh/ssh_host_ed25519_key"];

  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib"

      "/etc/clash" # clash
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
      ];
      files = [
        ".config/sops/age/keys.txt"
        ".config/KDE/neochat.conf"
        ".config/neochatrc"
      ];
    };
  };
}
