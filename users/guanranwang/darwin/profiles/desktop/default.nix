_: {
  imports = [
    ../common/core
  ];
  ### home-manager
  home-manager.users.guanranwang = import ./home;
}
