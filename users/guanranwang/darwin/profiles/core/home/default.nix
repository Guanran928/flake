{pkgs, ...}: {
  imports = [
    ../../../../home-manager
  ];
  home.packages = with pkgs; [
    ### Outdated macOS components
    coreutils
    vim
    gnugrep
    openssh
    screen
  ];
}
