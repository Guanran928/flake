{
  description = "Guanran928's Flake";

  inputs = {
    # INFO: `nixos-unstable` and `nixpkgs-unstable` contains the same set of packages,
    #       the difference between those channels is their jobsets,
    #       `nixpkgs-unstable` contains less(?) jobs, and usually updates faster.
    #
    # REFERENCE: https://discourse.nixos.org/t/differences-between-nix-channels/13998/5
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
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
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
    nixos-sensible = {
      url = "github:Guanran928/nixos-sensible";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-for-bootstrap.follows = "nixpkgs";
      inputs.nixpkgs-docs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.nix-formatter-pack.follows = "nix-formatter-pack";
      inputs.nmd.follows = "nmd";
    };
    nur = {
      url = "github:nix-community/NUR";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };
    srvos = {
      url = "github:nix-community/srvos";
      inputs.nixpkgs.follows = "nixpkgs";
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
    nix-formatter-pack = {
      url = "github:Gerschtli/nix-formatter-pack";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nmd.follows = "nmd";
      inputs.nmt.follows = "nmt";
    };
    nmd = {
      url = "sourcehut:~rycee/nmd";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.scss-reset.follows = "scss-reset";
    };
    nmt = {
      url = "sourcehut:~rycee/nmt";
      flake = false;
    };
    pre-commit-hooks-nix = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
      inputs.flake-compat.follows = "flake-compat";
      inputs.gitignore.follows = "gitignore";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    scss-reset = {
      url = "github:andreymatin/scss-reset";
      flake = false;
    };
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in {
      ### nix fmt
      formatter = treefmtEval.config.build.wrapper;

      ### nix flake check
      checks = {formatting = treefmtEval.config.build.check inputs.self;};

      ### nix {run,shell,build}
      legacyPackages = import ./pkgs pkgs;

      ### nix develop
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          alejandra
          colmena
          git
          sops
        ];
      };
    })
    // (let
      mkNixOS = system: modules:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [./nixos/profiles/core] ++ modules;
          specialArgs = {inherit inputs;};
        };

      mkDarwin = system: modules:
        inputs.nix-darwin.lib.darwinSystem {
          inherit system modules;
          specialArgs = {inherit inputs;};
        };

      mkDroid = modules:
        inputs.nix-on-droid.lib.nixOnDroidConfiguration {
          inherit modules;
          extraSpecialArgs = {inherit inputs;};
        };
    in {
      ### imports = [];
      nixosModules.default = ./nixos/modules;
      darwinModules.default = ./darwin/modules;
      homeManagerModules.default = ./home/modules;

      ### nixpkgs.overlays = [];
      overlays = import ./overlays;

      ### NixOS
      nixosConfigurations = {
        "aristotle" = mkNixOS "x86_64-linux" [./hosts/aristotle];
        "blacksteel" = mkNixOS "x86_64-linux" [./hosts/blacksteel];
        "dust" = mkNixOS "x86_64-linux" [./hosts/dust];
      };

      ### Darwin
      darwinConfigurations = {
        "plato" = mkDarwin "x86_64-darwin" [./hosts/plato];
        "whitesteel" = mkDarwin "x86_64-darwin" [./hosts/whitesteel];
      };

      nixOnDroidConfigurations = {
        "enchilada" = mkDroid [./hosts/enchilada];
      };

      colmena = {
        meta = {
          specialArgs = {inherit inputs;};
          nixpkgs = import inputs.nixpkgs {
            system = "x86_64-linux"; # How does this work?
          };
        };

        defaults.imports = [
          ./nixos/profiles/core
        ];

        "lightsail-tokyo" = {
          imports = [./hosts/lightsail-tokyo];
          deployment.targetHost = "tyo0.ny4.dev";
        };

        "blacksteel" = {
          imports = [./hosts/blacksteel];
          deployment.targetHost = "blacksteel"; # thru tailscale
        };
      };
    });
}
