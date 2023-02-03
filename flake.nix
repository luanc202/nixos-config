# this is the beginning of my humble nix flake config
# I'm new into this so improvements are welcome!
# I will try to keep the README useful and up to date
# this is a very WIP so do not expect much
#
# flake.nix *             
#   ├─ ./hosts
#   │   └─ default.nix

{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs}:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        luan = {
          inherit system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.luan = {
                imports = [ ./home.nix ];
              };
            };
          ];
        };
      };
      hmConfig = {
        luan = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs;
          username = "luan";
          homeDirectory = "/home/luan";
          stateVersion = "22.11";
          configuration = [
            imports = [
              ./home.nix
            ];
          ];
        };
      };
    };
};