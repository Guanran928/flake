{ ... }:

{
  nixpkgs = {
    overlays = [
      (final: prev:
        {
          gnome = prev.gnome // {
            # Restore Nautilus's typeahead ability
            # .patch file from from aur/nautilus-typeahead
            nautilus = prev.gnome.nautilus.overrideAttrs (old: {
              patches = (old.patches or []) ++ [
                (prev.fetchpatch {
                  url = "https://aur.archlinux.org/cgit/aur.git/plain/nautilus-restore-typeahead.patch?h=nautilus-typeahead";
                  hash = "sha256-a40vNo2Nw068GBtjVPUz6WAYRtjD0DB2bG/N14vSTxI=";
                })
              ];
            });
          };
        }
      )
    ];
  };
}