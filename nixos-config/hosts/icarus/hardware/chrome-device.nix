# https://github.com/dj1ch/nixos-chromebook
{ pkgs, ... }:

let
  cb-ucm-conf =
    with pkgs;
    alsa-ucm-conf.overrideAttrs {
      wttsrc = fetchFromGitHub {
        owner = "WeirdTreeThing";
        repo = "alsa-ucm-conf-cros";
        rev = "6b395ae73ac63407d8a9892fe1290f191eb0315b";
        hash = "sha256-GHrK85DmiYF6FhEJlYJWy6aP9wtHFKkTohqt114TluI=";
      };
      unpackPhase = ''
        runHook preUnpack
        tar xf "$src"
        runHook postUnpack
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out/share/alsa
        cp -r alsa-ucm*/ucm2 $out/share/alsa
        runHook postInstall
      '';
    };
in
{
  boot = {
    extraModprobeConfig = ''
      options snd-intel-dspcfg dsp_driver=3
    '';
  };
  environment = {
    systemPackages = [
      pkgs.sof-firmware
    ];
    sessionVariables.ALSA_CONFIG_UCM2 = "${cb-ucm-conf}/share/alsa/ucm2";
  };

  # AUDIO SETUP FOR > 24.05
  # for 24.05
  services.pipewire.wireplumber.configPackages = [
    (pkgs.writeTextDir "share/wireplumber/main.lua.d/51-increase-headroom.lua" ''
      rule = {
        matches = {
          {
            { "node.name", "matches", "alsa_output.*" },
          },
        },
        apply_properties = {
          ["api.alsa.headroom"] = 4096,
        },
      }

      table.insert(alsa_monitor.rules,rule)
    '')
  ];

  # system.replaceRuntimeDependencies = [
  system.replaceDependencies.replacements = [
    {
      original = pkgs.alsa-ucm-conf;
      replacement = cb-ucm-conf;
    }
  ];
}
