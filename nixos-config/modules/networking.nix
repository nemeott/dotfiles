{ lib, ... }:

let
  hostname = "icarus";

  secrets = import ../secrets.nix;
in
{
  networking = {
    hostName = hostname; # Define your hostname (default is nixos)

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    dhcpcd.enable = false; # Disable dhcpcd since we are using NetworkManager
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.powersave = true;
    };
    wireless = {
      enable = true; # Allow connections to WPA/WPA2 networks
      scanOnLowSignal = false;
    };
  };

  # Set /etc/systemd/resolved.conf to use NextDNS with DNS over TLS
  services.resolved = {
    enable = true;
    extraConfig =
      let
        host = lib.strings.toCamelCase hostname;
        next-dns-id = secrets."next-dns-id";
      in
      ''
        [Resolve]
        DNS=45.90.28.0#${host}-${next-dns-id}.dns.nextdns.io
        DNS=45.90.30.0#${host}-${next-dns-id}.dns.nextdns.io
        DNS=2a07:a8c0::#${host}-${next-dns-id}.dns.nextdns.io
        DNS=2a07:a8c1::#${host}-${next-dns-id}.dns.nextdns.io

        # Enable DNS for msu.edu to access MSU sites on MSU WiFi
        Domains=~msu.edu
        DNS=35.8.0.7
        DNS=35.8.0.8
        DNS=35.8.0.9

        # DNSOverTLS=opportunistic # Use DNS over TLS if available
        DNSOverTLS=yes
        Cache=yes
      '';
  };
}
