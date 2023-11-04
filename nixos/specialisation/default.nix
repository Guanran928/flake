{...}: {
  specialisation = {
    bspwm.configuration = {
      system.nixos.tags = ["bspwm"];
      services.xserver = {
        displayManager.startx.enable = true;
        windowManager.bspwm.enable = true;
      };
    };
    plasma.configuration = {
      system.nixos.tags = ["plasma"];
      services.xserver = {
        desktopManager.plasma5.enable = true;
        displayManager.sddm = {
          enable = true;
          settings.General.DisplayServer = "wayland";
        };
      };
    };
  };
}
