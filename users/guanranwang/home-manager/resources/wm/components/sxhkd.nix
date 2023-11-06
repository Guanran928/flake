{...}: {
  services.sxhkd = {
    enable = true;
  };

  xdg.configFile = {
    "sxhkd" = {
      source = ../../dotfiles/config/sxhkd;
      recursive = true;
    };
  };
}
