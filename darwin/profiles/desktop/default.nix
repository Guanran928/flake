{...}: {
  home-manager.users.guanranwang = import ./home;

  imports = [
    ../common/core
    ./packages
  ];
}
