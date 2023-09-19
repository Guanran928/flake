{ ... }:

{
  programs.xwayland.enable = true;
  hardware.nvidia.nvidiaSettings = false; # nvidia settings menu, wont do anything on wayland
  environment.sessionVariables = {
    "NIXOS_OZONE_WL" = "1"; # let electron applications use wayland
  };
}