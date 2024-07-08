{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = map (n: ../../../../home/applications/${n}) [
    "go"
    # "mpv"
    "nix"
  ];

  # Install MacOS applications to the user Applications folder. Also update Docked applications
  # Modified version of: https://github.com/nix-community/home-manager/issues/1341#issuecomment-1870352014
  home.file."Applications/Home Manager Apps".enable = false;
  home.activation.trampolineApps = let
    apps = pkgs.buildEnv {
      name = "home-manager-applications";
      paths = config.home.packages;
      pathsToLink = "/Applications";
    };
  in
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${builtins.readFile ./trampoline-apps.sh}
      fromDir="${apps}/Applications"
      toDir="$HOME/Applications/Home Manager Trampolines"
      sync_trampolines "$fromDir" "$toDir"
    '';
  home.extraActivationPath = with pkgs; [
    rsync
    dockutil
    gawk
  ];
}
