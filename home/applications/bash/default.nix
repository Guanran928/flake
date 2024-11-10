{ config, ... }:
{
  home.sessionVariables.HISTFILE = "${config.xdg.stateHome}/bash_history";
}
