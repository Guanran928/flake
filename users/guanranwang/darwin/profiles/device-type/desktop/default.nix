{...}: {
  ### home-manager
  home-manager.users.guanranwang.imports = map (n: ../../../../home-manager/${n}) [
    "modules/terms/alacritty.nix"
    "modules/shell/fish.nix"
    "modules/shell/bash.nix"
    "modules/editor/helix.nix"
    "modules/editor/neovim.nix"
    "modules/editor/vscode.nix"

    "profiles/graphical-stuff/darwin"
  ];
}
