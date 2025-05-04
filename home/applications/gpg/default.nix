{ config, pkgs, ... }:
{
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };

  services.gpg-agent = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    pinentry.package = pkgs.pinentry-gnome3;
  };
}
