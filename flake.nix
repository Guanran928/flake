{
  description = "Guanran928's Flake";

  inputs = {
    # INFO: `nixos-unstable` and `nixpkgs-unstable` contains the same set of packages,
    #       the difference between those channels is their jobsets,
    #       `nixpkgs-unstable` contains less(?) jobs, and usually updates faster.
    #
    # REFERENCE: https://discourse.nixos.org/t/differences-between-nix-channels/13998/5
    nixpkgs.url = "github:NixOS/nixpkgs/c169763c3087b02a8308e2f8a9bba77c428dcca1"; # userborn
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

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
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.crane.follows = "crane";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.pre-commit-hooks-nix.follows = "pre-commit-hooks-nix";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    neovim = {
      url = "git+https://git.ny4.dev/nyancat/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.treefmt-nix.follows = "treefmt-nix";
      inputs.systems.follows = "systems";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### De-dupe flake dependencies
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
    pre-commit-hooks-nix = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.gitignore.follows = "gitignore";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      in
      {
        ### nix fmt
        formatter = treefmtEval.config.build.wrapper;

        ### nix flake check
        checks.formatting = treefmtEval.config.build.check inputs.self;

        ### nix {run,shell,build}
        legacyPackages = import ./pkgs pkgs;

        ### nix develop
        devShells.default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            colmena
            sops
          ];
        };
      }
    )
    // {
      ### imports = [];
      nixosModules.default = ./nixos/modules;
      homeManagerModules.default = ./home/modules;

      ### nixpkgs.overlays = [];
      overlays = import ./overlays;

      ### NixOS
      nixosConfigurations."dust" = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/profiles/core
          ./hosts/dust
        ];
        specialArgs = {
          inherit inputs;
        };
      };

      colmena = {
        meta = {
          specialArgs = {
            inherit inputs;
          };
          nixpkgs = import inputs.nixpkgs {
            system = "x86_64-linux"; # How does this work?
          };
        };

        defaults.imports = [
          ./nixos/profiles/core
          ./nixos/profiles/server
        ];

        "tyo0" = {
          imports = [ ./hosts/tyo0 ];
          deployment.targetHost = "tyo0.ny4.dev";
        };

        "blacksteel" = {
          imports = [ ./hosts/blacksteel ];
          deployment.targetHost = "blacksteel"; # thru tailscale
        };
      };
    };
}
