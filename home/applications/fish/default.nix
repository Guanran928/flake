{ lib, pkgs, ... }:
{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting

      set fish_cursor_default     block
      set fish_cursor_insert      line
      set fish_cursor_replace_one underscore
      set fish_cursor_replace     underscore
      set fish_cursor_external    line
      set fish_cursor_visual      block

      function fish_user_key_bindings
        fish_default_key_bindings -M insert
        fish_vi_key_bindings --no-erase insert
      end
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
