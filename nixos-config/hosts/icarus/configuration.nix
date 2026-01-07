# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  nixos-hardware,
  ...
}:

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
    ../../modules/cinnamon.nix

    # Packages
    ../../modules/packages/base.nix
    ../../modules/packages/cli.nix
    ../../modules/packages/dev.nix
    ../../modules/packages/media.nix
    ../../modules/packages/productivity.nix
    ../../modules/packages/browsers.nix
  ];

  # Use facter for better hardware support
  hardware.facter.reportPath = ./facter.json;
  # Generate facter config file with:
  # sudo nix run nixpkgs#nixos-facter -- -o facter.json

  # Enable nix-command experimental feature
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Use Lix package manager instead of Nix
  nix.package = pkgs.lixPackageSets.stable.lix;

  # Bootloader
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_6_18; # Use latest linux kernel
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Use tlp for power management
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;

  networking = {
    hostName = "icarus"; # Define your hostname (default is nixos)
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager.enable = true;
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

  # Enable thunderbolt support
  environment.systemPackages = [ pkgs.bolt ];
  services.hardware.bolt.enable = true;
  # Enroll device with: boltctl enroll DEVICE
  # Temporarily add device with: boltctl authorize DEVICE

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Also need to do this to allow unfree packages for nix-shell
  # mkdir -p ~/.config/nixpkgs
  # echo '{ allowUnfree = true; }' > ~/.config/nixpkgs/config.nix

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
