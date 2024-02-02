{
  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        icons = "material-nf";
        blocks = [
          ### Monitor
          {
            block = "disk_space";
            path = "/nix";
          }
          {block = "memory";}
          {block = "cpu";}
          {block = "load";}

          ### Stuff that I actually need
          {block = "backlight";}
          {block = "sound";}
          {block = "battery";}
          {block = "time";}
        ];
      };
    };
  };
}
