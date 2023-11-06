{...}: {
  imports = [
    ./components/dunst.nix
    ./components/feh.nix
    ./components/picom.nix
    ./components/polybar.nix
    ./components/sxhkd.nix
  ];

  xsession = {
    enable = true;
    windowManager.bspwm = {
      enable = true;
      extraConfig = builtins.readFile ../dotfiles/config/bspwm/bspwmrc;
    };
  };
}
