{...}: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        padding = 10;
        horizontal_padding = 10;
        frame_width = 2;
        font = "Monospace 10";
        icon_path = "/home/guanranwang/.local/share/icons/dunst";
        corner_radius = 10;

        max_icon_size = 128; # weird bug, default value (128) not working
      };

      # Tokyonight
      global = {
        frame_color = "#c0caf5";
        background = "#1a1b26";
        foreground = "#c0caf5";
      };

      urgency_critical.frame_color = "#fab387";
    };
  };

  xdg.dataFile."icons/dunst" = {
    source = ../../../dotfiles/data/icons/dunst;
    recursive = true;
  };
}
