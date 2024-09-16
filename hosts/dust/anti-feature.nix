{ lib, ... }:
{
  nixpkgs.config = {
    allowAliases = false;

    allowNonSource = false;
    allowNonSourcePredicate =
      pkg:
      lib.elem (lib.getName pkg) [
        "cargo-bootstrap"
        "cef-binary"
        "dart"
        "go"
        "osu-lazer-bin"
        "rustc-bootstrap"
        "rustc-bootstrap-wrapper"
        "sof-firmware"
        "temurin-bin"
      ];

    allowUnfree = false;
    allowUnfreePredicate =
      pkg:
      lib.elem (lib.getName pkg) [
        "fcitx5-pinyin-minecraft"
        "fcitx5-pinyin-moegirl"
        "osu-lazer-bin"
        "steam"
        "steam-original"
        "steam-run"
      ];
  };
}
