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

    # Tray D-Bus Menu
    # https://github.com/swaywm/sway/pull/6249
    (prev.fetchpatch {
      name = "0001-Tray-Implement-dbusmenu.patch";
      url = "https://github.com/NickHu/sway/commit/0fc5d7aed84415a77b718ca9dc3c0b3ad2c05b02.patch";
      hash = "sha256-1KuGZGwyGJK8KO4OngS+tWKV/3Yu++bCNnp+xTrlGoY=";
    })
    (prev.fetchpatch {
      name = "0002-Tray-dont-invoke-dbus-menu-when-tray-is-disabled.patch";
      url = "https://github.com/NickHu/sway/commit/03c14421354e54332e12f78d029dcaa9919fd161.patch";
      hash = "sha256-GhBlCnk7aB6s57wV1FNOPAt6s0oJxLgf2bMw+8ktn8A";
    })
  ];
}
