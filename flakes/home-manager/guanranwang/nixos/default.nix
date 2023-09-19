{ ... }:

{
  imports = [
    ../common/home.nix
    ./home.nix

    ./dotfiles.nix
    ./i18n.nix

    ./xdg
  ];
}