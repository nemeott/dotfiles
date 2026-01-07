{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Need to use special url to use hardware modules not implemented for flakes
    nixos-hardware.url = "github:NixOS/nixos-hardware?ref=master";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
    }:
    {
      nixosConfigurations = {
        icarus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit nixos-hardware; }; # Pass in nixos-hardware
          modules = [ ./hosts/icarus/configuration.nix ];
        };
      };
    };
}
