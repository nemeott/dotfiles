{ lib, pkgs, ... }:

{
  environment.packages = with pkgs; [
    bash
    nano
    
    procps
    killall
    diffutils
    util-linuxMinimal
    hostname
    man
    
    wget
    curl
    git
  ];

  environment.etcBackupExtension = ".bak";

  system.stateVersion = "24.05";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
