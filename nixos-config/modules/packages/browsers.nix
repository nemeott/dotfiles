{ pkgs, zen-browser, ... }:

{
  programs.firefox = {
    enable = true;

    policies = {
      DisableAppUpdate = true;
      DontCheckDefaultBrowser = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      Category = "strict";
      DisableFeedbackCommands = true;
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      FirefoxHome = {
        Pocket = false;
        SponsoredPocket = false;
        SponsoredTopSites = false;
        SponsoredStories = false;
      };
      Preferences = {
        "apz.overscroll.enabled".Value = false; # Disable overscroll bounce
      };
    };
  };

  # environment.systemPackages = [
  #   (zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
  #     # FIX: NOT WORKING
  #     profiles.Personal.search.engines = {
  #       nixPackages = {
  #         name = "Nix Packages";
  #         urls = "https://search.nixos.org/packages?query={searchTerms}";
  #         icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  #         definedAliases = [ "@np" ];
  #       };
  #       nixosOptions = {
  #         name = "NixOS Options";
  #         urls = "https://search.nixos.org/options?query={searchTerms}";
  #         icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  #         definedAliases = [ "@no" ];
  #       };
  #       nixosWiki = {
  #         name = "NixOS Wiki";
  #         urls = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
  #         icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  #         definedAliases = [ "@nw" ];
  #       };
  #       # Search NixOS functions
  #       noogle = {
  #         name = "noogle";
  #         urls = "https://noogle.dev/q?term={searchTerms}";
  #         icon = "https://noogle.dev/favicon.ico";
  #         definedAliases = [ "@ng" ];
  #       };
  #     };

  #     # https://mozilla.github.io/policy-templates/
  #     extraPolicies = {
  #       DisableAppUpdate = true;
  #       DisableTelemetry = true;
  #       DisableFirefoxStudies = true;
  #       EnableTrackingProtection = {
  #         Value = true;
  #         Locked = true;
  #         Cryptomining = true;
  #         Fingerprinting = true;
  #       };
  #       Category = "strict";
  #       DisableFeedbackCommands = true;

  #       # FIX: NOT WORKING
  #       Preferences = {
  #         "apz.overscroll.enabled".Value = false; # Disable overscroll bounce
  #         "toolkit.legacyUserProfileCustomizations.stylesheets".Value = true; # Let noctalia apply theme to Zen
  #       };

  #       # SearchEngines = {
  #       #   Add = [
  #       #     {
  #       #       Name = "nixpkgs packages";
  #       #       URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
  #       #       IconURL = "https://wiki.nixos.org/favicon.ico";
  #       #       Alias = "@np";
  #       #     }
  #       #     {
  #       #       Name = "NixOS options";
  #       #       URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
  #       #       IconURL = "https://wiki.nixos.org/favicon.ico";
  #       #       Alias = "@no";
  #       #     }
  #       #     {
  #       #       Name = "NixOS Wiki";
  #       #       URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
  #       #       IconURL = "https://wiki.nixos.org/favicon.ico";
  #       #       Alias = "@nw";
  #       #     }
  #       #     {
  #       #       Name = "noogle";
  #       #       URLTemplate = "https://noogle.dev/q?term={searchTerms}";
  #       #       IconURL = "https://noogle.dev/favicon.ico";
  #       #       Alias = "@ng";
  #       #     }
  #       #   ];
  #       # };
  #     };
  #   })
  # ];
}
