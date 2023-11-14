{pkgs, ...}: {
  imports = [../resources/common];
  home.packages = with pkgs; [
    trashy
  ];
}
