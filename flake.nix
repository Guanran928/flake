{
  description = "Guanran928's Flake";

  inputs = {
    nixpkgs.url = "github:Guanran928/nixpkgs";

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nix-github-actions.follows = "nix-github-actions";
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
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.git-hooks.follows = "pre-commit-hooks-nix";
      inputs.hercules-ci-effects.follows = "hercules-ci-effects";
      inputs.treefmt-nix.follows = "treefmt-nix";
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
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### Resources used for auto update
    chicken-box = {
      url = "https://git.ny4.dev/nyancat/chicken-box/archive/master.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.systems.follows = "systems";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    danbooru_img_bot = {
      url = "https://git.ny4.dev/nyancat/danbooru_img_bot/archive/master.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    ip-checker = {
      url = "https://git.ny4.dev/nyancat/ip-checker/archive/master.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.systems.follows = "systems";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    neovim = {
      url = "https://git.ny4.dev/nyancat/nvim/archive/master.tar.gz";
      flake = false;
    };
    rdict = {
      url = "github:Guanran928/rdict";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
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
    hercules-ci-effects = {
      url = "github:hercules-ci/hercules-ci-effects";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    nix-github-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.gitignore.follows = "gitignore";
    };
    systems = {
      url = "github:nix-systems/default";
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
        # NOTE: 301: All packages are migrated to `github:Guanran928/nur-packages`,
        #       only keeping some packages that only fits for personal use.
        legacyPackages = {
          background = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src;
        };

        # nix develop
        devShells.default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            (opentofu.withPlugins (
              ps: with ps; [
                aws
                cloudflare
                pocketid
                sops
                vultr
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
      overlays.default = import ./overlays;

      nixosConfigurations = {
        "dust" = inputs.nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            ./profiles/core
            ./hosts/dust
          ];
        };
      }
      // inputs.self.colmenaHive.nodes;

      colmenaHive = inputs.colmena.lib.makeHive (
        {
          meta = {
            inherit specialArgs;
            nixpkgs = import inputs.nixpkgs {
              system = "x86_64-linux"; # How does this work?
            };
          };

          defaults.imports = [
            ./profiles/core
            ./profiles/server
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
          imports = [
            ./hosts/${n}
            { networking.hostName = n; }
          ]
          ++ (
            if (builtins.elem "vultr" v.tags) then
              [
                ./profiles/vultr
              ]
            else
              [ ]
          );
        }) data.nodes.value)
      );
    };
}
