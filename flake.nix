{
  description = "Guanran928's Flake";

  inputs = {
    # Flake inputs
    ## Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";

    ## Flakes
    berberman = {
      url = "github:berberman/flakes";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nvfetcher.follows = "nvfetcher";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprland-protocols.follows = "hyprland-protocols";
      inputs.systems.follows = "systems";
      inputs.wlroots.follows = "wlroots";
      inputs.xdph.follows = "xdph";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    impermanence.url = "github:nix-community/impermanence";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.crane.follows = "crane";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pre-commit-hooks-nix.follows = "pre-commit-hooks-nix";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    ### De-dupe
    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-protocols = {
      url = "github:hyprwm/hyprland-protocols";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
    };
    pre-commit-hooks-nix = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.gitignore.follows = "gitignore";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    systems.url = "github:nix-systems/default-linux";
    wlroots = {
      type = "gitlab";
      host = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      flake = false;
    };
    xdph = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprland-protocols.follows = "hyprland-protocols";
      inputs.systems.follows = "systems";
    };

    # TODO: Unused, Soon(TM)
    #daeuniverse.url = "github:daeuniverse/flake.nix";
    #nixos-hardware = {
    #  url = "github:NixOS/nixos-hardware/master";
    #  #inputs.nixpkgs.follows = "nixpkgs";
    #};
    #nixpak = {
    #  url = "github:nixpak/nixpak";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    ## Non-Flake
    ### Color scheme files
    tokyonight = {
      # TODO: base16.nix/Stylix when?
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };
    ### Clash WebUI
    metacubexd = {
      url = "github:MetaCubeX/metacubexd/gh-pages";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    berberman,
    disko,
    home-manager,
    hosts,
    hyprland,
    lanzaboote,
    nix-darwin,
    sops-nix,
    impermanence,
    tokyonight,
    metacubexd,
    ...
  } @ inputs: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    ### NixOS
    nixosConfigurations = {
      "81FW-NixOS" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          # OS
          ./nixos/presets/desktop.nix
          ./nixos/presets/core/zram-generator.nix
          ./nixos/presets/core/boot/no-bootloader-menu.nix
          ./nixos/presets/core/networking/alidns.nix
          ./nixos/presets/desktop/gaming.nix
          ./nixos/presets/desktop/virtualbox.nix
          ./nixos/presets/desktop/wayland.nix

          # User
          ./users/guanranwang/nixos/presets/desktop.nix
          ./users/guanranwang/nixos/presets/core/clash-meta-client.nix

          # Hardware
          ./machines/nixos/81fw-lenovo-legion-y7000
          ./machines/nixos/81fw-lenovo-legion-y7000/machine-1

          {
            # extra home-manager stuff
            home-manager.users.guanranwang = import ./users/guanranwang/home-manager/nixos/presets/desktop/gaming.nix;

            networking.hostName = "81FW-NixOS"; # Hostname
            time.timeZone = "Asia/Shanghai"; # Timezone
          }
        ];
      };
    };

    ### nix-darwin (macOS)
    darwinConfigurations = {
      "iMac-macOS" = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        specialArgs = {inherit inputs;};
        modules = [
          ./darwin/presets/desktop.nix
          ./users/guanranwang/darwin/presets/desktop.nix
          ./users/guanranwang/darwin/presets/core/proxy.nix
          ./machines/darwin/imac-2017

          {
            #home-manager.users.guanranwang = import ./users/guanranwang/home-manager/darwin/presets/desktop/gaming.nix;

            networking.hostName = "iMac-macOS";
            time.timeZone = "Asia/Shanghai";
          }
        ];
      };
    };

    ### Home-Manager
    # TODO: Actually figure out how this works
    homeConfigurations = {
      "guanranwang@81fw-nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs;};
        modules = [
          sops-nix.homeManagerModules.sops
          hyprland.homeManagerModules.default
        ];
      };
    };
  };
}
