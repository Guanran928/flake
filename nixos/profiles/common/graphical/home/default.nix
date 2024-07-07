{pkgs, ...}: {
  imports =
    [
      ./fonts
      ./theme.nix
      ./xdg-mime.nix
    ]
    ++ map (n: ../../../../../home/applications/${n}) [
      "fcitx5"
      "firefox"
      "foot"
      "go"
      "mpv"
      "nautilus"
      "nix"
      "sway"
    ];

  # https://wiki.archlinux.org/title/Fish#Start_X_at_login
  programs.fish.loginShellInit = ''
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
      exec sway
    end
  '';

  home.packages = with pkgs; [
    loupe
    gnome-calculator
    seahorse
    file-roller
    dconf-editor
  ];

  services = {
    ssh-agent.enable = true;
  };
}
