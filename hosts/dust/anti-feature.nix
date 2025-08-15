{ lib, ... }:
{
  nixpkgs.config = {
    allowNonSourcePredicate =
      pkg:
      lib.elem (lib.getName pkg) [
        "cargo-bootstrap"
        "cef-binary"
        "dart"
        "go"
        "rustc-bootstrap"
        "rustc-bootstrap-wrapper"
        "sof-firmware"
        "temurin-bin"
        "zen-beta"
      ];

    allowUnfreePredicate =
      pkg:
      lib.elem (lib.getName pkg) [
        "fcitx5-pinyin-minecraft"
        "fcitx5-pinyin-moegirl"
      ];
  };
}
