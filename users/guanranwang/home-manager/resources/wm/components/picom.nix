{...}: {
  services.picom = {
    enable = true;
  };

  # TODO: picom.conf -> home-manager options
  xdg.configFile."picom/picom.conf".source = ../../dotfiles/config/picom/picom.conf;
}
