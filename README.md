# Arch Desktop Extraction

A small, user-level desktop layer for vanilla Arch Linux. It extracts the
useful desktop workflow from Omarchy without adopting Omarchy's distribution,
update system, theme engine, hardware detection, or installation machinery.

The default stack is:

- Hyprland
- Waybar
- Walker and Elephant
- SwayOSD
- Mako
- Hypridle and Hyprlock

This uses SwayOSD and SwayBG; it does not configure the Sway compositor.

The configs are intentionally static. There is no dynamic theme state and no
dependency on `~/.local/share/omarchy` or `~/.config/omarchy`.

## Install

Read [pre_script_setup.md](pre_script_setup.md) for the system-level Arch
preparation steps before running the installer.

Without `--packages`, the installer only changes files below the current
user's home directory. It backs up an existing destination before replacing it
with a symlink. The `--packages` option uses `sudo pacman` and, for AUR
packages, `yay` or `paru`.

```bash
./install.sh
```

To install the listed packages first:

```bash
./install.sh --packages
```

`--packages` installs `packages.txt` with `pacman`, then installs
`aur-packages.txt` with `yay` or `paru`. You can select a helper explicitly:

```bash
AUR_HELPER=paru ./install.sh --packages
```

Skip AUR packages with `./install.sh --packages --skip-aur`. Package names for
Walker and Elephant can vary by repository. If `pacman` cannot find one of
them, install the equivalent standalone packages from the repository or AUR
you use, then run `./install.sh` without `--packages`.

Services are enabled by default. Skip that step with:

```bash
./install.sh --no-services
```

Start Hyprland through your existing display manager or session launcher. This
project does not configure SDDM, Plymouth, boot loaders, kernels, or `/etc`.

## Included Workflow

- `Super+Space` opens the Walker application launcher.
- `Super+Ctrl+E` opens Walker's symbols provider.
- `Super+Ctrl+V` opens the clipboard provider.
- `Super+Return` opens a terminal in the active terminal's working directory.
- `Super+Shift+F` opens the file manager.
- `Super+Shift+B` opens the default browser.
- `Super+Shift+N` opens the configured editor.
- `Super+Shift+Space` toggles Waybar.
- `Super+Ctrl+I` toggles idle locking.
- `Super+Ctrl+O` opens the small system menu.
- `Super+Ctrl+L` locks the session.
- Print Screen starts the screenshot flow.
- Multimedia keys control audio and display brightness with SwayOSD.

The Hyprland bindings are split into files under `config/hypr/bindings/` so
application-specific bindings can be changed without touching the compositor
defaults.

## Defaults

Set these in the environment before launching Hyprland, or edit the launcher
scripts:

```bash
export DESKTOP_TERMINAL=alacritty
export DESKTOP_EDITOR=nvim
export DESKTOP_BROWSER=firefox
```

`xdg-terminal-exec` is preferred when it is installed. Otherwise the launcher
has direct support for Alacritty, Foot, Kitty, and Ghostty.

The installer adds `~/.local/bin` through
`~/.config/environment.d/desktop-extraction.conf`; log out and back in after
the first installation if the commands are not immediately available to your
session.

## Deliberately Omitted

- Omarchy's full menu and package installer
- Dynamic themes, backgrounds, branding, and generated theme files
- Omarchy update and migration logic
- First-run hooks and system-wide configuration
- Plymouth, SDDM, kernel, mirror, and hardware-specific setup
- Voxtype, web-app management, reminders, transcoding, and screen recording

Optional features can be added as local scripts without changing the core
configuration model.

## Dependencies

See `packages.txt` and `aur-packages.txt`. The launcher requires Walker,
Elephant, and the provider packages for application search, files, calculator,
symbols, and clipboard.
Audio, Bluetooth, and Wi-Fi panel bindings use Wiremix, Bluetui, and Impala.
`herdr` and Brave Origin are installed from the AUR as requested.
