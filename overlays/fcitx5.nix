{
  addPatches,
  prev,
  ...
}: {
  fcitx5 = addPatches prev.fcitx5 [
    # Breaks typing in Firefox and some GTK apps
    (prev.fetchpatch {
      url = "https://github.com/fcitx/fcitx5/commit/b2924bd361680c493463d240a375b3f0948ae48d.patch";
      hash = "sha256-FMbYu1yYDHQ8ndr6Fa/qLL1EIKSTQJwc1YuUiEDiJjc=";
      revert = true;
    })
  ];
}
