_:

{
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_LEGACY_PROFILES = "1"; # Workaround for https://github.com/0xc000022070/zen-browser-flake/issues/63
  };
}
