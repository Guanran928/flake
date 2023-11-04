{...}: {
  nixpkgs = {
    overlays = [
      (
        final: prev: {
          ydict = prev.ydict.overrideAttrs (old: {
            # Let ydict follow XDG
            # .patch file from https://github.com/TimothyYe/ydict/pull/32
            # yes i know theres `YDICT_DB`
            patches =
              (old.patches or [])
              ++ [
                (prev.fetchurl {
                  url = "https://github.com/TimothyYe/ydict/commit/5bb0bc3f44922893a17993e295bbcac82c4a0170.patch";
                  sha256 = "sha256-Wg7p7dzosbbghSOTDB7duLL4ecmMjQd5trNXqHh29cU=";
                })
              ];
          });
        }
      )
    ];
  };
}
