{
  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      style = "compact";
      show_help = false;
      stats.common_subcommands = [
        "nix"
        "nom"
        "nh"
        "podman"
        "docker"
        "atuin"
        "hugo"
        "adb"
        # default
        "cargo"
        "go"
        "git"
        "npm"
        "yarn"
        "pnpm"
        "kubectl"
      ];
    };
  };
}
