{
  #inputs,
  pkgs,
  ...
}: {
  imports = [
    ../dunst
    ../rofi
    ../swayidle
    ../swaylock
    ../swww
    ../udiskie
    ../waybar
  ];

  home.packages = with pkgs; [swww];

  wayland.windowManager = {
    hyprland = {
      enable = true;
      enableNvidiaPatches = true;
      xwayland.enable = true;
      plugins = [
        #inputs.hyprland-plugins.packages.${pkgs.system}.csgo-vulkan-fix
      ];

      extraConfig = ''
        #source = ~/.config/hypr/themes/mocha.conf
        #source = ~/.config/hypr/themes/colors.conf
        #source = ~/.config/hypr/plugins.conf
        source = ~/.config/hypr/main.conf
        source = ~/.config/hypr/keybinds.conf
        source = ~/.config/hypr/autostart.conf
        source = ~/.config/hypr/env.conf
      '';
    };
  };

  xdg.configFile."hypr" = {
    source = ./hyprland;
    recursive = true;
  };
}
