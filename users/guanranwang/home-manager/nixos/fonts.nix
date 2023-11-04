{pkgs, ...}: {
  home.packages = with pkgs; [
    ### Noto Fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji

    ### Source Han
    source-han-sans
    source-han-serif
    source-han-mono

    ### Sans
    inter
    roboto

    ### Monospace
    fira-code
    jetbrains-mono
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "JetBrainsMono"
        "NerdFontsSymbolsOnly"
      ];
    })
  ];
}
