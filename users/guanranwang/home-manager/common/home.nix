{ pkgs, config, lib, inputs, ... }:

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
      "setproxy" = let proxy = "http://127.0.0.1:7890/";
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

    bash = {
      enable = true;
      historyFile = "${config.xdg.configHome}/bash/.bash_history";
    };
    zsh = {
      enable = true;
      ### XDG
      dotDir = ".config/zsh";
      ### Plugins
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      enableAutosuggestions = true;
      plugins = [
        {
          name = "fzf-tab";
          src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
        }
        {
          # should I use flake inputs / fetchurl?
          name = "sudo";
          src = (pkgs.fetchFromGitHub {
            owner = "ohmyzsh";
            repo = "ohmyzsh";
            rev = "f8bf8f0029a475831ebfba0799975ede20e08742";
            hash = "sha256-9cJQQycahO+vo/YcAHjF+PVhsWxu7pa4MsK8Dgr69k0=";
            sparseCheckout = [
              "plugins/sudo"
            ];
          } + "/plugins/sudo");
        }
      ];
      initExtra = "zstyle ':fzf-tab:*' fzf-command sk";
      ### History
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
        import = [ "${inputs.tokyonight}/extras/alacritty/tokyonight_night.yml" ];
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

    kitty = {
      enable = true;
      settings = {
        include = "${inputs.tokyonight}/extras/kitty/tokyonight_night.conf";
        font_size = 12;
        confirm_os_window_close = 0;
        window_padding_width = 6;
        adjust_line_height = 0;
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
        "editor.cursorBlinking"               = "smooth";
        "editor.cursorSmoothCaretAnimation"   = "on";
        "editor.fontFamily"     = lib.mkDefault "Monospace";
        "editor.fontWeight"                   = 600;
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
        "workbench.colorTheme"   = "Tokyo Night";

        # Extensions
        ### Nix IDE
        "nix.enableLanguageServer"    = true;
        "nix.serverPath"              = "${pkgs.nil}/bin/nil";
        ### GitLens
        "gitlens.telemetry.enabled"   = false;
      };
      extensions = with pkgs.vscode-extensions; [
        ### LSP
        jnoortheen.nix-ide
        #ms-python.python
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        #bungcip.better-toml

        ### QoL
        eamodio.gitlens
        esbenp.prettier-vscode
        ritwickdey.liveserver
        vscodevim.vim

        ### Themes
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
