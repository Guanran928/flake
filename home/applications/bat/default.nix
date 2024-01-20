{
  programs.bat.enable = true;
  home.sessionVariables = {
    "PAGER" = "bat";
    "MANPAGER" = "sh -c 'col -bx | bat -l man -p'";
    "MANROFFOPT" = "-c";
  };
}
