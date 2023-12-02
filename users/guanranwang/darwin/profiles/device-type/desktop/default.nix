_: {
  ### home-manager
  home-manager.users.guanranwang.imports = map (n: ../../../../home-manager/${n}) [
    "profiles/graphical-stuff/darwin"
  ];
}
