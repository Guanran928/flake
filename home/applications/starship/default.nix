{ pkgs, ... }:
{
  programs.starship = {
    enable = true;
  };

  home.sessionVariables = {
    "STARSHIP_CONFIG" = "${pkgs.starship}/share/starship/presets/nerd-font-symbols.toml";
  };
}
