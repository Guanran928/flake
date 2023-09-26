{ config, ... }:

# NVIDIA drivers
# fuck you nvidia btw
{

  services.xserver.videoDrivers = [ "nvidia" ]; # tell xorg to use the nvidia driver, also valid for wayland
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = false;
    modesetting.enable = true;
    #dynamicboost.enable = true; 
    powerManagement = {
      enable = true; # experimental power management feature
      #finegrained = true;
    };
  };
}