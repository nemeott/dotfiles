{
  pkgs,
  inputs,
  zen-browser,
  ...
}:

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
    };
  };

  environment.systemPackages = [
    (zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      extraPolicies = {
        DisableAppUpdate = true;
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisableFeedbackCommands = true;

        

        # SearchEngines = {
        #   Add = [
        #     {
        #       Name = "nixpkgs packages";
        #       URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
        #       IconURL = "https://wiki.nixos.org/favicon.ico";
        #       Alias = "@np";
        #     }
        #     {
        #       Name = "NixOS options";
        #       URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
        #       IconURL = "https://wiki.nixos.org/favicon.ico";
        #       Alias = "@no";
        #     }
        #     {
        #       Name = "NixOS Wiki";
        #       URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
        #       IconURL = "https://wiki.nixos.org/favicon.ico";
        #       Alias = "@nw";
        #     }
        #     {
        #       Name = "noogle";
        #       URLTemplate = "https://noogle.dev/q?term={searchTerms}";
        #       IconURL = "https://noogle.dev/favicon.ico";
        #       Alias = "@ng";
        #     }
        #   ];
        # };
      };
    })
  ];
}
