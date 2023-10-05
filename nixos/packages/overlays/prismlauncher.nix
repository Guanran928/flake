{ ... }:

{
  nixpkgs = {
    overlays = [
      (final: prev:
        {
          prismlauncher = prev.prismlauncher.overrideAttrs (old: {
            # Offline mode for Prism Launcher
            # .patch file from some Misterio77's nix-config repo
            patches = (old.patches or []) ++ [
              (prev.fetchpatch {
                url = "https://raw.githubusercontent.com/Misterio77/nix-config/main/overlays/offline-mode-prism-launcher.diff";
                hash = "sha256-vMcAvhD0Ms4Tvwpzs/YfORc8ki7MNMurdJJ/yswfxFM=";
              })
            ];
          });
        }
      )
    ];
  };
}