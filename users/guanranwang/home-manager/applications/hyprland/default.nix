{
  #inputs,
  lib,
  ...
}: {
  imports = [
    ../common/wayland.nix
    ../common/wm.nix
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
  };

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    #plugins = with inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}; [
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
