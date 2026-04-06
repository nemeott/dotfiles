# Dotfiles

This repository contains my configurations and helper scripts for NixOS, shells, editors, and other tools.

---

## Bash

Contains my `~/.bashrc` and `~/.bash_aliases` which:

- Dynamically check for installed tools to avoid initialization errors when tooling is missing.
- User-friendly prompt with a small visual indicator: the prompt symbol turns red on the last command failure.
- Some helpful convenience aliases and functions.

Files:

- `dotfiles/.bashrc`
- `dotfiles/.bash_aliases`

---

## Nix / NixOS

This repo contains a Nix flake for my NixOS configuration.

- `dotfiles/flake.nix` and `dotfiles/flake.lock` define the flake and its dependencies.
- `dotfiles/nixos-config` contains the full NixOS configuration tree, per-host directories, and modules.

### Hosts

Per-host configuration under `dotfiles/nixos-config/hosts`. Only have 1 host for now, until I add my other computer:

- `icarus` - Acer Chromebook Spin 713 (CP713-3W).

### Hardware and Fixes for `icarus`

I had to add/customize some hardware modules to make `icarus` behave correctly on NixOS:

- `hardware/chrome-device.nix` - Custom chromebook helper (based on community scripts) for improved keyboard/audio handling. Currently not using it since I am using PulseAudio, but was very useful in making my own fixes.
- `hardware/chrome-audio.nix` - Enable PulseAudio and use a startup systemd service to set a workable audio profile on boot.
- `hardware/chrome-bluetooth.nix` - Bluetooth fixes to work around rfkill / Noctalia toggling quirks.
- `hardware/chrome-keyboard.nix` - Custom keymap and quirks for Chromebook keyboard handling using keyd.

These are referenced/imported by the main config for the host at `dotfiles/nixos-config/hosts/icarus/configuration.nix`.

### Window Manager and Bar (Niri / Noctalia)

I primarily use Wayland with Niri + Noctalia. Configs and customizations are under:

- `dotfiles/niri` - Niri rules, keybindings, and device-specific tweaks.
- `dotfiles/noctalia` - Noctalia shell and bar configs.

There is also a Cinnamon setup available as a fallback on machines that need it.

---

## Obsidian

Contains my hand-crafted Latex Suite snippets, featuring named codeblocks, easy variable insertion outside of math mode, common math symbols, logical operators, set theory, probability, big O notation, units, calculus, and matrix snippets. All designed to be intuitive and easy to use, even with no prior knowledge of this config. Is also pretty well organized and commented. My hotkeys are also available.

Directory:

- `dotfiles/obsidian`

A helper script exists under `dotfiles/scripts` for copying hotkeys/snippets between nested vaults.

---

## Editors

Configurations and snippets for various editors:

- `dotfiles/vscode` - VS Code configuration.
- `dotfiles/zed` - Zed editor configuration.

---

## Scripts

A small `scripts` directory contains utilities I use to manage and propagate settings:

- `dotfiles/scripts/update_obsidian_shortcuts.sh`
  - Copies `hotkeys.json` and `snippets.ts` from a main vault into other vaults matching configured prefixes.
  - Configurable variables at the top of the script:
    - `MAIN_VAULT_PATH` - Where the source hotkeys/snippets live.
    - `HOTKEYS_RELATIVE_PATH` / `SNIPPETS_RELATIVE_PATH`.
    - `PREFIXES` - Which vault name prefixes to copy into.
  - Prompts for confirmation and prints a success count per vault.
- `dotfiles/scripts/add_wifi.sh` - Helper script for adding wifi entries in case no GUI available.
