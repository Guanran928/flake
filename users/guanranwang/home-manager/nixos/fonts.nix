{pkgs, ...}: {
  fonts.fontconfig.enable = true;
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
