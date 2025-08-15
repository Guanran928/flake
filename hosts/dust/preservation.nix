{
  fileSystems."/persist".neededForBoot = true;
  preservation.enable = true;
  preservation.preserveAt."/persist" = {
    directories = [
      "/var/log"
      "/var/lib"
      "/etc/secureboot"
    ];

    users.guanranwang = {
      directories = [
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Projects"
        "Videos"

        ".ssh"
        ".thunderbird"
        ".zen"

        ".cache"
        ".local/share"
        ".local/state"

        ".config/gh"
        ".config/fcitx5"
        ".config/obs-studio"
      ];
      files = [ ".config/sops/age/keys.txt" ];
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
