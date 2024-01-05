_: {
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
          {block = "sound";}
          #{block = "battery";} # i cant get it working
          {block = "time";}
        ];
      };
    };
  };
}
