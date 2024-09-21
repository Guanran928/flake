{ config, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*.ny4.dev" = {
        identityFile = "${config.home.homeDirectory}/.ssh/id_github_signing";
        user = "root";
      };
      "pek0.ny4.dev".hostname = "blacksteel";
    };
  };
}
