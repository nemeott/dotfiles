_:

let
  dotfilesPath = ../..;
in
{
  # Link Noctalia settings
  home.file.".config/noctalia/config.toml".source = "${dotfilesPath}/noctalia/config.toml";
}
