{ pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  #environment.systemPackages = with pkgs; [
  #  neovim
  #  vscode
  #];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  programs.fish.enable = true;

  services = {
    yabai = {
      enable = true;
      enableScriptingAddition = true;
      config = {
        layout         = "bsp";
        mouse_modifier = "fn";

        # very broken on slow cpu
        #focus_follows_mouse = "autoraise";
        #mouse_follows_focus = "on";

        top_padding    = 10;
        bottom_padding = 10;
        left_padding   = 10;
        right_padding  = 10;
        window_gap     = 4;
      };
    };
    skhd = {
      enable = true;
      skhdConfig = ''
        cmd - return : open -n ${pkgs.alacritty}/Applications/Alacritty.app

        cmd - 1 : yabai -m space --focus 1             # Focus space
        cmd - 2 : yabai -m space --focus 2
        cmd - 3 : yabai -m space --focus 3
        cmd - 4 : yabai -m space --focus 4
        cmd - 5 : yabai -m space --focus 5

        shift + cmd - 1 : yabai -m window --space 1    # Send to space
        shift + cmd - 2 : yabai -m window --space 2
        shift + cmd - 3 : yabai -m window --space 3
        shift + cmd - 4 : yabai -m window --space 4
        shift + cmd - 5 : yabai -m window --space 5
      '';
    };
  };
}