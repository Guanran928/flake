{
  pkgs,
  ...
}:
{
  home = {
    username = "guanranwang";
    homeDirectory = "/home/guanranwang";
    stateVersion = "23.05";
  };

  imports =
    [
      ./theme.nix
      ./xdg-mime.nix
    ]
    ++ map (n: ./applications/${n}) [
      "atuin"
      "bash"
      "bat"
      "eza"
      "fcitx5"
      "firefox"
      "fish"
      "foot"
      "git"
      "go"
      "gpg"
      "mpv"
      "nautilus"
      "neovim"
      "nix"
      "ssh"
      "starship"
      "sway"
      "tealdeer"
      "thunderbird"
      "tmux"
      "ydict"
    ];

  programs.jq.enable = true;
  programs.obs-studio.enable = true;
  programs.ripgrep.enable = true;
  programs.skim.enable = true;
  programs.zoxide.enable = true;

  home.packages = with pkgs; [
    fastfetch
    fd
    dconf-editor
    file-roller
    fractal
    gnome-calculator
    hyperfine
    loupe
    seahorse
  ];

}
