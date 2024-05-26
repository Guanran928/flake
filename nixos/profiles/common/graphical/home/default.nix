{pkgs, ...}: {
  imports =
    [
      ./fonts
      ./theme.nix
      ./xdg-mime.nix
    ]
    ++ map (n: ../../../../../home/applications/${n}) [
      # Terminal
      "alacritty"

      # Editor
      "neovim"
      # "helix"
      # "vscode"

      # Browser
      "firefox"
      # "chromium"
      # "librewolf"

      # Language
      "nix"
      "go"

      # Media
      "loupe"
      "mpv"

      # WM
      "sway"

      # Misc
      "nautilus"
      "fcitx5"
    ];

  # https://wiki.archlinux.org/title/Fish#Start_X_at_login
  programs.fish.loginShellInit = ''
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
      exec sway
    end
  '';

  home.packages = with pkgs.gnome; [
    seahorse
    file-roller
    gnome-calculator
    dconf-editor
  ];

  services = {
    ssh-agent.enable = true;
  };
}
