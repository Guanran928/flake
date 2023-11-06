{...}: {
  imports = [
    ./components/dunst.nix
    ./components/feh.nix
    ./components/picom.nix
    ./components/polybar.nix
    ./components/sxhkd.nix
    ./components/udiskie.nix
  ];

  xsession = {
    enable = true;
    windowManager.bspwm = {
      enable = true;
      startupPrograms = [
        "pgrep -x sxhkd > /dev/null || sxhkd"
        "pgrep -x feh > /dev/null || feh --bg-fill ~/.local/share/backgrounds/wallpaper1.png"
      ];
      monitors = {
        eDP-1 = ["I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX" "X"];
      };
      settings = {
        border_width = 2;
        window_gap = 4;
        focus_follows_pointer = true;
        split_ratio = 0.52;
        borderless_monocle = true;
        gapless_monocle = true;
      };
    };
  };
}
