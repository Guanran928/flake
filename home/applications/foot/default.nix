{ lib, config, ... }:
{
  programs.foot = {
    enable = true;
    settings = lib.recursiveUpdate {
      main.font = "monospace:size=10";
      main.resize-by-cells = false;
      cursor.style = "beam";
      url.label-letters = "aoeuhtns";
    } (import ./tokyonight_night.nix);
  };

  home.sessionVariables."TERMINAL" = config.programs.foot.package;
}
