{ inputs, ... }:

{
  imports = [ inputs.helium-flake.nixosModules.default ];

  programs.helium = {
    enable = true;

    # Command-line arguments always passed to Helium
    flags = [
      "--enable-features=ParallelDownloading"
      "--close-window-with-last-tab=never" # Not applying
      "--hide-fullscreen-exit-ui" # Not applying
      # "--force-dark-mode" # TODO: Test this
    ];

    # Written to /etc/chromium/policies/managed/helium-nixos.json
    # Also written to /etc/helium/policies/managed/ for future compatibility
    # https://chromeenterprise.google/policies/
    policies = {
      "DefaultBrowserSettingEnabled" = false; # Don't check for default browser

      # Telemetry (probably not needed but just in case)
      "MetricsReportingEnabled" = false;
      "UserFeedbackAllowed" = false;
      "PromotionsEnabled" = false; # Skip welcome/promo pages

      "BlockThirdPartyCookies" = true;

      # Disable uneeded protections
      "SafeBrowsingProtectionLevel" = 0; # Don't need this because of uBlock + Privacy Badger + NextDNS
      "BuiltInDnsClientEnabled" = false; # Use OS-DNS

      # Memory saving
      "MemorySaverModeSavings" = 2; # 0 moderate, 1 balanced, 2 maximum
      "HighEfficiencyModeEnabled" = true; # Discard tabs after some time
      # "BackgroundTabFreezingEnabled" = true; # TODO: Not in Helium yet

      # Default search engine
      "DefaultSearchProviderEnabled" = true;
      "DefaultSearchProviderName" = "Brave";
      "DefaultSearchProviderSearchURL" = "https://search.brave.com/search?q={searchTerms}";
      # "DefaultSearchProviderSuggestURL" = "https://search.brave.com/api/suggest?q={searchTerms}";

      # Extra search engines (override some bangs)
      "SiteSearchSettings" = [
        {
          name = "MyNixOS";
          shortcut = "!nx";
          url = "https://mynixos.com/search?q={searchTerms}";
        }
        {
          name = "Nixpkgs";
          shortcut = "!np";
          url = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
        }
        {
          name = "Nixpkgs PRs";
          shortcut = "!npr";
          url = "https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+{searchTerms}";
        }
        {
          name = "Nixpkgs Issues";
          shortcut = "!npi";
          url = "https://github.com/NixOS/nixpkgs/issues?q=is%3Aissue+is%3Aopen+{searchTerms}";
        }
        {
          name = "NixOS Options";
          shortcut = "!no";
          url = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
        }
        {
          name = "Nix Flakes";
          shortcut = "!nf";
          url = "https://search.nixos.org/flakes?channel=unstable&query={searchTerms}";
        }
        {
          name = "NixOS Wiki";
          shortcut = "!nw";
          url = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
        }
        {
          name = "Noogle";
          shortcut = "!noo";
          url = "https://noogle.dev/q?term={searchTerms}";
        }
        {
          name = "GitHub Nix Code";
          shortcut = "!ghnc";
          url = "https://github.com/search?q=path%3A.nix+{searchTerms}&type=code";
        }
        {
          name = "Chess Programming Wiki";
          shortcut = "!cpw";
          url = "https://www.chessprogramming.org/index.php?search={searchTerms}";
        }
      ];

      # Pre-install extensions
      "ExtensionInstallForcelist" = [
        # "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        "blockjmkbacgjkknlgpkjjiijinjdanf" # Helium uBlock Origin
        "bggfcpfjbdkhfhfmkjpbhnkhnpjjeomc" # Material Icons for GitHub
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
        "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # Privacy Badger
        "edibdbjcniadpccecjdfdjjppcpchdlm" # I still don't care about cookies
        "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
      ];
    };
  };
}
