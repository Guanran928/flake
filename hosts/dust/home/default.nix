{pkgs, ...}: {
  imports =
    [
      ./theme.nix
      ./xdg-mime.nix
    ]
    ++ map (n: ../../../home/applications/${n}) [
      "fcitx5"
      "firefox"
      "foot"
      "go"
      "mpv"
      "nautilus"
      "nix"
      "sway"
      "thunderbird"
      "ydict"
    ];

  home.packages = with pkgs; [
    amberol
    dconf-editor
    file-roller
    fractal
    gnome-calculator
    hyperfine
    loupe
    mousai
    seahorse
  ];

  programs.obs-studio.enable = true;
}
