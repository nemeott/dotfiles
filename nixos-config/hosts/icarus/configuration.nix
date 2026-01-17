# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  lib,
  pkgs,
  nixos-hardware,
  username,
  catppuccin,
  ...
}:
let
  hostname = "icarus";

  secrets = import ../../secrets.nix;
in
{
  imports = [
    ./hardware-configuration.nix # Copied from /etc/nixos/hardware-configuration.nix

    # Add nixos-hardware modules for better hardware support
    "${nixos-hardware}/common/pc/laptop"
    "${nixos-hardware}/common/cpu/intel/tiger-lake"
    "${nixos-hardware}/common/gpu/intel/tiger-lake"

    # Custom hardware configuration for Chromebook (audio and keyboard)
    ./hardware/chrome-device.nix # Audio and keyboard fix from GitHub
    ./hardware/chrome-audio.nix # Custom audio config to manually set audio profile

    # Modules
    ../../modules/user.nix
    # ../../modules/cinnamon.nix
    ../../modules/niri.nix

    # Packages
    ../../modules/packages/base.nix
    ../../modules/packages/cli.nix
    ../../modules/packages/dev.nix
    ../../modules/packages/media.nix
    ../../modules/packages/productivity.nix
    ../../modules/packages/browsers.nix
  ];

  home-manager = {
    extraSpecialArgs = { inherit username; };
    users.${username} = {
      imports = [
        ./home.nix
        catppuccin.homeModules.catppuccin
      ];
    };
  };

  # Enable all firmware (including unfree) for better hardware support
  hardware.enableAllFirmware = true;

  # Use facter for better hardware support
  hardware.facter.reportPath = ./facter.json;
  # Generate facter config file with:
  # sudo nix run nixpkgs#nixos-facter -- -o facter.json

  # Use Lix package manager instead of Nix
  nix.package = pkgs.lixPackageSets.stable.lix;

  # Disable access time updates for better performance (not usually needed by modern programs)
  fileSystems."/".options = [ "noatime" ];

  # Bootloader
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_6_18; # Use latest linux kernel
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Power-saving dirty writeback settings
    kernel.sysctl = {
      "vm.dirty_writeback_centisecs" = 5000;
      "vm.dirty_expire_centisecs" = 5000;
      "vm.page-cluster" = 0; # Use with zramSwap
    };

    # Manage power saving for Intel HDA audio
    kernelParams = [
      # Disable NMI watchdog for performance improvement
      "nmi_watchdog=0"

      # Used with power-profiles-daemon
      "snd_hda_intel.power_save=1"
      "snd_hda_intel.power_save_controller=Y"
    ];
  };

  # Enable zram swap for better performance on systems with limited RAM
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # Udev rule to set PCI power control to auto for better power management (used with power-profiles-daemon)
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", TEST=="power/control", ATTR{power/control}="auto"
  '';

  # Enable power-profiles-daemon for power management
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true; # Let Noctalia-shell detect battery status

  # Enable thermald for thermal management (Intel CPUs)
  services.thermald.enable = true;

  # Enable system76-scheduler for better IO scheduling
  services.system76-scheduler.enable = true;

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

  # Enable removable media management
  services.udisks2.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false; # Don't power on Bluetooth by default
  };
  services.blueman.enable = true;

  # rfkill please don't kill my bluetooth
  systemd.services.systemd-rfkill = {
    postStart = ''
      ${pkgs.util-linux}/bin/rfkill unblock bluetooth
    '';
  };

  # Systemd script of hopes and prayers (hacky but works, increase sleep time if it doesn't)
  # Turn off bluetooth after Noctalia fully starts (fixes Noctalia bluetooth toggle not working)
  systemd.user.services.noctalia-bluetooth-fix = {
    description = "Power off Bluetooth after Noctalia fully starts";

    wantedBy = [ "default.target" ];
    after = [ "niri.service" ];

    # Let quickshell initialize, then turn off bluetooth
    script = ''
      sleep 5 # Pray noctalia shell is fully started after this
      ${pkgs.bluez}/bin/bluetoothctl power off
    '';
  };

  # Set time zone and select internationalisation properties
  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable thunderbolt management with bolt
  environment.systemPackages = [ pkgs.bolt ];
  services.hardware.bolt.enable = true;
  # Enroll device with: boltctl enroll DEVICE
  # Temporarily add device with: boltctl authorize DEVICE

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Settings to make builds faster
  nix.daemonIOSchedClass = "best-effort"; # (default)
  nix.daemonCPUSchedPolicy = "batch"; # Optimized for non-interactive tasks
  nix.daemonIOSchedPriority = 2; # Higher priority for IO operations

  # Hard link identical files in the Nix store to save disk space
  nix.settings.auto-optimise-store = true; # nix-store --optimise

  # Enable nix-command experimental feature
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # First installation version
  system.stateVersion = "25.11";
}
