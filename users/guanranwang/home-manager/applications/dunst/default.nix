{
  lib,
  config,
  pkgs,
  ...
}: {
  services.dunst = {
    enable = true;
    settings = lib.mkMerge [
      {
        global = {
          padding = 10;
          horizontal_padding = 10;
          frame_width = 2;
          font = "Monospace 10";
          icon_path = "/home/guanranwang/.local/share/icons/dunst";
          corner_radius = 10;

          max_icon_size = 128; # weird bug, default value (128) not working
        };
      }
      (lib.mkIf (config.myFlake.home-manager.colorScheme == "tokyonight")
        (builtins.fromTOML (builtins.readFile "${pkgs.vimPlugins.tokyonight-nvim}/extras/dunst/tokyonight_night.dunstrc")))
    ];
  };

  xdg.dataFile."icons/dunst" = {
    source = ./dunst;
    recursive = true;
  };
}
