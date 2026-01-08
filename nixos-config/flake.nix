{
  description = "My NixOS configuration";

  inputs = {

    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Need to use special url to use hardware modules not implemented for flakes
    nixos-hardware.url = "github:NixOS/nixos-hardware?ref=master";

    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
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
          modules = [
            ({
              nixpkgs.config.allowUnfree = true;
              # Also need to do this to allow unfree packages for nix-shell
              # mkdir -p ~/.config/nixpkgs
              # echo '{ allowUnfree = true; }' > ~/.config/nixpkgs/config.nix
            })
            ./hosts/icarus/configuration.nix
          ];
        };
      };
    };
}
