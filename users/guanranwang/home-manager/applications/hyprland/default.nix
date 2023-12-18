{
  #inputs,
  lib,
  ...
}: {
  imports = [
    ../cliphist
    ../dunst
    ../rofi
    ../swayidle
    ../swaylock
    ../swww
    ../udiskie
    ../waybar
  ];

  home.sessionVariables = {
    QT_IM_MODULE = lib.mkForce "wayland"; # use text-input-v2
    GTK_IM_MODULE = lib.mkForce "wayland"; # use text-input-v3
    NIXOS_OZONE_WL = "1"; # let electron applications use wayland
  };

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    #plugins = with inputs.hyprland-plugins.packages.${pkgs.system}; [
    #  csgo-vulkan-fix
    #];

    extraConfig = ''
      source = ~/.config/hypr/main.conf
      source = ~/.config/hypr/keybinds.conf
      source = ~/.config/hypr/autostart.conf
    '';
  };

  xdg.configFile."hypr" = {
    source = ./hypr;
    recursive = true;
  };
}
