{pkgs, ...}: {
  programs.mangohud.enable = true;

  home.packages = with pkgs; [
    (prismlauncher.override {glfw = glfw-wayland-minecraft;})
    (steam.override {
      extraEnv = {
        # STEAM_EXTRA_COMPAT_TOOLS_PATHS = gamePkgs.proton-ge;
      };
    })
    mumble
    osu-lazer-bin
    # lunar-client
    # protonup-qt
  ];
}
