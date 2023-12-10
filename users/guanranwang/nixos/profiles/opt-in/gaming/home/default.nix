{...}: {
  imports = map (n: ../../../../../home-manager/applications/${n}) [
    "steam"
    "prismlauncher"
    "osu-lazer"
    "mangohud"
    "protonup-qt"
  ];
}
