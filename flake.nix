# TODO: Remove with pkgs?

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

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-surge.url = "github:ErmitaVulpe/nixpkgs/init/surge-downloader";
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

      mkOverlays = system: [
        (final: prev: {
          surge-downloader = inputs.nixpkgs-surge.legacyPackages.${system}.surge-downloader;
          models = inputs.nixpkgs-models.legacyPackages.${system}.models;
          yaziPlugins = inputs.nixpkgs-my-yazi-plugins.legacyPackages.${system}.yaziPlugins;
        })
      ];

      mkPkgs =
        nixpkgsInput: system:
        import nixpkgsInput {
          inherit system;
          config.allowUnfree = true;
          overlays = mkOverlays system;
        };

      mkHomeManagerModule =
        {
          homePath ? null,
          configPath ? null,
        }:
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = { inherit inputs username; };
          }
          // (
            if configPath != null then
              { config = configPath; }
            else
              { users.${username}.imports = [ homePath ]; }
          );
        };
    in
    {
      nixosConfigurations = {
        icarus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs username; };
          modules = [
            {
              nixpkgs.pkgs = mkPkgs nixpkgs "x86_64-linux";

              # Use flake version of nixpkgs for nix shells and others
              nix.registry.nixpkgs.flake = nixpkgs;
            }

            ./nixos-config/hosts/icarus/configuration.nix

            inputs.home-manager.nixosModules.home-manager
            (mkHomeManagerModule { homePath = ./nixos-config/hosts/icarus/home.nix; })
          ];
        };
      };
      nixOnDroidConfigurations.daedalus = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = mkPkgs nod-nixpkgs "aarch64-linux";
        extraSpecialArgs = { inherit inputs username; };
        modules = [
          # Use flake version of nixpkgs for nix shells and others
          { nix.registry.nixpkgs.flake = nod-nixpkgs; }

          ./nixos-config/hosts/daedalus/configuration.nix

          # Home manager
          (mkHomeManagerModule { configPath = ./nixos-config/hosts/daedalus/home.nix; })
        ];
      };
    };
}
