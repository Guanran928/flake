{
  pkgs,
  config,
  ...
}: {
  home = {
    username = "guanranwang";
    homeDirectory =
      if pkgs.stdenv.hostPlatform.isDarwin
      then "/Users/${config.home.username}"
      else "/home/${config.home.username}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Default applications
  imports = [
    ./modules

    ./applications/git
    ./applications/gpg
    ./applications/starship
    ./applications/eza
    ./applications/skim
    ./applications/bat
    ./applications/bottom
    ./applications/zoxide
    ./applications/ripgrep
    ./applications/wget
    ./applications/fd
    ./applications/hyperfine
    ./applications/atuin
    ./applications/zellij

    ./applications/ydict
    ./applications/fastfetch
    ./applications/android-tools
    ./applications/tealdeer
  ];

  home.shellAliases = {
    ".." = "cd ..";
    "farsee" = "curl -F 'c=@-' 'https://fars.ee/'"; # pb
  };
}
