{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./components/dunst.nix
    ./components/rofi.nix
    ./components/swayidle.nix
    ./components/swaylock.nix
    ./components/swww.nix
    ./components/udiskie.nix
    ./components/waybar.nix
  ];

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
    source = ../dotfiles/config/hyprland;
    recursive = true;
  };
}
