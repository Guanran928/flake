{...}: {
  system.defaults = {
    # Apple... Do I really have to change literally
    # every setting in macOS to make it actually usable.
    #
    # Through this... you will see why I say macOS is a terriable mess.
    #
    # NOTE: default of those options is `null` (unmanaged)
    #       https://github.com/mathiasbynens/dotfiles/blob/main/.macos for references

    ### Inputs
    ".GlobalPreferences"."com.apple.mouse.scaling" = "-1"; # Disable mouse acceleration
    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };

    ### Finder
    finder = {
      _FXShowPosixPathInTitle = false;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      CreateDesktop = false;
      FXDefaultSearchScope = "SCcf"; # "SCcf" = Current folder
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv"; # "icnv" = Icon view, "Nlsv" = List view, "clmv" = Column View, "Flwv" = Gallery View
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = false;
    };

    ### Login window
    loginwindow = {
      autoLoginUser = "Off";
      DisableConsoleAccess = true;
      GuestEnabled = false;
    };

    ### Finder menu
    menuExtraClock = {
      IsAnalog = false;
      Show24Hour = false;
      ShowAMPM = true;
      ShowDate = 0; # 0 = show, 1, 2 = don't show
      ShowDayOfMonth = true;
      ShowDayOfWeek = true;
      ShowSeconds = false;
    };

    ### Misc
    NSGlobalDomain = {
      "com.apple.keyboard.fnState" = true;
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.sound.beep.feedback" = 0;
      "com.apple.springing.enabled" = true;
      "com.apple.swipescrolldirection" = true; # Natrual scrolling
      "com.apple.trackpad.enableSecondaryClick" = true;
      "com.apple.trackpad.trackpadCornerClickBehavior" = null; # ??? "null or value 1 (singular enum)"
      #"com.apple.trackpad.scaling" = -1;
      _HIHideMenuBar = false;
      AppleEnableMouseSwipeNavigateWithScrolls = true; # Magic Mouse
      AppleEnableSwipeNavigateWithScrolls = true; # Trackpad
      AppleFontSmoothing = 1; # https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
      AppleICUForce24HourTime = false;
      AppleInterfaceStyle = "Dark"; # "null or value "Dark" (singular enum)"
      AppleInterfaceStyleSwitchesAutomatically = false;
      AppleKeyboardUIMode = 3; # ??? "null or value 3 (singular enum)"
      AppleMeasurementUnits = "Centimeters"; # "null or one of "Centimeters", "Inches""
      ApplePressAndHoldEnabled = false; # https://stackoverflow.com/questions/33152551/how-can-i-disable-applepressandholdenabled-for-a-specific-application-repeat#33497193
      AppleScrollerPagingBehavior = false;
      #AppleShowAllExtensions = true;                             # Dupelicate?
      #AppleShowAllFiles = true;
      AppleShowScrollBars = "Always";
      AppleTemperatureUnit = "Celsius"; # "null or one of "Celsius", "Fahrenheit""
      #AppleWindowTabbingMode # ?
      InitialKeyRepeat = 32;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
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
}
