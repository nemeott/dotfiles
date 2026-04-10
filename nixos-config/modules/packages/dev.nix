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

in
{
  programs.git = {
    enable = true;
    config.init = {
      user.name = "nemeott";
      user.email = secrets.git-email;

      defaultBranch = "main";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        log.order = "default"; # Make Lazygit faster on large repos
        pagers = [ { pager = "delta --dark --syntax-theme 'Catppuccin Mocha' --paging=never"; } ]; # Use delta pager for diffs
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # CLI Tools
    dig # DNS testing tool
    vhs # Terminal recording tool
    perf # Performance analysis tool

    # Editors
    vscode-with-tools

    # Languages/compilers
    gcc
    mold # Fast linker
    python313
    python313Packages.pip
    python313Packages.numpy
    uv
    gnumake

    xauth # For X11 ssh forwarding (school)

    # devenv # Development environments with Nix
  ];
  # Set the xauth location for ssh correctly (nixos uses unusual file system)
  programs.ssh.setXAuthLocation = true;

  # Development environments (installs direnv and nix-direnv)
  programs.direnv = {
    enable = true;
    silent = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    monaspace
    nerd-fonts.monaspace
  ];
}
