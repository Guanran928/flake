_final: prev: {
  mautrix-telegram = prev.mautrix-telegram.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [
      (prev.fetchpatch2 {
        url = "https://github.com/mautrix/telegram/commit/0c2764e3194fb4b029598c575945060019bad236.patch";
        hash = "sha256-48QiKByX/XKDoaLPTbsi4rrlu9GwZM26/GoJ12RA2qE=";
      })
    ];
  });
}
