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
  ];

  home.sessionVariables."EDITOR" = "nvim";
}
