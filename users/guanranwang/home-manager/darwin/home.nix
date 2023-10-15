{ config, pkgs, lib, ... }:

{
  home = {
    username = "guanranwang";
    homeDirectory = "/Users/guanranwang";

    activation = {
      # Workaround for spotlight indexing
      # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1705731962_
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
      setSystemProxy = let networksetup = /usr/sbin/networksetup;
      in lib.hm.dag.entryAfter ["writeBoundary"] ''
        ${networksetup} -setwebproxystate "Wi-fi" on
        ${networksetup} -setwebproxy "Wi-fi" 127.0.0.1 7890
        ${networksetup} -setwebproxystate "Ethernet" on
        ${networksetup} -setwebproxy "Ethernet" 127.0.0.1 7890
      '';
    };

    packages = with pkgs; [
      ## CLI
      ### outdated macOS components
      coreutils
      vim
      gnugrep
      openssh
      screen
      ### Misc
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


      ## GUI
      ### Music
      spotify
      spicetify-cli
      yesplaymusic
      mpv
      ### Tools
      keka # un-archive-r
      iterm2
      ### Misc
      prismlauncher
      element-desktop


      ## Misc
      ### LSP
      nixd
      nil
    ];
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