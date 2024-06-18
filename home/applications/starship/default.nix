{
  pkgs,
  lib,
  ...
}: {
  programs.starship = {
    enable = true;
    # FIXME: IFD
    settings = lib.importTOML "${pkgs.starship}/share/starship/presets/nerd-font-symbols.toml";
  };
}
