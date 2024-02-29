{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.neovim.packages.${pkgs.stdenv.hostPlatform.system}.default
    #pkgs.lunarvim

    # stupid way to make {vi,vim}Alias work without a module
    (pkgs.writeShellScriptBin "vi" ''nvim "$@"'')
    (pkgs.writeShellScriptBin "vim" ''nvim "$@"'')
  ];

  home.sessionVariables."EDITOR" = "nvim";

  # TODO: couldn't make it work
  #programs.neovim = {
  #  enable = true;
  #  viAlias = true;
  #  vimAlias = true;
  #
  #  package = inputs.neovim.packages.${pkgs.stdenv.hostPlatform.system}.default;
  #};
}
