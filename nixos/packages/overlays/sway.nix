{ ... }:

{
  nixpkgs = {
    overlays = [
      (final: prev:
        {
          sway-unwrapped = prev.sway-unwrapped.overrideAttrs (old: {
            # Add input panel to sway
            # .patch file from some random guy's dotfile repo
            patches = (old.patches or []) ++ [
              # attempt #1, didnt work
              #(prev.fetchpatch {
              #  url = "https://aur.archlinux.org/cgit/aur.git/plain/7226.patch?h=sway-im-git";
              #  hash = "sha256-KPWsxDQ2Zkya6o+llQVRHeulecDPsZAJ2vyQNWZKAps=";
              #})

              # attempt #2, also didnt work
              #(prev.fetchpatch {
              #  url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-text_input-Implement-input-method-popups.patch?h=sway-im";
              #  hash = "sha256-xrBnQhtA6LgyW0e0wKwymlMvx/JfrjBidq1a3GFKzZo=";
              #})

              # attempt #3, worked, very buggy
              (prev.fetchpatch {
                url = "https://raw.githubusercontent.com/slaier/nixos-config/main/modules/sway/0001-text_input-Implement-input-method-popups.patch";
                hash = "sha256-f3xI2Pz3rfF2aBfZlC/4wMF/UphKcEVHSCZ1/23AndQ=";
              })
            ];
          });
        }
      )
    ];
  };
}