{ pkgs, ... }:

let
  # Wrapper for VSCode with extra tools
  vscode-with-tools = pkgs.symlinkJoin {
    name = "vscode-with-tools";
    paths = [ pkgs.vscode ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = with pkgs; ''
      wrapProgram $out/bin/code \
        --prefix PATH : ${
          lib.makeBinPath [
            clang-tools
            clang
            nixfmt # Format Nix files
          ]
        }
    '';
  };
in
{
  programs.git = {
    enable = true;
    # user.name =
    # user.email =
  };

  environment.systemPackages = with pkgs; [
    vscode-with-tools

    # lazygit (simple tui for git)
  ];

  # Fonts
  fonts.packages = with pkgs; [
    monaspace
    nerd-fonts.monaspace
    fira-code
    nerd-fonts.fira-code
  ];

  # Set default editor to VSCode (still need to set EDITOR, VISUAL, and SUDO_EDITOR in bashrc)
  programs.vscode.defaultEditor = true;
}
