{pkgs, ...}: {
  programs.mangohud.enable = true;

  home.packages = with pkgs; [
    (prismlauncher.override {glfw = glfw-wayland-minecraft;})
    steam
    mumble
    osu-lazer-bin
  ];

  home.sessionVariables = {
    # https://github.com/ppy/osu-framework/pull/6292
    "OSU_SDL3" = "1";
  };
}
