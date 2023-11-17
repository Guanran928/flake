final: prev: {
  sway-unwrapped = prev.sway-unwrapped.overrideAttrs (old: {
    # Add input panel to sway
    # .patch file from https://github.com/swaywm/sway/pull/7226
    patches =
      (old.patches or [])
      ++ [
        (prev.fetchurl {
          url = "https://github.com/swaywm/sway/commit/d1c6e44886d1047b3aa6ff6aaac383eadd72f36a.patch";
          sha256 = "sha256-UnNnAgXVBPjhF7ytVpGEStbJK1RQuRIci5PgGEvLp80=";
        })
      ];
  });
}
