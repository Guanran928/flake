{...}: {
  imports = [
    ../../../../home-manager
  ];

  # https://github.com/mathiasbynens/dotfiles/blob/main/.macos
  targets.darwin.defaults = {
    ### Inputs
    ".GlobalPreferences"."com.apple.mouse.scaling" = "-1"; # Disable mouse acceleration

    ### .DS_Store
    "com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };

    ### Dock
    "com.apple.dock".autohide = true;

    ### Finder
    "com.apple.finder" = {
      _FXShowPosixPathInTitle = false;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      CreateDesktop = false;
      FXDefaultSearchScope = "SCcf"; # Current folder
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv"; # List view
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = false;
    };
  };
}
