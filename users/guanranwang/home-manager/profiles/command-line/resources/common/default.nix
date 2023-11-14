{
  pkgs,
  lib,
  ...
}: {
  home = {
    shellAliases = {
      # navigation
      "ls" = "eza";
      "tree" = "ls --tree";
      ".." = "cd ..";

      "farsee" = "curl -F 'c=@-' 'https://fars.ee/'"; # pb

      # proxy
      "setproxy" = let
        proxy = "http://127.0.0.1:7890/";
      in "export http_proxy=${proxy} https_proxy=${proxy} ftp_proxy=${proxy} rsync_proxy=${proxy}";
      "unsetproxy" = "set -e http_proxy https_proxy all_proxy"; # fish syntax (?)
    };
    sessionVariables = {
      # Bat
      "MANPAGER" = "sh -c 'col -bx | bat -l man -p'";
      "MANROFFOPT" = "-c";
    };

    packages = with pkgs; [
      ### Nix
      sops
      nix-output-monitor

      ### Misc
      wget
      fd
      hyperfine
    ];
  };
  programs = {
    tealdeer.enable = true;
    zoxide.enable = true;
    bat.enable = true;
    bottom.enable = true;
    joshuto.enable = true;
    ripgrep.enable = true;

    starship = {
      enable = true;
      settings = lib.mkMerge [
        {
          add_newline = false;
          line_break.disabled = true;

          character = {
            success_symbol = "[>](bold green)";
            error_symbol = "[>](bold red)";
            vimcmd_symbol = "[<](bold green)";
            vimcmd_replace_one_symbol = "[<](bold purple)";
            vimcmd_replace_symbol = "[<](bold purple)";
            vimcmd_visual_symbol = "[<](bold yellow)";
          };
        }
        (builtins.fromTOML (builtins.readFile "${pkgs.starship}/share/starship/presets/nerd-font-symbols.toml"))
      ];
    };

    eza = {
      enable = true;
      git = true;
      icons = true;
      extraOptions = ["--header"];
      # Fish have builtin aliases for `ls`, alias `ls` to `eza` is the only thing we want to do
      #enableAliases = true;
    };

    skim = {
      enable = true;
      defaultCommand = "rg --files || fd --type f || find .";
      # rg --files ran
      #   4.40 ± 0.44 times faster than fd --type f
      #  60.39 ± 5.80 times faster than find .
    };

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
