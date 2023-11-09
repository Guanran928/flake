{...}: {
  imports = [
    ../..
    ../../resources/terms/alacritty.nix
    ../../resources/shell/fish.nix
    ../../resources/shell/bash.nix
    ../../resources/editor/helix.nix
    ../../resources/editor/neovim.nix
    ../../resources/editor/vscode.nix
    ../../resources/browser/chromium.nix
    ../../resources/browser/librewolf.nix
    ../../resources/lang/nix.nix
    ../../resources/lang/go.nix
    ../../resources/media/nixos
    ../../resources/wm/sway.nix

    ../xdg
    ../home.nix
    ../fonts.nix
    ../i18n.nix
    ../theme.nix
  ];
}
