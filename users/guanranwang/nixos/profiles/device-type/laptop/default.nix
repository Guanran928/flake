{...}: {
  imports = [
    ../desktop
  ];

  home-manager.users.guanranwang = import ./home;
}
