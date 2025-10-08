{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        horizontal-pad = 10;
        image-size-ratio = 0;
      };

      border = {
        radius = 0;
      };

      # FIXME: Temporary color scheme
      # https://github.com/kuripa/oxocarbon-fuzzel/blob/master/output/oxocarbon-dark.ini
      colors = {
        background = "161616ff";
        text = "ffffffff";
        match = "ee5396ff";
        selection-match = "ee5396ff";
        selection = "262626ff";
        selection-text = "33b1ffff";
        border = "525252ff";
      };
    };
  };
}
