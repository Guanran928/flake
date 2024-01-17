{...}: {
  imports = map (n: ../../../../../../home/applications/${n}) [
    "steam"
    "prismlauncher"
    "osu-lazer"
    "osu-stable"
    "mangohud"
  ];
}
