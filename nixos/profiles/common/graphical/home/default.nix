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
    ++ map (n: ../../../../../home/applications/${n}) [
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
      #"librewolf"
      "firefox"

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
      "thunderbird"
      "telegram-desktop"
      "nautilus"
      "fcitx5"
      "irssi"
      "mumble"
    ];

  # https://wiki.archlinux.org/title/Fish#Start_X_at_login
  programs.fish.loginShellInit = ''
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
      exec sway
    end
  '';
}
