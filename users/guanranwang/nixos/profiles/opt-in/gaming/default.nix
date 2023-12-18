_: {
  ### home-manager
  home-manager.users.guanranwang.imports = [./home];

  ### for steam
  # https://github.com/NixOS/nixpkgs/issues/47932
  hardware.opengl.driSupport32Bit = true;
}
