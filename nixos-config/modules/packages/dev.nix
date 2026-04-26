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
  programs = {
    git = {
      enable = true;
      config.init = {
        user.name = "nemeott";
        user.email = secrets.git-email;

        defaultBranch = "main";
      };
    };

    lazygit = {
      enable = true;
      settings = {
        git = {
          log.order = "default"; # Make Lazygit faster on large repos
          pagers = [ { pager = "delta --dark --paging=never"; } ]; # Use delta pager for diffs
        };
        keybinding.commits = {
          moveUpCommit = "<c-u>";
          moveDownCommit = "<c-d>"; # ctrl-j on Zed minimizes terminal
        };
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

    # Nix dev
    nixpkgs-review
    nurl
    nix-init
    nix-update
  ];
  # Set the xauth location for ssh correctly (nixos uses unusual file system)
  programs.ssh.setXAuthLocation = true;

  # Development environments (installs direnv and nix-direnv)
  programs.direnv = {
    enable = true;
    silent = true;
  };
}
