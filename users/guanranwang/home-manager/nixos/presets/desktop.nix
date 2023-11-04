{...}: {
  imports = [
    ../../common/home.nix
    ../home.nix

    ../dotfiles.nix
    ../dunst.nix
    ../fonts.nix
    ../i18n.nix
    ../sway.nix
    ../waybar.nix

    ../xdg
  ];
}
