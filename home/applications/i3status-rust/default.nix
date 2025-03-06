{
  programs.i3status-rust = {
    enable = true;
    bars.default = {
      icons = "material-nf";
      blocks = [
        { block = "backlight"; }
        { block = "sound"; }
        { block = "battery"; }
        {
          block = "net";
          format = " $icon {$ssid|Wired connection} ";
        }
        {
          block = "time";
          format = " $icon $timestamp.datetime(f:'%F %r') ";
          interval = 1;
        }
      ];
    };
  };
}
