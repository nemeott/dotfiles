{ inputs, pkgs, ... }:

{
  # Enable Noctalia cache
  nix.settings = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${stdenv.hostPlatform.system}.default
  ];
}
