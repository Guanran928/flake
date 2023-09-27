{ lib, pkgs, ... }:

{
  imports = [
    ./networking
    ./packages
    ./users

    ./input.nix
  ];

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  # Allow unfree applications
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    #"vscode"
    "spotify"
    "keka" # i thought it was opensource
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    #neovim
    #vscode
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  #nix.settings.experimental-features = "nix-command flakes";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  programs.fish.enable = true;

  services = {
    yabai = {
      enable = true;
      enableScriptingAddition = true;
      config = {
        layout         = "bsp";
  
        mouse_modifier = "fn";
  
        # very broken on slow cpu
        #focus_follows_mouse = "autoraise";
        #mouse_follows_focus = "on";
  
        top_padding    = 10;
        bottom_padding = 10;
        left_padding   = 10;
        right_padding  = 10;
        window_gap     = 4;
      };
    };
    skhd = {
      enable = true;
      skhdConfig = ''
        cmd - return : open -n ${pkgs.alacritty}/Applications/Alacritty.app

        cmd - 1 : yabai -m space --focus 1             # Focus space
        cmd - 2 : yabai -m space --focus 2
        cmd - 3 : yabai -m space --focus 3
        cmd - 4 : yabai -m space --focus 4
        cmd - 5 : yabai -m space --focus 5

        shift + cmd - 1 : yabai -m window --space 1    # Send to space
        shift + cmd - 2 : yabai -m window --space 2
        shift + cmd - 3 : yabai -m window --space 3
        shift + cmd - 4 : yabai -m window --space 4
        shift + cmd - 5 : yabai -m window --space 5
      '';
    };
  };

  system.defaults = {
    # Apple... Do I really have to change literally 
    # every setting in macOS to make it actually usable.
    # 
    # Through this... you will see why I say macOS is a terriable mess.
    # 
    # NOTE: default of those options is `null` (unmanaged)
    #       https://github.com/mathiasbynens/dotfiles/blob/main/.macos for references
    finder = {
      _FXShowPosixPathInTitle = false;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      CreateDesktop = false;
      FXDefaultSearchScope = "SCcf";                              # "SCcf" = Current folder
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";                              # "icnv" = Icon view, "Nlsv" = List view, "clmv" = Column View, "Flwv" = Gallery View 
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = false;
    };
    loginwindow = {
      autoLoginUser = "Off";
      DisableConsoleAccess = true;
      GuestEnabled = false;
    };
    menuExtraClock = {
      IsAnalog = false;
      Show24Hour = false;
      ShowAMPM = true;
      ShowDate = 0;                                                # 0 = show, 1, 2 = don't show
      ShowDayOfMonth = true;
      ShowDayOfWeek = true;
      ShowSeconds = false;
    };
    NSGlobalDomain = {
      "com.apple.keyboard.fnState" = true;
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.sound.beep.feedback" = 0;
      "com.apple.springing.enabled" = true;
      "com.apple.swipescrolldirection" = true;                    # Natrual scrolling
      "com.apple.trackpad.enableSecondaryClick" = true;
      "com.apple.trackpad.trackpadCornerClickBehavior" = null;    # ??? "null or value 1 (singular enum)"
      #"com.apple.trackpad.scaling" = -1;
      _HIHideMenuBar = false;
      AppleEnableMouseSwipeNavigateWithScrolls = true;            # Magic Mouse
      AppleEnableSwipeNavigateWithScrolls = true;                 # Trackpad
      AppleFontSmoothing = 1;                                     # https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
      AppleICUForce24HourTime = false;
      AppleInterfaceStyle = "Dark";                               # "null or value "Dark" (singular enum)"
      AppleInterfaceStyleSwitchesAutomatically = false;
      AppleKeyboardUIMode = 3;                                    # ??? "null or value 3 (singular enum)"
      AppleMeasurementUnits = "Centimeters";                      # "null or one of "Centimeters", "Inches""
      ApplePressAndHoldEnabled = false;                           # https://stackoverflow.com/questions/33152551/how-can-i-disable-applepressandholdenabled-for-a-specific-application-repeat#33497193
      AppleScrollerPagingBehavior = false;
      #AppleShowAllExtensions = true;                             # Dupelicate?
      #AppleShowAllFiles = true;
      AppleShowScrollBars = "Always";
      AppleTemperatureUnit = "Celsius";                           # "null or one of "Celsius", "Fahrenheit"" 
      #AppleWindowTabbingMode # ?
      InitialKeyRepeat = 32;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled  = false;
      #NSAutomaticWindowAnimationsEnabled
      NSDisableAutomaticTermination = true;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      NSScrollAnimationEnabled = true;
      #NSTableViewDefaultSizeMode
      NSTextShowsControlCharacters = true;
      NSUseAnimatedFocusRing = false;
      NSWindowResizeTime = 0.001;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
    };
  };

  # Set Git commit hash for darwin-version.
  #system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}