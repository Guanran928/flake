{
  pkgs,
  inputs,
  ...
}: let
  gamePkgs = inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system};
in {
  programs.mangohud.enable = true;

  home.packages = with pkgs;
    [
      (prismlauncher.override {glfw = glfw-wayland-minecraft;})
      mumble
      steam
      # (pkgs.steam.override {extraProfile = "export STEAM_EXTRA_COMPAT_TOOLS_PATHS='${gamePkgs.proton-ge}'";})
      # lunar-client
      # protonup-qt
    ]
    ++ (with gamePkgs; [
      osu-lazer-bin
      # (osu-stable.override {location = "${config.xdg.dataHome}/osu-stable";})
    ]);
}
