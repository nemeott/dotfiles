{
  description = "My NixOS configuration";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Need to use special url to use hardware modules not implemented for flakes: might not be needed anymore?
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs";

    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.home-manager.follows = "home-manager";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-surge.url = "github:ErmitaVulpe/nixpkgs/init/surge-downloader";
    nixpkgs-nirimod.url = "github:sophronesis/nixpkgs/pkg/nirimod";
    nixpkgs-models.url = "github:nemeott/nixpkgs/add-models-package";
    nixpkgs-my-yazi-plugins.url = "github:nemeott/nixpkgs/my-yazi-plugins";

    #
    # Android (nix-on-droid)
    #
    nod-nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nod-home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nod-nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/testing";
      inputs.nixpkgs.follows = "nod-nixpkgs";
      inputs.home-manager.follows = "nod-home-manager";
    };

    nod-catppuccin.url = "github:catppuccin/nix/release-25.11";
    nod-catppuccin.inputs.nixpkgs.follows = "nod-nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nod-nixpkgs,
      ...
    }@inputs:
    let
      username = "nathan";

      # Overlays using hardcoded system strings to avoid lambda instability
      # and ensure Nix can properly memoize these across evaluations.
      desktopOverlays = [
        (final: prev: {
          surge-downloader = inputs.nixpkgs-surge.legacyPackages.x86_64-linux.surge-downloader;
          nirimod = inputs.nixpkgs-nirimod.legacyPackages.x86_64-linux.nirimod;
          models = inputs.nixpkgs-models.legacyPackages.x86_64-linux.models;
          yaziPlugins = inputs.nixpkgs-my-yazi-plugins.legacyPackages.x86_64-linux.yaziPlugins;
        })
      ];

      androidOverlays = [
        (final: prev: {
          surge-downloader = inputs.nixpkgs-surge.legacyPackages.aarch64-linux.surge-downloader;
          models = inputs.nixpkgs-models.legacyPackages.aarch64-linux.models;
          yaziPlugins = inputs.nixpkgs-my-yazi-plugins.legacyPackages.aarch64-linux.yaziPlugins;
        })
      ];

      # Instantiated once at eval time, stable reference for nix-on-droid
      nodPkgs = import inputs.nod-nixpkgs {
        system = "aarch64-linux";
        config.allowUnfree = true;
        # Overlays to add custom packages from other repos
        overlays = androidOverlays;
      };
    in
    {
      nixosConfigurations = {
        icarus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs username; };
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
              nix.registry.nixpkgs.flake = nixpkgs; # Use flake version of nixpkgs for nix shells and others

              # Overlays to add custom packages from other repos
              nixpkgs.overlays = desktopOverlays;
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
      }; # TODO: Remove with pkgs?
      nixOnDroidConfigurations.daedalus = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
        extraSpecialArgs = { inherit inputs username; };

        pkgs = nodPkgs;

        modules = [
          ./nixos-config/hosts/daedalus/configuration.nix

          # Use flake version of nixpkgs for nix shells and others
          { nix.registry.nixpkgs.flake = nod-nixpkgs; }

          # Home manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs username; };
              config = ./nixos-config/hosts/daedalus/home.nix;
            };
          }
        ];
      };
    };
}
