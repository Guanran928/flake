{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    (
      if pkgs.stdenv.hostPlatform.isDarwin
      then inputs.nixcasks.legacyPackages.${pkgs.stdenv.hostPlatform.system}.telegram
      else pkgs.telegram-desktop
    )
  ];
}
