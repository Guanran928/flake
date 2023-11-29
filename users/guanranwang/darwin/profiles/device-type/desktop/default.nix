{...}: {
  ### home-manager
  home-manager.users.guanranwang.imports = map (n: ../../../../home-manager/${n}) [
    "applications/alacritty"
    "applications/fish"
    "applications/bash"
    "applications/helix"
    "applications/neovim"
    "applications/vscode"

    "profiles/graphical-stuff/darwin"
  ];
}
