{addPatches, ...}: _final: prev: {
  sway-unwrapped = addPatches prev.sway-unwrapped [
    # text_input: Implement input-method popups
    # https://github.com/swaywm/sway/pull/7226
    (prev.fetchpatch {
      url = "https://github.com/swaywm/sway/commit/d1c6e44886d1047b3aa6ff6aaac383eadd72f36a.patch";
      hash = "sha256-LsCoK60FKp3d8qopGtrbCFXofxHT+kOv1e1PiLSyvsA=";
    })
  ];
}
