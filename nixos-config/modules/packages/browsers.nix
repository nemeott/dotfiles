{ ... }:

{
  # Install firefox and apply privacy-focused policies
  programs.firefox = {
    enable = true;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
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
}
