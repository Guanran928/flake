{pkgs, ...}: {
  home.packages = [(pkgs.prismlauncher.override {glfw = pkgs.glfw-wayland-minecraft;})];
}
