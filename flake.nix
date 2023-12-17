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
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprland-protocols.follows = "hyprland-protocols";
      inputs.systems.follows = "systems-linux";
      inputs.wlroots.follows = "wlroots";
      inputs.xdph.follows = "xdph";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
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
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.hercules-ci-effects.follows = "hercules-ci-effects";
    };
    nixpak-pkgs = {
      url = "github:nixpak/pkgs";
      inputs.nixpak.follows = "nixpak";
      inputs.flake-parts.follows = "flake-parts";
      inputs.hercules-ci-effects.follows = "hercules-ci-effects";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    systems.url = "github:nix-systems/default";
    systems-linux.url = "github:nix-systems/default-linux";

    ### De-dupe
    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hercules-ci-effects = {
      url = "github:hercules-ci/hercules-ci-effects";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    hyprland-protocols = {
      url = "github:hyprwm/hyprland-protocols";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems-linux";
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
      inputs.systems.follows = "systems-linux";
    };

    # TODO: Unused, Soon(TM)
    #daeuniverse.url = "github:daeuniverse/flake.nix";

    ## Non-Flake
    ### My NeoVim configuration
    nvim = {
      url = "github:Guanran928/nvim";
      flake = false;
    };
  };

  outputs = inputs: let
    inherit (inputs.flake-utils.lib) eachDefaultSystemMap;
  in {
    formatter = eachDefaultSystemMap (system: inputs.nixpkgs.legacyPackages.${system}.alejandra);
    packages = eachDefaultSystemMap (system: import ./pkgs inputs.nixpkgs.legacyPackages.${system});
    nixosModules.default = ./nixos/modules;

    ### NixOS
    nixosConfigurations = {
      "Aristotle" = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          # OS
          ./nixos/profiles/core
          ./nixos/profiles/device-type/laptop
          ./nixos/profiles/opt-in/zram-generator.nix
          ./nixos/profiles/opt-in/gaming.nix
          ./nixos/profiles/opt-in/wayland.nix
          ./nixos/profiles/opt-in/virt-manager.nix

          # User
          ./users/guanranwang/nixos/profiles/core
          ./users/guanranwang/nixos/profiles/device-type/laptop
          ./users/guanranwang/nixos/profiles/opt-in/clash-meta-client.nix
          ./users/guanranwang/nixos/profiles/opt-in/gaming
          ./users/guanranwang/nixos/profiles/opt-in/torrenting

          # Hardware
          ./nixos/hosts/Aristotle
          ./nixos/profiles/opt-in/lanzaboote.nix
          ./nixos/profiles/opt-in/impermanence.nix
          ./nixos/profiles/opt-in/disko.nix

          {
            networking.hostName = "Aristotle";
            time.timeZone = "Asia/Shanghai";
            _module.args.disks = ["/dev/nvme0n1"]; # Disko
          }
        ];
      };
    };

    ### Darwin
    darwinConfigurations = {
      "Plato" = inputs.nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        specialArgs = {inherit inputs;};
        modules = [
          ./darwin/profiles/core
          ./darwin/profiles/device-type/desktop

          ./users/guanranwang/darwin/profiles/core
          ./users/guanranwang/darwin/profiles/device-type/desktop
          ./users/guanranwang/darwin/profiles/opt-in/clash-meta-client.nix

          ./darwin/hardware/apple/imac/18-3

          {
            networking.hostName = "Plato";
            time.timeZone = "Asia/Shanghai";
          }
        ];
      };
    };
  };
}
