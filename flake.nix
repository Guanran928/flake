{
  description = "Guanran928's Flake";

  inputs = {
    nixpkgs.url = "github:Guanran928/nixpkgs";

    # keep-sorted start block=yes
    chicken-box = {
      url = "github:Guanran928/chicken-box";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.systems.follows = "systems";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nix-github-actions.follows = "";
      inputs.stable.follows = "nixpkgs";
    };
    danbooru_img_bot = {
      url = "github:Guanran928/danbooru_img_bot";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.treefmt-nix.follows = "treefmt-nix";
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
    ip-checker = {
      url = "github:Guanran928/ip-checker";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.systems.follows = "systems";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.crane.follows = "crane";
      inputs.flake-compat.follows = "";
      inputs.flake-parts.follows = "flake-parts";
      inputs.pre-commit-hooks-nix.follows = "";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "";
      inputs.flake-utils.follows = "flake-utils";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
    nixpkgs-tracker = {
      url = "github:Guanran928/nixpkgs-tracker";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    preservation = {
      url = "github:WilliButz/preservation";
    };
    rdict = {
      url = "github:Guanran928/rdict";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    upower-notify = {
      url = "github:Guanran928/upower-notify";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    # keep-sorted end

    ### De-dupe flake dependencies
    # keep-sorted start block=yes
    crane = {
      url = "github:ipetkov/crane";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems = {
      url = "github:nix-systems/default";
    };
    # keep-sorted end block=yes
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
        # nix fmt
        formatter = treefmtEval.config.build.wrapper;

        # nix flake check
        checks.formatting = treefmtEval.config.build.check inputs.self;

        # nix develop
        devShells.default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            (opentofu.withPlugins (
              ps: with ps; [
                cloudflare_cloudflare
                trozz_pocketid
                carlpett_sops
              ]
            ))

            colmena
            just
            sops

            lua-language-server
            nil
            nixfmt
            stylua
          ];
        };
      }
    )
    // {
      nixosModules = import ./modules;

      nixosConfigurations = {
        "dust" = inputs.nixpkgs.lib.nixosSystem {
          specialArgs.inputs = inputs;
          system = "x86_64-linux";
          modules = [
            ./profiles/core
            ./hosts/dust
          ];
        };
      }
      // inputs.self.colmenaHive.nodes;

      colmenaHive = inputs.colmena.lib.makeHive {
        meta = {
          specialArgs.inputs = inputs;
          nixpkgs = import inputs.nixpkgs {
            system = "x86_64-linux"; # How does this work?
          };
        };

        defaults.imports = [
          ./profiles/core
          ./profiles/server
        ];

        # keep-sorted start block=yes newline_separated=yes
        "lax0" = {
          imports = [ ./hosts/lax0 ];
          deployment = {
            tags = [ "proxy" ];
            targetHost = "lax0.ny4.dev";
          };
        };

        "pek0" = {
          imports = [ ./hosts/pek0 ];
          deployment = {
            tags = [ ];
            targetHost = "blacksteel"; # thru tailscale
          };
        };

        "tyo0" = {
          imports = [ ./hosts/tyo0 ];
          deployment = {
            tags = [ "proxy" ];
            targetHost = "tyo0.ny4.dev";
          };
        };
        # keep-sorted end
      };
    };
}
