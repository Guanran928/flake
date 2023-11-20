{...}: {
  programs.xwayland.enable = true; # enable XWayland
  hardware.nvidia.nvidiaSettings = false; # NVIDIA settings menu, wont do anything on wayland
  environment.sessionVariables = {
    "NIXOS_OZONE_WL" = "1"; # let electron applications use wayland
  };
}
