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
}
