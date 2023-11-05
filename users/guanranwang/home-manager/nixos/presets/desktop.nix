{...}: {
  imports = [
    ../..
    ../../resources/terms/alacritty.nix
    ../../resources/shell/fish.nix
    ../../resources/shell/bash.nix
    ../../resources/editor/helix.nix
    ../../resources/editor/neovim.nix
    ../../resources/editor/vscode.nix

    ../home.nix

    ../dotfiles.nix
    ../fonts.nix
    ../i18n.nix

    ../wm
    ../xdg
  ];
}
