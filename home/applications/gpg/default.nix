{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };

  services.gpg-agent = {
    enable = lib.mkIf pkgs.stdenv.hostPlatform.isLinux true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
}
