{lib, ...}: {
  sops.age.sshKeyPaths = lib.mkForce ["/persist/etc/ssh/ssh_host_ed25519_key"];
  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib"
      "/etc/secureboot"
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
        "Videos"
        #"Public"
        #"Templates"

        ".ssh"
        #".librewolf"
        ".mozilla/firefox"
        ".thunderbird"

        ".cache"
        ".local/share"
        ".local/state"

        ".config/Mumble"
        ".config/VSCodium"
        ".config/chromium"
        ".config/fcitx5"
        ".config/obs-studio"
        ".config/qBittorrent"
        ".config/spotify"
      ];
      files = [
        ".config/sops/age/keys.txt"
        #".config/KDE/neochat.conf"
        #".config/neochatrc"
      ];
    };
  };
}
