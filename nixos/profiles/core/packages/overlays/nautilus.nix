{addPatches, ...}: _final: prev: {
  gnome =
    prev.gnome
    // {
      nautilus = addPatches prev.gnome.nautilus [
        # Restore Nautilus's typeahead ability
        # https://aur.archlinux.org/packages/nautilus-typeahead
        (prev.fetchpatch {
          url = let
            repo = "nautilus-typeahead";
            file = "nautilus-restore-typeahead.patch";
            commit = "6f75fbb04f6b108324850a0956f4bbdff0b6060b";
          in "https://aur.archlinux.org/cgit/aur.git/plain/${file}?h=${repo}&id=${commit}";
          hash = "sha256-a40vNo2Nw068GBtjVPUz6WAYRtjD0DB2bG/N14vSTxI=";
        })
      ];
    };
}
