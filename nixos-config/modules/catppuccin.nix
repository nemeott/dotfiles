{ inputs, ... }:

{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  catppuccin = {
    enable = true;
    autoEnable = true;
    tty.enable = false; # Save my eyes on boot
  };
}
