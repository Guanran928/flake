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

  system.defaults = {
    # Apple... Do I really have to change literally 
    # every setting in macOS to make it actually usable
    # NOTE: default of those options is `null` (unmanaged)
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
    loginwindow = {
      autoLoginUser = "Off";
      DisableConsoleAccess = true;
      GuestEnabled = false;
    };
    menuExtraClock = {
      IsAnalog = false;
      Show24Hour = false;
      ShowAMPM = true;
      ShowDate = 0; # 0 = show, 1, 2 = don't show
      ShowDayOfMonth = true;
      ShowDayOfWeek = true;
      ShowSeconds = false;
    };
  };

  # Set Git commit hash for darwin-version.
  #system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}