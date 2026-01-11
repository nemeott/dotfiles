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
            cppcheck # C/C++ static analysis tool
            nixfmt # Format Nix files
          ]
        }
    '';
  };

  zed-editor-with-tools = pkgs.symlinkJoin {
    name = "zed-editor-with-tools";
    paths = [ pkgs.zed-editor ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = with pkgs; ''
      wrapProgram $out/bin/zeditor \
        --prefix PATH : ${
          lib.makeBinPath [
            nil # Nix language server
            nixd # Nix language server
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

  environment.systemPackages = [
    vscode-with-tools
    zed-editor-with-tools

    # lazygit (simple tui for git)
  ];

  # Fonts
  fonts.packages = with pkgs; [
    monaspace
    nerd-fonts.monaspace
    fira-code
    nerd-fonts.fira-code
  ];
}
