{
  pkgs,
  inputs,
  ...
}: {
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

  # https://wiki.archlinux.org/title/Fish#Start_X_at_login
  programs.fish.loginShellInit = ''
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
      exec sway
    end
  '';

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
    inputs.self.legacyPackages.${pkgs.stdenv.hostPlatform.system}.scripts.lofi
  ];

  programs.obs-studio.enable = true;
}
