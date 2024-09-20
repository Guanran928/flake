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

    plugins =
      lib.map
        (f: {
          name = f.pname;
          inherit (f) src;
        })
        (
          with pkgs.fishPlugins;
          [
            autopair
            done
            puffer
          ]
        );

    shellAbbrs =
      let
        cursor = f: {
          setCursor = true;
          expansion = f;
        };
      in
      {
        gi = "gitui";
        p = "powerprofilesctl";
        s = "nh os switch";
        v = "nvim";

        # TODO: maybe fishPlugins.fish-git-abbr?
        g = "git";
        ga = "git add";
        gac = cursor "git commit -am '%'";
        gc = cursor "git commit -m '%'";
        gca = "git commit --amend";
        gd = "git diff";
        gds = "git diff --staged";
        gl = "git log";
        gp = "git pull";
        gpu = "git push";
        gr = "git rebase -i --autosquash";

        n = "nix";
        nb = cursor "nix build nixpkgs#%";
        nr = cursor "nix run nixpkgs#%";
        ns = cursor "nix shell nixpkgs#%";
        nbb = "nix-build -A";
        nf = "nix fmt";
        nu = "nix flake update";
        nv = "nix eval";
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
