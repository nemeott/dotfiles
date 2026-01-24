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
            clang
            clang-tools
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
    # CLI Tools
    dig # DNS testing tool
    vhs # Terminal recording tool
    # lazygit (simple tui for git)

    # Editors
    vscode-with-tools
    zed-editor-with-tools

    # Languages/compilers
    gcc
    python313
    python313Packages.pip
    python313Packages.numpy
    uv

    xauth # For X11 ssh forwarding (school)
  ];
  # Set the xauth location for ssh correctly (nixos uses unusual file system)
  programs.ssh.setXAuthLocation = true;

  # Development environments (installs direnv and nix-direnv)
  programs.direnv = {
		enable = true;
		# silent = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    monaspace
    nerd-fonts.monaspace
    fira-code
    nerd-fonts.fira-code
  ];
}
