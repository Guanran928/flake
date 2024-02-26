# nix{os,-darwin} config

It just works™

## Structure

Any directory or file that is prefixed with an `_` (underscore) means that the
whole directory/file is unused in this repository.

```
 .
│   # Darwin configuration is not actively maintained and sometimes it might
│   # break.
├── 󱂵 home
├──  darwin
├──  nixos
│  ├──  modules
│  └──  profiles
│
├──  hosts
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

2. Add your device's hardware configuration in `./flake.nix` and
   `./hosts/<hostname>`

3. Install NixOS

   `$ nixos-install --flake <this flake's directory>#<hostname>`

### macOS:

1. Install Nix using [`Determinate Nix Installer`](https://github.com/DeterminateSystems/nix-installer)

   `$ curl --proto '=https' --tlsv1.2 -fsSL https://install.determinate.systems/nix | sh -s -- install`

2. Clone this repository

   `$ git clone https://github.com/Guanran928/flake.git`

3. Add your device's hardware configuration in `./flake.nix` and
   `./hosts/<hostname>`

4. Install [`nix-darwin`](https://github.com/LnL7/nix-darwin?tab=readme-ov-file#flakes)

   `$ nix run nix-darwin -- switch --flake <this flake's directory>#<hostname>`
