{ pkgs, ... }:

{
  virtualisation.docker = {
    # Disable the system wide Docker daemon
    enable = false;

    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    gnumake
    docker
    docker-compose
    git
  ];

  users.users.nathan = {
    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];

    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];
  };
}
