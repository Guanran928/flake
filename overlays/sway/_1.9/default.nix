{addPatches, ...}: _final: prev: {
  sway-unwrapped = addPatches prev.sway-unwrapped [
    # text_input: Implement input-method popups
    # https://github.com/swaywm/sway/pull/7226
    (prev.fetchpatch rec {
      name = "0001-text_input-Implement-input-method-popups.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/${name}?h=sway-im&id=b8434b3ad9e8c6946dbf7b14b0f7ef5679452b94";
      hash = "sha256-A+rBaWMWs616WllVoo21AJaf9lxg/oCG0b9tHLfuJII=";
    })
    (prev.fetchpatch rec {
      name = "0002-chore-fractal-scale-handle.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/${name}?h=sway-im&id=b8434b3ad9e8c6946dbf7b14b0f7ef5679452b94";
      hash = "sha256-YOFm0A4uuRSuiwnvF9xbp8Wl7oGicFGnq61vLegqJ0E=";
    })
    (prev.fetchpatch rec {
      name = "0003-chore-left_pt-on-method-popup.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/${name}?h=sway-im&id=b8434b3ad9e8c6946dbf7b14b0f7ef5679452b94";
      hash = "sha256-PzhQBRpyB1WhErn05UBtBfaDW5bxnQLRKWu8jy7dEiM=";
    })

    # (rebased) Tray D-Bus Menu
    # https://github.com/swaywm/sway/pull/6249
    ./0001-Tray-Implement-dbusmenu.patch
  ];
}
