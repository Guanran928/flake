{
  inputs = {
    # Flake inputs
    ## Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    ## Flakes
    berberman = {
      url = "github:berberman/flakes";
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.nixpkgs.follows = "nixpkgs"; # MESA/OpenGL HW workaround
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Unused
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

  outputs = { self,
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
              ... } @ inputs: {

    ### NixOS
    nixosConfigurations = {
      "81FW-NixOS" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/presets/gaming.nix                          # OS-specific (with presets)
          ./users/guanranwang/nixos/presets/gaming.nix        # User-specific (with presets)
          ./machines/nixos/81fw-lenovo-legion-y7000           # Hardware-specific
          ./machines/nixos/81fw-lenovo-legion-y7000/machine-1 # Machine-specific

          {
            networking.hostName = "81FW-NixOS"; # Hostname
            time.timeZone = "Asia/Shanghai";    # Timezone
          }
        ];
      };
    };


    ### nix-darwin (macOS)
    darwinConfigurations = {
      "iMac-macOS" = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./darwin
          ./users/guanranwang/darwin/presets/desktop.nix
          ./machines/darwin/imac-2017

          {
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
        extraSpecialArgs = { inherit inputs; };
        modules = [
          sops-nix.homeManagerModules.sops
          hyprland.homeManagerModules.default
          {
            wayland.windowManager.hyprland = {
              enable = true;
              #enableNvidiaPatches = true;
              xwayland = {
                enable = true;
              };
            };
          }
        ];
      };
    };
  };
}
