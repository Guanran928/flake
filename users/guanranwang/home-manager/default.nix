{pkgs, ...}: {
  home = {
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.05";

    shellAliases = {
      # navigation
      "l" = "${pkgs.eza}/bin/eza -Fhl --icons --git";
      "ll" = "${pkgs.eza}/bin/eza -Fahl --icons --git";
      "ls" = "${pkgs.eza}/bin/eza -F --icons --git";
      "la" = "${pkgs.eza}/bin/eza -Fa --icons --git";
      "tree" = "${pkgs.eza}/bin/eza --icons --git --tree";
      ".." = "cd ..";

      # replacements
      #"code" = "codium";
      #"neofetch" = "fastfetch";
      #"ranger" = "joshuto"; # rust
      #"grep" = "rg";
      #"top" = "btm -b";
      #"htop" = "btm -b";
      #"btop" = "btm";

      "yd" = "ydict -c";
      "farsee" = "curl -F 'c=@-' 'https://fars.ee/'"; # pb
      "clock" = "tty-clock -5Ccs";

      # proxy
      "setproxy" = let
        proxy = "http://127.0.0.1:7890/";
      in "export http_proxy=${proxy} https_proxy=${proxy} ftp_proxy=${proxy} rsync_proxy=${proxy}";
      "unsetproxy" = "set -e http_proxy https_proxy all_proxy"; # fish syntax (?)
    };
    sessionVariables = {
      # misc
      "MANPAGER" = "sh -c 'col -bx | bat -l man -p'"; # man: use bat as man's pager
      "MANROFFOPT" = "-c"; # man: fix formatting issue with bat
      "SKIM_DEFAULT_COMMAND" = "fd --type f || git ls-tree -r --name-only head || rg --files || find ."; # skim: use fd by default
    };
  };
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    tealdeer.enable = true;
    zoxide.enable = true;
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;
      };
    };

    #eza = {
    #  enable = true;
    #  git = true;
    #  icons = true;
    #};

    git = {
      enable = true;
      userName = "Guanran Wang";
      userEmail = "guanran928@outlook.com";
      delta.enable = true;
      signing.signByDefault = true;
      signing.key = "~/.ssh/id_github_signing";
      extraConfig = {
        gpg.format = "ssh";
        pull.rebase = true;
      };
    };
  };
}
