{pkgs, ...}: {
  home.packages = [pkgs.ydict];
  home.shellAliases = {
    "yd" = "ydict -c";
  };
}
