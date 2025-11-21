{ pkgs, ... }:
{
  programs.waybar.enable = true;

  xdg.configFile."waybar/config.jsonc" = {
    source = ./config.jsonc;
    onChange = ''
      ${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true
    '';
  };

  xdg.configFile."waybar/style.css" = {
    source = ./style.css;
    onChange = ''
      ${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true
    '';
  };

  systemd.user.services.waybar.Unit.X-Reload-Triggers = [
    ./config.jsonc
    ./style.css
  ];
}
