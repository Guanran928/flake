_: {
  programs.bat.enable = true;
  home.sessionVariables = {
    "MANPAGER" = "sh -c 'col -bx | bat -l man -p'";
    "MANROFFOPT" = "-c";
  };
}
