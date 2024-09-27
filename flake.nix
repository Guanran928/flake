{
  description = "Guanran928's Flake";

  inputs = {
    # INFO: `nixos-unstable` and `nixpkgs-unstable` contains the same set of packages,
    #       the difference between those channels is their jobsets,
    #       `nixpkgs-unstable` contains less(?) jobs, and usually updates faster.
    #
    # REFERENCE: https://discourse.nixos.org/t/differences-between-nix-channels/13998/5
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.stable.follows = "nixpkgs";
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
    preservation = {
      url = "github:WilliButz/preservation";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    systems = {
      url = "github:nix-systems/default";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### De-dupe flake dependencies
    crane = {
      url = "github:ipetkov/crane";
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
    let
      data = builtins.fromJSON (builtins.readFile ./infra/data.json);
      specialArgs = {
        inherit inputs;
        nodes = data.nodes.value;
      };
    in
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      in
      {
        # nix fmt
        formatter = treefmtEval.config.build.wrapper;

        # nix flake check
        checks.formatting = treefmtEval.config.build.check inputs.self;

        # nix {run,shell,build}
        legacyPackages = import ./pkgs pkgs;

        # nix develop
        devShells.default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            (opentofu.withPlugins (
              ps: with ps; [
                aws
                vultr
                sops
              ]
            ))
            colmena
            just
            sops
          ];
        };
      }
    )
    // {
      nixosModules.default = ./nixos/modules;
      overlays.default = import ./overlays;

      nixosConfigurations = {
        "dust" = inputs.nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            ./nixos/profiles/core
            ./hosts/dust
          ];
        };
      } // inputs.self.colmenaHive.nodes;

      colmenaHive = inputs.colmena.lib.makeHive (
        {
          meta = {
            inherit specialArgs;
            nixpkgs = import inputs.nixpkgs {
              system = "x86_64-linux"; # How does this work?
            };
          };

          defaults.imports = [
            ./nixos/profiles/core
            ./nixos/profiles/server
          ];

          "pek0" = {
            imports = [ ./hosts/pek0 ];
            deployment.targetHost = "blacksteel"; # thru tailscale
          };
        }
        // (builtins.mapAttrs (n: v: {
          deployment = {
            inherit (v) tags;
            targetHost = v.fqdn;
          };
          imports =
            if (builtins.elem "vultr" v.tags) then
              [
                ./hosts/vultr/${n}
                ./hosts/vultr/common
                { networking.hostName = n; }
              ]
            else if (builtins.elem "aws" v.tags) then
              [
                ./hosts/aws/${n}
                { networking.hostName = n; }
              ]
            else
              [ ./hosts/${n} ];
        }) data.nodes.value)
      );
    };
}
