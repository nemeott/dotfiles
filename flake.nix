{
  description = "My NixOS configuration";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Need to use special url to use hardware modules not implemented for flakes: might not be needed anymore?
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.home-manager.follows = "home-manager";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      username = "nathan";
    in
    {
      nixosConfigurations = {
        icarus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs username; };
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
              # TODO: Move this to home manager
              # Also need to do this to allow unfree packages for nix-shell
              # mkdir -p ~/.config/nixpkgs
              # echo '{ allowUnfree = true; }' > ~/.config/nixpkgs/config.nix
            }

            ./nixos-config/hosts/icarus/configuration.nix

            # Home manager
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit inputs username; };
                users.${username}.imports = [ ./nixos-config/hosts/icarus/home.nix ];
              };
            }
          ];
        };
      };
    };
}
