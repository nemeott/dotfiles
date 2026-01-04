{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    vscode
    nixfmt # Format Nix files
  ];

  # Set default editor to VSCode (still need to set EDITOR and SUDO_EDITOR in bashrc)
  programs.vscode.defaultEditor = true;
}
