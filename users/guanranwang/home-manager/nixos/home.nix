{
  config,
  pkgs,
  ...
}: {
  home = {
    username = "guanranwang";
    homeDirectory = "/home/guanranwang";

    packages =
      (with pkgs; [
        # x11 + wayland
        rofi-wayland
        rofi-power-menu
        pamixer
        brightnessctl
        playerctl
        #networkmanagerapplet
        pavucontrol

        # wayland
        wl-clipboard
        cliphist
        swaylock-effects
        grim
        slurp
        swappy
        mpvpaper
        libnotify
        jq

        # x11
        #polybar
        #picom
        #feh
        #flameshot

        # gui
        gparted
        timeshift
        mpv
        spicetify-cli

        ### matrix
        #fluffychat
        element-desktop
        cinny-desktop
        #nheko

        ### music
        easyeffects
        spotify
        yesplaymusic
        amberol
        netease-cloud-music-gtk

        ### misc
        bitwarden
        #discord
        #qq
        tuba
        mousai
        protonup-qt
        piper
        telegram-desktop
        qbittorrent
        gradience
        dippi
        obs-studio
        gnome.seahorse
        gnome.eog
        gnome.file-roller
        gnome.gnome-weather
        gnome.gnome-calculator
        gnome.dconf-editor

        # TUI
        cava
        joshuto # rs
        bottom
        helix
        skim
        bat

        # cli
        #fastfetch
        wget
        sops
        skim
        ydict
        nix-output-monitor
        zoxide # rs
        trashy
        eza
        ripgrep
        fd
        freshfetch
        hyperfine

        # lsp
        nil
        gopls
        libclang

        # themes
        tela-icon-theme
        tela-circle-icon-theme
        papirus-icon-theme
        adw-gtk3
      ])
      ++ (with pkgs.gnome; [
        # GNOME
        nautilus
        zenity

        # GNOME only
        #gnome-tweaks
        #gnome-software
        #gnome-shell-extensions
      ])
      ++ (with pkgs.gnomeExtensions; [
        # GNOME extensions
        arcmenu
        appindicator
        blur-my-shell
        caffeine
        dash-to-panel
        dash-to-dock
        gamemode # outdated
        just-perfection
        kimpanel
      ]);

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 24;
    };
  };

  gtk = {
    enable = true;
    font.name = "Sans";
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 24;
    };
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      #name = "Tela-dracula-dark";
      #package = pkgs.tela-icon-theme;
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  };

  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      "titlebar-font" = "Sans Bold";
      "button-layout" = "icon,appmenu:";
    };
    "org/gnome/desktop/interface" = {
      "clock-format" = "12h";
      "color-scheme" = "prefer-dark";
      "document-font-name" = "Sans";
      "font-name" = "Sans";
      "monospace-font-name" = "Monospace";
    };
  };

  fonts.fontconfig.enable = true;

  # X resources file
  # ~/.Xresources
  xresources.properties = {
    # Cursor
    "Xcursor.theme" = "Adwaita";

    # Fonts
    "Xft.autohint" = "0";
    "Xft.lcdfilter" = "lcddefault";
    "Xft.hintstyle" = "hintslight";
    "Xft.hinting" = "1";
    "Xft.antialias" = "1";
    "Xft.rgba" = "rgb";

    # Tokyonight color scheme
    # i have no idea what does it apply to
    "*background" = "#1a1b26";
    "*foreground" = "#c0caf5";

    "*color0" = "#15161e";
    "*color1" = "#f7768e";
    "*color2" = "#9ece6a";
    "*color3" = "#e0af68";
    "*color4" = "#7aa2f7";
    "*color5" = "#bb9af7";
    "*color6" = "#7dcfff";
    "*color7" = "#a9b1d6";

    "*color8" = "#414868";
    "*color9" = "#f7768e";
    "*color10" = "#9ece6a";
    "*color11" = "#e0af68";
    "*color12" = "#7aa2f7";
    "*color13" = "#bb9af7";
    "*color14" = "#7dcfff";
    "*color15" = "#c0caf5";
  };

  wayland.windowManager = {
    hyprland = {
      #enable = true;
      enableNvidiaPatches = true;
      xwayland.enable = true;
      plugins = [
        #inputs.hyprland-plugins.packages.${pkgs.system}.csgo-vulkan-fix
      ];

      extraConfig = ''
        #source = ~/.config/hypr/themes/mocha.conf
        #source = ~/.config/hypr/themes/colors.conf
        #source = ~/.config/hypr/plugins.conf
        source = ~/.config/hypr/main.conf
        source = ~/.config/hypr/keybinds.conf
        source = ~/.config/hypr/autostart.conf
        source = ~/.config/hypr/env.conf
      '';
    };
  };

  #xsession = {
  #  enable = true;
  #  windowManager.bspwm = {
  #    enable = true;
  #  };
  #};

  services = {
    udiskie.enable = true;
    swayidle = let
      lockCommand = "${pkgs.swaylock-effects}/bin/swaylock --screenshots --clock --indicator --line-color cdd6f4ff --text-color cdd6f4ff --inside-color 1e1e2eff --ring-color 313244ff --line-ver-color cdd6f4ff --text-ver-color cdd6f4ff --inside-ver-color 1e1e2eff --ring-ver-color 313244ff --line-clear-color cdd6f4ff --text-clear-color cdd6f4ff --inside-clear-color 1e1e2eff --ring-clear-color 313244ff --line-clear-color cdd6f4ff --text-wrong-color 313244ff --inside-wrong-color f38ba8ff --ring-wrong-color 313244ff --key-hl-color cba6f7ff --effect-blur 7x5 --effect-vignette 0.5:0.5 --fade-in 0.2";
    in {
      enable = true;
      timeouts = [
        {
          timeout = 900;
          command = "loginctl lock-session";
        }
        {
          timeout = 905;
          command = ''${pkgs.sway}/bin/swaymsg "output * dpms off"'';
          resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * dpms on"'';
        } # turn off screen
      ];
      events = [
        {
          event = "lock";
          command = lockCommand;
        } # loginctl lock-session
        {
          event = "before-sleep";
          command = lockCommand;
        } # systemctl syspend
      ];
    };
  };

  programs = {
    rofi = {
      #enable = true;
      package = pkgs.rofi-wayland;
      font = "monospace";
      terminal = "${pkgs.alacritty}/bin/alacritty";
    };

    #boxxy = {
    #  enable = true;
    #  #rules = {
    #  #
    #  #};
    #};

    firefox = {
      #enable = true;
      profiles."default" = {};
    };

    librewolf = {
      enable = true;
      settings = {
        "identity.fxaccounts.enabled" = true;

        # https:#github.com/yokoffing/Betterfox/blob/main/librewolf.overrides.cfg
        ### SECTION: FASTFOX
        "layout.css.grid-template-masonry-value.enabled" = true;
        "dom.enable_web_task_scheduling" = true;

        ### SECTION: SECUREFOX
        # TRACKING PROTECTION
        "urlclassifier.trackingSkipURLs" = "*.reddit.com, *.twitter.com, *.twimg.com";
        "urlclassifier.features.socialtracking.skipURLs" = "*.instagram.com, *.twitter.com, *.twimg.com";

        ### OCSP & CERTS / HPKP
        # Use CRLite instead of OCSP
        "security.OCSP.enabled" = 0;
        "security.OCSP.require" = false;
        "security.pki.crlite_mode" = 2;

        ### RFP
        # Limits refresh rate to 60mHz, breaks timezone, and forced light theme
        # [1] https:#librewolf.net/docs/faq/#what-are-the-most-common-downsides-of-rfp-resist-fingerprinting
        "privacy.resistFingerprinting" = false;

        ### WebGL
        # Breaks Map sites, NYT articles, Nat Geo, and more
        # [1] https:#manu.ninja/25-real-world-applications-using-webgl/
        "webgl.disabled" = false;

        # DRM
        # Netflix, Udemy, Spotify, etc.
        "media.eme.enabled" = true;

        # HTTPS-ONLY MODE
        "dom.security.https_only_mode_error_page_user_suggestions" = true;

        # PASSWORDS AND AUTOFILL
        "signon.generation.enabled" = false;

        ### WEBRTC
        # Breaks video conferencing
        "media.peerconnection.ice.no_host" = false;

        ### PERMISSIONS
        "permissions.default.geo" = 2;
        "permissions.default.desktop-notification" = 2;
        "dom.push.enabled" = false;

        ### SECTION: PESKYFOX
        ### MOZILLA UI
        "layout.css.prefers-color-scheme.content-override" = 2;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.compactmode.show" = true;

        ### FULLSCREEN
        "full-screen-api.transition-duration.enter" = "0 0";
        "full-screen-api.transition-duration.leave" = "0 0";
        "full-screen-api.warning.delay" = 0;
        "full-screen-api.warning.timeout" = 0;

        ### URL BAR
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.urlbar.suggest.calculator" = true;
        "browser.urlbar.unitConversion.enabled" = true;

        ### AUTOPLAY
        # Default breaks some video players
        "media.autoplay.blocking_policy" = 0;

        #### PASSWORDS
        "editor.truncate_user_pastes" = false;

        #### DOWNLOADS
        "browser.download.autohideButton" = true;

        ### PDF
        "browser.download.open_pdf_attachments_inline" = true;

        ### TAB BEHAVIOR
        "browser.tabs.loadBookmarksInTabs" = true;
        "browser.bookmarks.openInTabClosesMenu" = false;
        "findbar.highlightAll" = true;

        ### SECTION: SMOOTHFOX
        "apz.overscroll.enabled" = true;
        "general.smoothScroll" = true;
        "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;
        "general.smoothScroll.msdPhysics.enabled" = true;
        "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
        "general.smoothScroll.msdPhysics.regularSpringConstant" = 650;
        "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 25;
        "general.smoothScroll.msdPhysics.slowdownMinDeltaRatio" = "2.0";
        "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;
        "general.smoothScroll.currentVelocityWeighting" = "1.0";
        "general.smoothScroll.stopDecelerationWeighting" = "1.0";
        "mousewheel.default.delta_multiplier_y" = 75;
      };
    };

    chromium = {
      enable = true;
      #package = pkgs.ungoogled-chromium;
      # ungoogled-chrome does not work with extensions for now
      # https://github.com/nix-community/home-manager/issues/2216
      # https://github.com/nix-community/home-manager/issues/2585
      extensions = [
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin
        {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # sponsorblock
        {id = "icallnadddjmdinamnolclfjanhfoafe";} # fastforward
        {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # vimium
        {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
        {id = "gebbhagfogifgggkldgodflihgfeippi";} # return youtube dislike
        {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # dark reader
        {id = "njdfdhgcmkocbgbhcioffdbicglldapd";} # localcdn
        {id = "hipekcciheckooncpjeljhnekcoolahp";} # tabliss
        {id = "bgfofngpplpmpijncjegfdgilpgamhdk";} # modern scrollbar
        {id = "ajhmfdgkijocedmfjonnpjfojldioehi";} # privacy pass
        {id = "hkgfoiooedgoejojocmhlaklaeopbecg";} # picture in picture
        #{ id = "fnaicdffflnofjppbagibeoednhnbjhg"; } # floccus bookmark sync
        #{ id = "jaoafjdoijdconemdmodhbfpianehlon"; } # skip redirect
        #{ id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; } # tampermonkey
        #{ id = "jinjaccalgkegednnccohejagnlnfdag"; } # violentmonkey
        #{ id = "kdbmhfkmnlmbkgbabkdealhhbfhlmmon"; } # steamdb
        #{ id = "cmeakgjggjdlcpncigglobpjbkabhmjl"; } # steam inventory helper
        #{ id = "mgijmajocgfcbeboacabfgobmjgjcoja"; } # google dictionary
        #{ id = "kbfnbcaeplbcioakkpcpgfkobkghlhen"; } # grammarly
        #{ id = "ekbmhggedfdlajiikminikhcjffbleac"; } # 喵喵折+
      ];
    };
  };
}
