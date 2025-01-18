{ lib, pkgs, ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main.font = "monospace:size=10";
      main.resize-by-cells = false;
      main.shell = "${lib.getExe pkgs.tmux} new-session -t main";
      cursor.style = "beam";
      url.label-letters = "aoeuhtns";
    } // import ./tokyonight_night.nix;
  };
}
