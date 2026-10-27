# https://nixos.wiki/wiki/Encrypted_DNS

{ lib, ... }:

let
  hostname = "icarus";

  secrets = import ../secrets.nix;
in
{
  imports = [ ./cake-autorate-module.nix ];

  # Dedicated Chrome instance to log into captive portals without messing with DNS settings
  programs.captive-browser = {
    enable = true;
    interface = "wlp0s20f3";
  };

  # Use correct regulatory domain for WiFi (default is global which is more restrictive)
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom=US
  '';

  networking = {
    hostName = hostname; # Define your hostname (default is nixos)

    # TODO: Disable DNS with keybind or script/service

    # Enable networking
    dhcpcd.enable = false; # Disable dhcpcd since we are using NetworkManager
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.powersave = true;
    };

    firewall = {
      enable = true;

      allowedTCPPorts = [
        # 3000 # npx serve
        53317 # LocalSend
        5037 # ADB
      ];
      allowedUDPPorts = [ 53317 ]; # LocalSend
    };
  };
  services = {
    # TODO: Convert to systemd service to allow toggling DNS?
    # Set /etc/systemd/resolved.conf to use NextDNS with DNS over TLS
    resolved = {
      enable = true;
      settings.Resolve =
        let
          host = lib.strings.toSentenceCase hostname;
          next-dns-id = secrets."next-dns-id";
        in
        {
          DNS = [
            "45.90.28.0#${host}-${next-dns-id}.dns.nextdns.io"
            "45.90.30.0#${host}-${next-dns-id}.dns.nextdns.io"
            "2a07:a8c0::#${host}-${next-dns-id}.dns.nextdns.io"
            "2a07:a8c1::#${host}-${next-dns-id}.dns.nextdns.io"
          ];
          Domains = [
            "~."
            "~msu.edu"
          ];

          DNSOverTLS = "yes"; # Switch to opportunistic if bad ISP and WiFi block DoT port
          DNSSEC = "no"; # Can cause issues with certain sites
          Cache = "yes";

          # DNS over HTTPS not yet supported by systemd-resolved
          # Wait for https://github.com/systemd/systemd/pull/31537 and corresponding support in NixOS
          # services.resolved.DNSOverHTTPS = "true";
        };
    };

    cake-autorate = {
      enable = true;
      autoStart = true; # Start the systemd service

      interface = "wlp0s20f3";

      percent = 95; # Percentage of the speeds to use
      download = {
        min = 5000; # Third to half of worst speed
        base = 50000;
        speed = 537500; # Mesaured download speed
      };
      upload = {
        min = 5000;
        base = 20000;
        speed = 22800; # Measured upload speed
      };
    };
  };
}
