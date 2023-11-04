{pkgs, ...}: {
  # Fonts
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      ### Noto Fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji

      ### Source Han
      source-han-sans
      source-han-serif
      source-han-mono

      ### CJK
      #wqy_zenhei # weird font shape, noto sans cjk is a better alternative
      #wqy_microhei

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
    fontconfig = {
      cache32Bit = true;
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        serif = ["Noto Serif"];
        sansSerif = ["Inter" "Noto Sans"];
        monospace = ["JetBrainsMono Nerd Font" "JetBrains Mono" "FiraCode Nerd Font" "Fira Code" "Noto Sans Mono"];
      };
    };
    # fontconfig is too limited here, and appling it globally is **bad**, use Home Manager instead
  };
}
