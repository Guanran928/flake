{ pkgs, config, ... }:
{
  home.packages = [ pkgs.python3 ];

  # stolen from nickcao's flake
  home.sessionVariables.PYTHON_HISTORY = "${config.xdg.stateHome}/python_history";
}
