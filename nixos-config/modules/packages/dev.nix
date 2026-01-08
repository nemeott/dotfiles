{ pkgs, ... }:

let
  secrets = import ../../secrets.nix;

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
            cppcheck # C/C++ static analysis tool
          ]
        }
    '';
  };
in
{
  programs.git = {
    enable = true;
    config.init = {
      user.name = "nemeott";
      user.email = secrets.git-email;
    };
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
