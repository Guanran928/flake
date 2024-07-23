{lib, ...}: {
  nixpkgs.config = {
    allowAliases = false;

    allowNonSource = false;
    allowNonSourcePredicate = pkg:
      lib.elem (lib.getName pkg) [
        "adoptopenjdk-hotspot-bin"
        "cargo-bootstrap"
        "cef-binary"
        "dart"
        "osu-lazer-bin"
        "rustc-bootstrap"
        "rustc-bootstrap-wrapper"
        "sof-firmware"
        "temurin-bin"
      ];

    allowUnfree = false;
    allowUnfreePredicate = pkg:
      lib.elem (lib.getName pkg) [
        "fcitx5-pinyin-minecraft"
        "fcitx5-pinyin-moegirl"
        "libXNVCtrl"
        "nvidia-x11"
        "osu-lazer-bin"
        "steam"
        "steam-original"
        "steam-run"
        "xow_dongle-firmware"
      ];
  };
}
