final: prev: {
  firefox-unwrapped = prev.firefox-unwrapped.overrideAttrs (old: {
    # Firefox but with .mozilla moved to .config/mozilla
    # .patch file from aur/firefox-xdg
    # dont actually use this, it take ages to build... =.=
    patches =
      (old.patches or [])
      ++ [
        (prev.fetchgit {
            url = "https://aur.archlinux.org/firefox-xdg.git";
            rev = "ab291ab81140867dea4c08e4e1e4e3da0c73e4a6";
            hash = "sha256-6VgCt028qs/Y5kl20qLUYwFI63pItsHPbLimOFIdsyo=";
            sparseCheckout = [
              "firefox-xdg-support.diff"
            ];
          }
          + "/firefox-xdg-support.diff")
      ];
  });
}
