{pkgs, ...}: {
  imports = [../resources/common];
  home.packages = with pkgs; [
    ### Outdated macOS components
    coreutils
    vim
    gnugrep
    openssh
    screen
  ];
}
