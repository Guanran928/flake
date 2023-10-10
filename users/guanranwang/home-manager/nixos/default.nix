{ ... }:

{
  imports = [
    ../common/home.nix
    ./home.nix

    ./dotfiles.nix
    ./i18n.nix
    ./sway.nix
    ./waybar.nix

    ./xdg
  ];
}