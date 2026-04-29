{ lib, pkgs, ... }:

{
  modules = [
    # Modules
    ../../modules/user.nix

    # Packages
    ../../modules/packages/base.nix
    ../../modules/packages/fonts.nix
  ];

  environment.packages = with pkgs; [
    procps
    killall
    diffutils
    util-linuxMinimal
    hostname
    man
  ];

  environment.etcBackupExtension = ".bak";

  system.stateVersion = "24.05";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
