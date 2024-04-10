{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    (inputs.neovim.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      viAlias = true;
      vimAlias = true;
    })
    #pkgs.lunarvim
  ];

  home.sessionVariables."EDITOR" = "nvim";

  # TODO: still couldn't make it work
  #programs.neovim = {
  #  enable = true;
  #  viAlias = true;
  #  vimAlias = true;
  #
  #  package = inputs.neovim.packages.${pkgs.stdenv.hostPlatform.system}.default;
  #};
}
