{
  addPatches,
  prev,
  ...
}: {
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
            commit = "524d92c42ea768e5e4ab965511287152ed885d22"; # v45.2.1
          in "https://aur.archlinux.org/cgit/aur.git/plain/${file}?h=${repo}&id=${commit}";
          hash = "sha256-a40vNo2Nw068GBtjVPUz6WAYRtjD0DB2bG/N14vSTxI=";
        })
      ];
    };
}
