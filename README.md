# nix{os,-darwin} config
It just works™


## Infomation
- Flakes: Yes
- Home Manager: Yes

### Machine-specific
- File system: Btrfs
- System encryption: Yes (LUKS)

### User-specific
- Secrets: sops-nix
- Display server: Wayland
- Desktop-environment: Sway

## Structure
```
 .
├──  darwin                          # System configuration
├──  nixos
│
├──  flakes                          # Import-able Flakes
│  ├──  darwin
│  └──  nixos
│
├──  machines                        # Hardware configuration
│  ├──  darwin
│  └──  nixos
│     ├──  81fw-lenovo-legion-y7000  ### Model
│     │  ├──  hardware.nix           #### Model-specific hardware configuration
│     │  └──  machine-1              #### Machine-specific hardware configuration
│     │
│     └───  hardware                 ### Reusable hardware configuration
│        ├──  cpu
│        ├──  gpu
│        └──  ...
│
├──  users
│  └──  guanranwang                  ## Your user
│     │
│     ├──  darwin                    ### (User-specific) System configuration
│     ├──  nixos
│     │
│     ├──  home-manager              ### (User-specific) Home Manager configuration
│     │  ├──  darwin
│     │  └──  nixos
│     │
│     └──  secrets                   ### User's secrets managed through sops-nix
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
    Add your device's hardware configuration in `./machines` and `./flake.nix`

  3.
    Install NixOS
    `$ nixos-install --flake <this flake's directory>#<hostname>`
