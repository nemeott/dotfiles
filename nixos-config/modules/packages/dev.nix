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
    paths = [ pkgs.zed-editor.fhs ];
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

  environment.systemPackages = with pkgs; [
    gh
    dig # DNS testing tool

    vscode-with-tools
    zed-editor-with-tools

    gcc
    python3
    python313Packages.numpy

    # lazygit (simple tui for git)
    xauth # For X11 ssh forwarding (school)
  ];
  # Set the xauth location for ssh correctly (nixos uses unusual file system)
  programs.ssh.setXAuthLocation = true;

  # Fonts
  fonts.packages = with pkgs; [
    monaspace
    nerd-fonts.monaspace
    fira-code
    nerd-fonts.fira-code
  ];
}
