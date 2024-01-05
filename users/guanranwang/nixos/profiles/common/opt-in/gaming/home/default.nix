{...}: {
  imports = map (n: ../../../../../../home-manager/applications/${n}) [
    "steam"
    "prismlauncher"
    "osu-lazer"
    "osu-stable"
    "mangohud"
  ];
}
