{pkgs, ...}: {
  fonts.fontconfig.enable = true;
  xdg.configFile."fontconfig" = {
    source = ../resources/dotfiles/config/fontconfig;
    recursive = true;
  };
  home.packages = with pkgs; [
    ### Sans
    inter

    ### Monospace
    jetbrains-mono
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "NerdFontsSymbolsOnly"
      ];
    })

    ### Adobe Source Han
    source-han-sans
    source-han-serif
    source-han-mono

    ### Noto Fonts
    noto-fonts
    noto-fonts-emoji
  ];
}
