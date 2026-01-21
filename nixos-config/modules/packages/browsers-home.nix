{
  inputs,
  pkgs,
  config,
  ...
}:

{
  imports = [ inputs.zen-browser.homeModules.beta ];

  home.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_LEGACY_PROFILES = "1"; # Workaround for https://github.com/0xc000022070/zen-browser-flake/issues/63
  };

  programs.zen-browser = {
    enable = true;
    policies = {
      DisableAppUpdate = true; # Flake default
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      DisableTelemetry = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      # Category = "strict";
      Cookies = {
        Behavior = "reject-tracker-and-partition-foreign";
        BehaviorPrivateBrowsing = "reject-tracker-and-partition-foreign"; # Default
      };
    };
    profiles.default = {
      # AKA Preferences (about:config)
      settings = {
        "browser.aboutConfig.showWarning" = false;
        "zen.view.welcome-screen.seen" = true;
        "zen.welcome-screen.seen" = true;
        "zen.workspaces.continue-where-left-off" = true;
        "apz.overscroll.enabled" = false; # Stop the annoying bounce at scroll boundaries
        "zen.view.window.scheme" = 0; # Dark mode
        "layout.css.prefers-color-scheme.content-override" = 0; # Dark website appearance
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Let noctalia apply theme to Zen
      };

      # Find all shortcuts with: jq -c '.shortcuts[] | {id, key, keycode, action}' ~/.zen/default/zen-keyboard-shortcuts.json
      keyboardShortcuts = [
        # Doesn't show up in Keyboard Shortcuts but they work
        {
          id = "zen-compact-mode-toggle";
          key = "[";
          modifiers = {
            alt = true;
          };
        }
        {
          id = "zen-compact-mode-show-sidebar"; # Toggle floating sidebar
          key = "[";
          modifiers = {
            control = true;
            alt = true;
          };
        }
        {
          id = "key_savePage";
          key = "s";
          modifiers.control = true;
        }
        {
          id = "key_quitApplication";
          disabled = true; # Just use Niri for this
        }
      ];
      # Fails activation on schema changes to detect potential regressions
      # Find this in about:config or prefs.js of your profile
      keyboardShortcutsVersion = 13;

      # AKA Profiles
      containersForce = true; # Delete existing containers not in the config
      containers = {
        Personal = {
          color = "blue";
          icon = "fingerprint";
          id = 1;
        };
        Work = {
          color = "orange";
          icon = "briefcase";
          id = 2;
        };
        Shopping = {
          color = "yellow";
          icon = "cart";
          id = 3;
        };
      };

      spacesForce = true; # Delete existing spaces not in the config
      # Generate random UUIDs with: uuidgen (doesn't matter what it is, just ensures unique spaces)
      spaces =
        let
          containers = config.programs.zen-browser.profiles.default.containers;
        in
        {
          "Default" = {
            id = "b31b41cf-597d-4ea2-b49c-a09d3950be59";
            position = 1000;
          };
          "School" = {
            id = "55c3ebe8-12ab-4c7d-958d-15038164f0b2";
            icon = "🎓";
            container = containers.Work.id;
            position = 2000;
          };
          "NixOS" = {
            id = "38554647-79e8-4c98-9ab6-8bc3214deb99";
            icon = "❄️";
            container = containers.Personal.id;
            position = 3000;
          };
        };

      # Search engines
      search =
        let
          nixSnowflakeIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        in
        {
          force = true; # Allow Nix to overwrite search settings on rebuild
          engines = {
            # NixOS
            mynixos = {
              name = "MyNixOS";
              urls = [ { template = "https://mynixos.com/search?q={searchTerms}"; } ];
              icon = nixSnowflakeIcon;
              definedAliases = [ "@nx" ];
            };
            nix-packages = {
              name = "Nixpkgs";
              urls = [ { template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; } ];
              icon = nixSnowflakeIcon;
              definedAliases = [ "@np" ];
            };
            nixos-options = {
              name = "NixOS Options";
              urls = [ { template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}"; } ];
              icon = nixSnowflakeIcon;
              definedAliases = [ "@no" ];
            };
            nix-flakes = {
              name = "Nix Flakes";
              urls = [ { template = "https://search.nixos.org/flakes?channel=unstable&query={searchTerms}"; } ];
              icon = nixSnowflakeIcon;
              definedAliases = [ "@nf" ];
            };
            nixos-wiki = {
              name = "NixOS Wiki";
              urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
              icon = nixSnowflakeIcon;
              definedAliases = [ "@nw" ];
            };

            # Search policy templates (for browser config info)
            policy-templates = {
              name = "Policy Templates";
              urls = [ { template = "https://mozilla.github.io/policy-templates/#{searchTerms}"; } ];
              icon = "${pkgs.firefox}/share/icons/hicolor/128x128/apps/firefox.png";
              definedAliases = [ "@policy" ];
            };
          };
        };

      extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        ublock-origin
        privacy-badger
				sponsorblock
				istilldontcareaboutcookies
				shortkeys # TODO: Auto apply shortcuts (duplicate tab: ctrl + d)
				darkreader # TODO: Auto apply Catppuccin settings
				material-icons-for-github
      ];
    };
  };
}
