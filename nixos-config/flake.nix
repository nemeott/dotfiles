{
  description = "NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    {
      nixosConfigurations.icarus = nixpkgs.lib.nixosSystem {
        modules = [ ./configuration.nix ];
      };
    };
}
