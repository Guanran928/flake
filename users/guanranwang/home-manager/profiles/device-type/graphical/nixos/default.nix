{...}: {
  imports =
    [
      ./fonts
      ./scripts
      ./wallpapers

      ./packages.nix
      ./theme.nix
      ./xdg-mime.nix
    ]
    ++ map (n: ../../../../applications/${n}) [
      # Terminal
      "alacritty"

      # Shell
      "fish"
      "bash"

      # Editor
      "helix"
      "neovim"
      "vscode"

      # Browser
      "chromium"
      "librewolf"

      # Language
      "nix"
      "go"

      # Media
      "loupe"
      "mpv"
      "spotify/spicetify.nix"
      "amberol"
      "mousai"

      # WM
      "sway"

      # Misc
      "fcitx5"
      "irssi"
      "mumble"
    ];
}
