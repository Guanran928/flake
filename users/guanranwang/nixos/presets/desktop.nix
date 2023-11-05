{...}: {
  imports = [
    ./core.nix

    ### Flakes
    ../../../../flakes/nixos/home-manager.nix
    ../../../../flakes/nixos/berberman.nix
  ];

  ### home-manager
  home-manager.users.guanranwang = import ../../home-manager/nixos/presets/desktop.nix;
  fonts.enableDefaultPackages = false;
  security.pam.services.swaylock = {};
}
