{
  description = "NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    { self, nixpkgs, nixos-hardware }:
    {
      nixosConfigurations.icarus = nixpkgs.lib.nixosSystem {
        modules = [ ./configuration.nix ];
      };
    };
}
