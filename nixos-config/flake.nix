{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Need to use special url to use hardware modules not implemented for flakes
    nixos-hardware.url = "github:NixOS/nixos-hardware?ref=master";

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";

      # optional, but recommended if you closely follow NixOS unstable so it shares
      # system libraries, and improves startup time
      # NOTE: if you experience a build failure with Zen, the first thing to check is to remove this line!
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      zen-browser,
    }:
    {
      nixosConfigurations = {
        icarus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit nixos-hardware zen-browser; }; # What to pass in to configuration.nix
          modules = [ ./hosts/icarus/configuration.nix ];
        };
      };
    };
}
