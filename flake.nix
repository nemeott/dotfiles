{
  description = "My NixOS configuration";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Need to use special url to use hardware modules not implemented for flakes
    nixos-hardware.url = "github:NixOS/nixos-hardware?ref=master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      zen-browser,
      noctalia,
    }:
    {
      nixosConfigurations = {
        icarus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit
              nixos-hardware
              home-manager
              zen-browser
              noctalia
              ;
            username = "nathan";
          }; # What to pass in to configuration.nix
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
              # Also need to do this to allow unfree packages for nix-shell
              # mkdir -p ~/.config/nixpkgs
              # echo '{ allowUnfree = true; }' > ~/.config/nixpkgs/config.nix
            }
            ./nixos-config/hosts/icarus/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
              };
            }
          ];
        };
      };
    };
}
