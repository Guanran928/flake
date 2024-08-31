{ config, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks =
      let
        inherit (config.home) homeDirectory;
        serverConfig = {
          identityFile = "${homeDirectory}/.ssh/id_github_signing";
          user = "root";
        };
      in
      {
        "tyo0.ny4.dev" = serverConfig;
        "pek0.ny4.dev" = serverConfig // {
          hostname = "blacksteel";
        };
      };
  };
}
