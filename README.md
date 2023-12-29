# nix{os,-darwin} config

It just works™

## Structure

```
 .
│   ### System configuration
│   # Darwin configuration is not actively maintained and sometimes it might break.
├──  darwin
├──  nixos
│  ├──  hosts
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

Please don't.

### NixOS:

1. Clone this repository

   `$ git clone https://github.com/Guanran928/flake.git`

2. Add your device's hardware configuration in `./flake.nix` and `./nixos/hosts/<hostname>`

3. Install NixOS

   `$ nixos-install --flake <this flake's directory>#<hostname>`
