{ pkgs, ... }:

{
  # Fonts
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      inter
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      source-han-sans
      source-han-serif
      source-han-mono
      #wqy_zenhei # weird font shape, noto sans cjk is a better alternative
      #wqy_microhei
      fira-code
      jetbrains-mono
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    ];
    fontconfig = {
      cache32Bit = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        serif = [ "Noto Serif" ];
        sansSerif = [ "Inter" "Noto Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" "JetBrains Mono" "FiraCode Nerd Font" "Fira Code" "Noto Sans Mono" ];
      };
    };
    # fontconfig is too limited here, use `$HOME/.config/fontconfig/fonts.conf` instead
  };
}
