# https://github.com/dj1ch/nixos-chromebook
{ pkgs, ... }:

let
  cb-ucm-conf = pkgs.alsa-ucm-conf.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "WeirdTreeThing";
      repo = "alsa-ucm-conf-cros";
      rev = "a4e92135fd49e669b5ce096439289e05e25ae90c";
      hash = "sha256-3TpzjmWuOn8+eIdj0BUQk2TeAU7BzPBi3FxAmZ3zkN8=";
    };

    patches = [ ]; # TODO: Is it legal to clear the patches?

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/alsa/ucm2
      # Start with everything from the standard package
      cp -r ${pkgs.alsa-ucm-conf}/share/alsa/ucm2/* $out/share/alsa/ucm2/
      # Our $out is writable but the copied files inherit read-only permissions, fix that
      chmod -R u+w $out/share/alsa/ucm2

      # Overlay WeirdTreeThing files on top
      cp -r ucm2/* $out/share/alsa/ucm2/

      # Add name variant copies
      cp -r ucm2/conf.d/sof-rt5682 $out/share/alsa/ucm2/conf.d/sofrt5682
      cp -r ucm2/conf.d/sof-rt5682 $out/share/alsa/ucm2/conf.d/tgl_rt5682_def
      cp ucm2/conf.d/sof-rt5682/sof-rt5682.conf $out/share/alsa/ucm2/conf.d/sof-rt5682/Google-Voxel-rev3.conf
      cp ucm2/conf.d/sof-rt5682/sof-rt5682.conf $out/share/alsa/ucm2/conf.d/tgl_rt5682_def/Google-Voxel-rev3.conf

      runHook postInstall
    '';
  });
in
{
  boot = {
    extraModprobeConfig = ''
      options snd-intel-dspcfg dsp_driver=3
    '';
  };
  environment = {
    systemPackages = [ pkgs.sof-firmware ];
    sessionVariables.ALSA_CONFIG_UCM2 = "${cb-ucm-conf}/share/alsa/ucm2";
  };

  # # AUDIO SETUP FOR > 24.05
  # services.pipewire.wireplumber.configPackages = [
  #   (pkgs.writeTextDir "share/wireplumber/main.lua.d/51-increase-headroom.lua" ''
  #     rule = {
  #       matches = {
  #         {
  #           { "node.name", "matches", "alsa_output.*" },
  #         },
  #       },
  #       apply_properties = {
  #         ["api.alsa.headroom"] = 4096,
  #       },
  #     }

  #     table.insert(alsa_monitor.rules,rule)
  #   '')
  # ];

  # system.replaceRuntimeDependencies = [
  system.replaceDependencies.replacements = [
    {
      original = pkgs.alsa-ucm-conf;
      replacement = cb-ucm-conf;
    }
  ];
}
