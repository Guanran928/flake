{ config, pkgs, lib, ... }:

{
  imports = [
    ./dotfiles.nix
    ../common/home.nix
  ];

  home = {
    username = "guanranwang";
    homeDirectory = "/Users/guanranwang";

    # Workaround for spotlight indexing
    # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1705731962_
    activation = {
      trampolineApps = let
        apps = pkgs.buildEnv {
          name = "home-manager-applications";
          paths = config.home.packages;
          pathsToLink = "/Applications";
        };
      in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        toDir="$HOME/Applications/Home Manager Trampolines"
        fromDir="${apps}/Applications/"
        rm -rf "$toDir"
        mkdir "$toDir"
        (
          cd "$fromDir"
          for app in *.app; do
            /usr/bin/osacompile -o "$toDir/$app" -e 'do shell script "open '$fromDir/$app'"'
          done
        )
      '';
    };

    packages = with pkgs; [
      #fastfetch
      neovim

      prismlauncher
      keka # un-archive-r
      iterm2
      element-desktop

      eza
      bottom
      bat
      fd
      git
      ripgrep
      yt-dlp
      aria2
      android-tools
      skim

      spotify
      spicetify-cli
      yesplaymusic
      mpv

      # replace outdated macOS components
      coreutils
      vim 
      gnugrep
      openssh
      screen

      # LSP
      nixd 
      nil
    ];

    sessionVariables = {
      "https_proxy" = "http://127.0.0.1:7890";
      "http_proxy" = "http://127.0.0.1:7890";
      "socks_proxy" = "socks5://127.0.0.1:7890";
      "all_proxy" = "socks5://127.0.0.1:7890";
    };
  };

  # macOS don't have fontconfig
  programs = let
    monospace = "JetBrainsMono Nerd Font";
  in {
    vscode.userSettings = {
      "editor.fontFamily" = "${monospace}";
    };

    alacritty.settings.font = {
      normal = {
        family = "${monospace}";
      };
      bold = {
        family = "${monospace}";
      };
      bold_italic = {
        family = "${monospace}";
      };
      italic = {
        family = "${monospace}";
      };
    };
  };
}