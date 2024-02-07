{
  programs.atuin = {
    enable = true;
    flags = ["--disable-up-arrow"];
    settings = {
      style = "compact";

      stats = {
        common_subcommands =
          ["nix" "nom" "nh" "podman" "docker" "atuin" "hugo" "adb"]
          # default
          ++ ["cargo" "go" "git" "npm" "yarn" "pnpm" "kubectl"];

        common_prefix =
          ["env"]
          # default
          ++ ["sudo"];
      };
    };
  };
}
