{
  lib,
  config,
  ...
}: let
  cfg = config.myFlake.nixos.hardware.gpu.nvidia;
in {
  options = {
    myFlake.nixos.hardware.gpu.nvidia.enable = lib.mkEnableOption "Whether to enable NVIDIA GPU.";
    myFlake.nixos.hardware.gpu.nvidia.prime = lib.mkEnableOption "Whether to enable NVIDIA Prime.";
  };

  # https://nixos.wiki/wiki/Nvidia
  config = lib.mkIf cfg.enable {
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    services.xserver.videoDrivers = ["nvidia"]; # tell xorg to use the nvidia driver, also valid for wayland
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

    # cfg.prime
    hardware.nvidia.prime = lib.mkIf cfg.prime {
      sync.enable = false;
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      ### Device specific, please put those configuration in `machines/your-machine.nix`
      # nvidiaBusId = "PCI:1:0:0";
      # intelBusId = "PCI:0:2:0";
    };
    environment.sessionVariables = {
      "GAMEMODERUNEXEC" = lib.mkIf (cfg.prime || config.programs.gamemode.enable) "env __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only"; # gamemode: nvidia offload
    };
  };
}
