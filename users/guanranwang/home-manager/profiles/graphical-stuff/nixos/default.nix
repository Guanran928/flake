{...}: {
  imports =
    [
      ./fonts
      ./scripts
      ./wallpapers

      ./packages.nix
      ./input-method.nix
      ./theme.nix
      ./xdg-mime.nix
    ]
    ++ map (n: ../../../../home-manager/applications/${n}) [
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
      "spotify"
      "amberol"
      "mousai"

      # WM
      "sway"

      # Misc
      "irssi"
      "mumble"
    ];
}
