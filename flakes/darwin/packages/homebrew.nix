{ ... }:

{
  homebrew = {
    enable = true;
    brews = [
      "fastfetch" # fastfetch is broken in nixpkgs

      "yabai" # b3z/small
    ];
    casks = [
      #"alacritty"
      #"android-platform-tools"
      #"yesplaymusic"
      #"vscodium"

      "alt-tab"
    	"altserver"
      "balenaetcher"
      "clashx"
      "opencore-patcher"

      #"element"
      "telegram"

      "librewolf"
      "google-chrome"

      "steam"

      "activate" # koekeishiya/formulae
    ];
    taps = [
      "b3z/small" # activate
      "koekeishiya/formulae" # yabai
    ];
  };
}