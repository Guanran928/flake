{ lib, pkgs, ... }:
{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting
    '';

    plugins = [
      {
        name = "autopair";
        inherit (pkgs.fishPlugins.autopair) src;
      }
      {
        name = "done";
        inherit (pkgs.fishPlugins.done) src;
      }
      {
        name = "puffer";
        inherit (pkgs.fishPlugins.puffer) src;
      }
    ];

    shellAbbrs = {
      g = "git";
      n = "nvim";
      gi = "gitui";
      sy = "systemctl";
    };

    functions =
      let
        jq = lib.getExe pkgs.jq;
        nix = lib.getExe pkgs.nix;
        curl = lib.getExe pkgs.curl;
      in
      {
        "pb" = ''
          ${jq} -Rns '{text: inputs}' | \
            ${curl} -s -H 'Content-Type: application/json' --data-binary @- https://pb.ny4.dev | \
            ${jq} -r '. | "https://pb.ny4.dev\(.path)"'
        '';

        "getmnter" = ''
          ${nix} eval nixpkgs#{$argv}.meta.maintainers --json | \
            ${jq} '.[].github | "@" + .' -r
        '';
      };
  };
}
