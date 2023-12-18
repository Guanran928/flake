{
  #inputs,
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
