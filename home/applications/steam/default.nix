{pkgs, ...}: {
  home.packages = [
    pkgs.steam

    # with ProtonGE
    # (pkgs.steam.override {
    #   extraProfile = "export STEAM_EXTRA_COMPAT_TOOLS_PATHS='${inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.proton-ge}'";
    # })
  ];
}
