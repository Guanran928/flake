{ lib, pkgs, ... }:
{
  programs.fish = {
    enable = true;

    interactiveShellInit =
      # fish
      ''
        set fish_greeting
      '';

    shellInit =
      let
        tide = pkgs.fishPlugins.tide.src + "/functions/tide/configure";
      in
      # fish
      ''
        string replace -r '^' 'set -g ' < ${tide}/icons.fish | source
        string replace -r '^' 'set -g ' < ${tide}/configs/lean.fish | source
        string replace -r '^' 'set -g ' < ${tide}/configs/lean_16color.fish | source
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
            tide
          ]
        );

    shellAliases = {
      ls = "eza --icons";
    };

    shellAbbrs =
      let
        cursor = f: {
          setCursor = true;
          expansion = f;
        };
      in
      {
        gi = "lazygit";
        s = "nh os switch";
        v = "nvim";
        yd = "rdict";

        n = "nix";
        nb = cursor "nix build nixpkgs#%";
        nr = cursor "nix run nixpkgs#%";
        ns = cursor "nix shell nixpkgs#%";
        nbb = "nix-build -A";
        nf = "nix fmt";
        nu = "nix flake update";
        nv = "nix eval";
      };

    functions.pb =
      let
        jq = lib.getExe pkgs.jq;
        curl = lib.getExe pkgs.curl;
      in
      # fish
      ''
        ${jq} -Rns '{text: inputs}' | \
          ${curl} -s -H 'Content-Type: application/json' --data-binary @- https://pb.ny4.dev | \
          ${jq} -r '. | "https://pb.ny4.dev\(.path)"'
      '';
  };
}
