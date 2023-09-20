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
  };

  outputs = { self, nixpkgs, berberman, home-manager, hosts, hyprland, lanzaboote, nix-darwin, sops-nix, ... } @ inputs: {
    darwinConfigurations = {
      "iMac-macOS" = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          ./hosts/darwin/imac-2017.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.guanranwang = import ./flakes/home-manager/guanranwang/darwin/home.nix;
          }
        ];
      };
    };




    nixosConfigurations = {
      "81fw-nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/81fw-lenovo-legion-y7000.nix

          # Overlays
          {
            nixpkgs.overlays = [
              berberman.overlays.default
            ];
          }

          lanzaboote.nixosModules.lanzaboote
          ({ pkgs, lib, ... }:
          {
            environment.systemPackages = with pkgs; [ sbctl ];
            boot.loader.systemd-boot.enable = lib.mkForce false;
            boot.lanzaboote = {
              enable = true;
              pkiBundle = "/etc/secureboot";
            };
          })

          home-manager.nixosModules.home-manager
          ({ lib, ... }:
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.guanranwang = import ./flakes/home-manager/guanranwang/nixos;

              extraSpecialArgs = { inherit inputs; }; # ??? isnt specialArgs imported by default ???
            };
            # fcitx, use kde kcm
            systemd.user.services.fcitx5-daemon.enable = lib.mkForce false;
          })

          hosts.nixosModule
          {
            networking.stevenBlackHosts = {
              enable = true;
              blockFakenews = true;
              blockGambling = true;
              blockPorn = true;
              blockSocial = true;
            };
          }

          sops-nix.nixosModules.sops
          ({ config, ... }:
          {
            sops = {
              defaultSopsFile = ./secrets/secrets.yaml;
              age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
              secrets = {
                "clash-config" = {
                  #mode = "0444"; # readable
                  owner = config.users.users."clash-meta".name;
                  group = config.users.users."clash-meta".group;
                  restartUnits = [ "clash-meta.service" ];
                  path = "/etc/clash-meta/config.yaml";
                };
                "user-password-guanranwang".neededForUsers = true;
              };
            };
          })
        ];
      };

      "imac-nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/imac-2017.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.guanranwang = import ./flakes/home-manager/guanranwang/nixos;
            };
          }

          hosts.nixosModule
          {
            networking.stevenBlackHosts = {
              enable = true;
              blockFakenews = true;
              blockGambling = true;
              blockPorn = true;
              blockSocial = true;
            };
          }
        ];
      };
    };



    # Home-Manager
    homeConfigurations = {
      "guanranwang@81fw-nixos" = home-manager.lib.homeManagerConfiguration {
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
