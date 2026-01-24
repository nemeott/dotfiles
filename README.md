# Dotfiles

## Bash

Contains my `.bashrc` and `.bash_aliases`, which dynamically check what extra tools are installed and output warning messages. Useful in case I forgot to install a certain tool and prevent bash initialization errors. The prompt also has a fun feature where the symbol (`$`) turns red on failed command execution.

## Obsidian

Contains my hand-crafted Latex Suite snippets, featuring named codeblocks, easy variable insertion outside of math mode, common math symbols, logical operators, set theory, probability, big O notation, units, calculus, and matrix snippets. All designed to be intuitive and easy to use, even with no prior knowledge of this config. Is also pretty well organized and commented. My hotkeys are also available.

# NixOS Config

Using Wayland/Niri/Noctalia as my main config, but also have a Cinnamon setup available in case of stability issues.

## Hosts

**`icarus`** - Acer Chromebook Spin 713 (CP713-3W)

- Uses a custom chromebook NixOS keyboard/audio fixer script `chrome-device.nix` from [https://github.com/dj1ch/nixos-chromebook](https://github.com/dj1ch/nixos-chromebook).
- I also wrote my own audio script `chrome-audio.nix` since the audio card was not being set correctly on boot. It uses a custom oneshot systemd startup script to set the card profile to a fallback option which works well on Cinnamon. It also sets the volume to 0 by default.
- Also wrote `chrome-bluetooth.nix` to solve my bluetooth issues with Niri and Noctalia. Set some custom keyboard shortcuts in Niri specifically for chromebook (should probably separate into a separate file when I add another computer).
