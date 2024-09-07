{ lib, ... }:
{
  sops.age.sshKeyPaths = lib.mkForce [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
  fileSystems."/persist".neededForBoot = true;
  preservation.enable = true;
  preservation.preserveAt."/persist" = {
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

  systemd.tmpfiles.settings.preservation =
    let
      mkTmpfile = {
        user = "guanranwang";
        group = "users";
        mode = "0755";
      };
    in
    {
      "/home/guanranwang/.config".d = mkTmpfile;
      "/home/guanranwang/.mozilla".d = mkTmpfile;
      "/home/guanranwang/.local/share".d = mkTmpfile;
      "/home/guanranwang/.local/state".d = mkTmpfile;
    };
}
