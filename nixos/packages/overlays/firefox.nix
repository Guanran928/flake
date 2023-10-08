
{ ... }:

{
  nixpkgs = {
    overlays = [
      (final: prev:
        {
            firefox-unwrapped = prev.firefox-unwrapped.overrideAttrs (old: {
            # Firefox but with .mozilla moved to .config/mozilla
            # .patch file from aur/firefox-xdg
            # dont actually use this, =.=
            patches = (old.patches or []) ++ [
              (prev.fetchpatch {
                url = "https://aur.archlinux.org/cgit/aur.git/plain/firefox-xdg-support.diff?h=firefox-xdg";
                hash = "sha256-9LibQ+dIZ7MeTcuKEuJ42AW8m7Q7mVBwT4KyGeJTJ88=";
              })
            ];
          });
        }
      )
    ];
  };
}