# nix{os,-darwin} config

It just works™

## Structure

```
 .
│   # Darwin configuration is not actively maintained and sometimes it might
│   # break.
├── 󱂵 home # <-- See here for dotfiles!
├──  darwin
├──  nixos
│  ├──  modules
│  └──  profiles
│
│   # Internal packages, please see github:Guanran928/nur-packages instead
├──  pkgs
├──  hosts
├──  overlays
│
├──  flake.nix
├──  flake.lock
│
└──  README.md
```
