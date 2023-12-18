{pkgs, ...}: {
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # let electron applications use wayland
  };

  home.packages = with pkgs; [
    wl-clipboard
  ];
}
