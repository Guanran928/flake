{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [ pkgs.neovim ];
  home.sessionVariables."EDITOR" = "nvim";
  xdg.configFile."nvim".source = inputs.neovim;
}
