{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile."waybar/config.jsonc" = {
    source = ./config.jsonc;
    onChange = ''
      ${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true
    '';
  };

  xdg.configFile."waybar/style.css" = {
    text = import ./style.css.nix;
    onChange = ''
      ${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true
    '';
  };
}
