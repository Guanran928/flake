{
  lib,
  config,
  ...
}: let
  cfg = config.myFlake.nixos.hardware.components.gpu.nvidia;
in {
  options = {
    myFlake.nixos.hardware.components.gpu.nvidia.enable = lib.mkEnableOption "Whether to enable NVIDIA GPU.";
    myFlake.nixos.hardware.components.gpu.nvidia.prime = lib.mkEnableOption "Whether to enable NVIDIA Prime.";
  };

  # https://nixos.wiki/wiki/Nvidia
  config = lib.mkIf cfg.enable {
    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"];

    nixpkgs.config.nvidia.acceptLicense = true;
    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
      modesetting.enable = true;
    };

    # cfg.prime
    hardware.nvidia.prime = lib.mkIf cfg.prime {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      #sync.enable = true;
      #reverseSync.enable = true;

      ### Device specific, please put those configuration in `machines/your-machine.nix`
      # nvidiaBusId = "PCI:1:0:0";
      # intelBusId = "PCI:0:2:0";
    };

    environment.sessionVariables = {
      "GAMEMODERUNEXEC" = lib.mkIf (config.hardware.nvidia.prime.offload.enable || config.programs.gamemode.enable) "nvidia-offload"; # gamemode: nvidia offload
    };
  };
}
