{...}: {
  services.polybar = {
    enable = true;
    script = "polybar bar";
    extraConfig = builtins.readFile ../../dotfiles/config/polybar/config.ini;
  };
}
