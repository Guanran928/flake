{ pkgs, ... }:
{
  home.packages = [ pkgs.python3 ];

  # stolen from nickcao's flake
  home.sessionVariables.PYTHONSTARTUP =
    (pkgs.writeText "start.py" ''
      import readline
      readline.write_history_file = lambda *args: None
    '').outPath;
}
