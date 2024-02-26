{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = map (n: ../../../../home/applications/${n}) [
    # Terminal
    "alacritty"

    # Shell
    "fish"
    "bash"

    # Editor
    "helix"
    "neovim"
    "vscode"

    # Language
    "nix"
    "go"

    # Media
    "mpv"
    "spotify"

    # Misc
    "telegram-desktop"
  ];

  home = {
    activation = {
      # Workaround for spotlight indexing
      # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1705731962_
      trampolineApps = let
        apps = pkgs.buildEnv {
          name = "home-manager-applications";
          paths = config.home.packages;
          pathsToLink = "/Applications";
        };
      in
        lib.hm.dag.entryAfter ["writeBoundary"] ''
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
      ## GUI
      ### Tools
      keka # un-archive-r
      iterm2
      ### Misc
      element-desktop
    ];
  };

  # macOS don't have fontconfig
  programs = let
    monospace = "JetBrainsMono Nerd Font";
  in {
    ### VSCode
    vscode.userSettings.editor.fontFamily = monospace;

    ### Alacritty
    alacritty.settings.font = {
      normal.family = monospace;
      bold.family = monospace;
      bold_italic.family = monospace;
      italic.family = monospace;
    };
  };
}
