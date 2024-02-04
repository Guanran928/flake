{pkgs, ...}:
with pkgs; let
  # trimmed down version of writeShellApplication
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/trivial-builders/default.nix#L245
  #
  # it wont work if i change writeTextFile to writeScriptBin... unsure why
  # error: A definition for option ... is not of type `package'. Definition values:
  # - In `/nix/store/<hash>-source/nixos/profiles/common/graphical/home/scripts': <function>
  makeScript = {
    name,
    file,
    runtimeInputs ? [],
  }:
    writeTextFile {
      inherit name;
      executable = true;
      destination = "/bin/${name}";
      text = lib.concatStringsSep "\n" [
        "#!${runtimeShell}"
        (lib.optionalString (runtimeInputs != []) ''export PATH="${lib.makeBinPath runtimeInputs}:$PATH"'')
        (builtins.readFile file)
      ];
    };
in {
  home.packages = [
    (makeScript {
      name = "lofi";
      runtimeInputs = [mpv];
      file = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/lime-desu/bin/69422c37582c5914863997c75c268791a0de136e/lofi";
        hash = "sha256-hT+S/rqOHUYnnFcSDFfQht4l1DGasz1L3wDHKUWLraA=";
      };
    })

    (makeScript {
      name = "screenshot";
      runtimeInputs = [coreutils jq grim slurp swappy wl-clipboard libnotify];
      file = pkgs.substitute {
        src = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/nwg-piotr/nwg-shell/c29e8eb4658a2613fb221ead0b101c75f457bcaf/scripts/screenshot";
          hash = "sha256-Z/fWloz8pLHsvPTPOeBxnbMsGDRTY3G3l/uePQ3ZxjU=";
        };
        replacements = ["--replace-warn" "DIR=\${SCREENSHOT_DIR:=$HOME/Screenshots}" "DIR=$HOME/Pictures/Screenshots"]; # i dont like using an environment variable
      };
    })
  ];
}
