{pkgs, ...}: {
  fonts.fontconfig.enable = true;
  xdg.configFile."fontconfig" = {
    source = ../../../dotfiles/config/fontconfig;
    recursive = true;
  };

  home.packages = with pkgs; [
    ### Inter
    inter

    ### JetBrains Mono Nerd Font
    (nerdfonts.override {fonts = ["JetBrainsMono"];})

    ### Adobe Source Han
    source-han-sans
    source-han-serif
    source-han-mono

    ### Noto Fonts
    noto-fonts
    noto-fonts-color-emoji
  ];
}
