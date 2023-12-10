# nix{os,-darwin} config
It just works™


## Infomation
- Flakes: Yes
- Home Manager: Yes

### Machine-specific (Aristotle)
- File system: Btrfs
- System encryption: Yes (LUKS)

### User-specific (me)
- Secrets: sops-nix
- Display server: Wayland
- Desktop-environment: Sway

## Structure
```
 .
│   ### System configuration
├──  darwin
├──  nixos
│  ├──  hardware
│  ├──  modules
│  └──  profiles
│
│   ### User configuration
│   # Adds user account, home-manager stuff, etc.
│   # Do whatever you want here.
├──  users
│  ├──  guanranwang
│  ├──  foo
│  └──  bar
│
├──  flake.nix
├──  flake.lock
│
└──  README.md
```
## Installation:

  ~~Please don't.~~

  1.
    Clone this repository
    `$ git clone https://github.com/Guanran928/flake.git`

  2.
    Add your device's hardware configuration in `./ (nixos/darwin) /hardware` and `./flake.nix`

  3.
    Install NixOS
    `$ nixos-install --flake <this flake's directory>#<hostname>`
