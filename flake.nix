{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    berberman = {
      url = "github:berberman/flakes";
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
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #nixos-hardware = {
    #  url = "github:NixOS/nixos-hardware/master";
    #  #inputs.nixpkgs.follows = "nixpkgs";
    #};
    #nixpak = {
    #  url = "github:nixpak/nixpak";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
  };

  outputs = { self,
              nixpkgs,
              berberman,
              home-manager,
              hosts,
              hyprland,
              lanzaboote,
              nix-darwin,
              sops-nix,
              disko,
              impermanence,
              ... } @ inputs: {

    # nix-darwin (macOS)
    darwinConfigurations = {
      "iMac-macOS" = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./darwin                          # Entrypoint
          ./machines/darwin/imac-2017       # Hardware-specific configurations
                                            # Machine-specific configurations (does such stuff even exist on nix-darwin)
          ./users/guanranwang/darwin.nix    # User-specific configurations
          ./flakes/darwin/home-manager.nix  # Flakes

          { networking.hostName = "iMac-macOS"; }
        ];
      };
    };


    # NixOS
    nixosConfigurations = {
      "81fw-nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos                                             # Entrypoint
          ./machines/nixos/81fw-lenovo-legion-y7000           # Hardware-specific configurations
          #./machines/nixos/81fw-lenovo-legion-y7000/machine-1 # Machine-specific configurations
          ./users/guanranwang/nixos.nix                       # User-specific configurations
          ./flakes/nixos/berberman.nix                        # Flakes
          ./flakes/nixos/home-manager.nix
          ./flakes/nixos/hosts.nix
          ./flakes/nixos/lanzaboote.nix
          ./flakes/nixos/sops-nix.nix
          ./flakes/nixos/impermanence.nix
          ./flakes/nixos/disko.nix

          {
            _module.args.disks = [ "/dev/nvme0n1" ]; # Disko
            networking.hostName = "81fw-nixos";
          }
        ];
      };

      ## Currently un-used.
      "imac-nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos
          ./machines/nixos/imac-2017
          ./machines/nixos/imac-2017/machine-1
          ./users/guanranwang/nixos.nix
          ./flakes/nixos/berberman.nix
          ./flakes/nixos/home-manager.nix
          ./flakes/nixos/hosts.nix
          ./flakes/nixos/lanzaboote.nix
          ./flakes/nixos/sops-nix.nix

          { networking.hostName = "imac-nixos"; }
        ];
      };
    };


    # Home-Manager
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

      "guanranwang@imac-nixos" = home-manager.lib.homeManagerConfiguration {
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
