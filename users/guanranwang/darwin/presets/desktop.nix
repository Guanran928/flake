{...}: {
  imports = [
    ./core.nix
  ];

  ### home-manager
  home-manager.users.guanranwang.imports = [
    ./core.nix

    ../../modules/terms/alacritty.nix
    ../../modules/shell/fish.nix
    ../../modules/shell/bash.nix
    ../../modules/editor/helix.nix
    ../../modules/editor/neovim.nix
    ../../modules/editor/vscode.nix

    ../home.nix
  ]; # NOTE: using flakes
}
