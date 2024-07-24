{config, ...}: {
  programs.ssh = {
    enable = true;
    matchBlocks = let
      inherit (config.home) homeDirectory;
    in {
      "blacksteel".identityFile = "${homeDirectory}/.ssh/id_github_signing";
      "tyo0.ny4.dev".identityFile = "${homeDirectory}/.ssh/id_github_signing";
    };
  };
}
