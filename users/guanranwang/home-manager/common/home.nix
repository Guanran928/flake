{ pkgs, config, lib, ... }:

{
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

    shellAliases =
    let
      proxy = "http://127.0.0.1:7890/";
    in {
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

      "farsee" = "curl -F 'c=@-' 'https://fars.ee/'"; # pb
      "clock" = "tty-clock -5Ccs";

      # proxy
      "setproxy" = "export https_proxy=${proxy} http_proxy=${proxy} all_proxy=${proxy}";
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

    bash = {
      enable = true;
      historyFile = "${config.xdg.configHome}/bash/.bash_history";
    };
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      enableAutosuggestions = true;
      dotDir = ".config/zsh";
      initExtra = ''
        source ${config.xdg.configHome}/zsh/plugins/sudo/sudo.plugin.zsh
        source ${config.xdg.configHome}/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
        zstyle ':fzf-tab:*' fzf-command sk
      '';
      history = {
        path = "${config.xdg.configHome}/zsh/.zsh_history";
        save = 1000000;
        size = 1000000;
      };
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
        source ${config.xdg.configHome}/fish/tokyonight_night.fish
      '';
    };

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
    };

    alacritty = {
      enable = true;
      settings = {
        import = [ "${config.xdg.configHome}/alacritty/tokyonight/tokyonight_night.yml" ];
        cursor.style = "beam";
        env.WINIT_X11_SCALE_FACTOR = "1";
        window = {
          #opacity = 0.9;
          padding = {
            x = 12;
            y = 12;
          };
        };
        font = {
          size = 12;
          normal = {
            family = lib.mkDefault "monospace"; # macOS dont have fontconfig, so mkDefault is nessesary
            style = "SemiBold";
          };
          bold = {
            family = lib.mkDefault "monospace";
            style = "Bold";
          };
          bold_italic = {
            family = lib.mkDefault "monospace";
            style = "Bold Itailc";
          };
          italic = {
            family = lib.mkDefault "monospace";
            style = "SemiBold Italic";
          };
        };
      };
    };

    # Editors
    ### VSCode
    vscode = {
      enable = true;
      package = pkgs.vscodium; # foss
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      userSettings = {
        "diffEditor.ignoreTrimWhitespace"     = false;
        "editor.cursorSmoothCaretAnimation"   = "on";
        "editor.cursorBlinking"               = "smooth";
        "editor.fontFamily"     = lib.mkDefault "Monospace";
        "editor.fontWeight"                   = "600";
        "editor.tabSize"                      = 2;
        "explorer.confirmDragAndDrop"         = false;
        "explorer.confirmDelete"              = false;
        "files.autoSave"                      = "onFocusChange";
        "files.trimTrailingWhitespace"        = true;
        "files.trimFinalNewlines"             = true;
        "security.workspace.trust.enabled"    = false;
        "telemetry.telemetryLevel"            = "off";
        "terminal.external.osxExec"           = "Alacritty.app";
        "terminal.integrated.cursorBlinking"  = true;
        "update.mode"                         = "none";
        "window.menuBarVisibility"            = "toggle";
        "workbench.colorTheme"                = "Tokyo Night";

        # Extensions
        ### Nix IDE
        "nix.enableLanguageServer"    = true;
        #"nix.serverPath"              = "nixd";
        "nix.serverPath"              = "nil";
        ### GitLens
        "gitlens.telemetry.enabled"   = false;
      };
      extensions = with pkgs.vscode-extensions; [
        # lsp
        #bbenoist.nix
        jnoortheen.nix-ide
        #ms-python.python # Temporary disable this, as debugpy is stuck at building (literally waited for 40 minute + 6 hour + 2 hour...)
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        #bungcip.better-toml

        # qol
        eamodio.gitlens
        esbenp.prettier-vscode
        ritwickdey.liveserver
        vscodevim.vim

        # theme
        enkia.tokyo-night
        #catppuccin.catppuccin-vsc-icons
        #catppuccin.catppuccin-vsc
      ];
    };
    ### Neovim
    neovim = {
      enable = true;
      #defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    ### Helix
    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "tokyonight";
        editor = {
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          file-picker = {
            hidden = false;
          };
        };
      };
    };
  };
}