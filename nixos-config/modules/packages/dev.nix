{ pkgs, ... }:

{
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    # lazygit (simple tui for git)
    nixfmt # Format Nix files
    vscode
  ];

  # Fonts
  fonts.packages = with pkgs; [
    monaspace
    nerd-fonts.monaspace
    fira-code
    nerd-fonts.fira-code
  ];

  # Set default editor to VSCode (still need to set EDITOR and SUDO_EDITOR in bashrc)
  programs.vscode.defaultEditor = true;
}
