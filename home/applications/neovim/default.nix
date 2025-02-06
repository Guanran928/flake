{ inputs, ... }:
{
  xdg.configFile."nvim" = {
    source = inputs.neovim;
    recursive = true;
  };
}
