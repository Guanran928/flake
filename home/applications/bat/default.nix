{ pkgs, ... }:
{
  home.packages = [ pkgs.bat ];
  home.sessionVariables = {
    "MANPAGER" = "sh -c 'col -bx | bat -l man -p'";
    "MANROFFOPT" = "-c";
  };
}
