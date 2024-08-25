{ lib, ... }:
{
  sops.age.sshKeyPaths = lib.mkForce [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
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
        ".mozilla/firefox"
        ".thunderbird"

        ".cache"
        ".local/share"
        ".local/state"

        ".config/gh"
        ".config/fcitx5"
        ".config/obs-studio"
      ];
      files = [
        ".config/sops/age/keys.txt"
      ];
    };
  };
}
