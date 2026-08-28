# TODO

This roadmap tracks work after the initial extraction. Keep system-level setup
in `pre_script_setup.md` and user-level desktop changes in this repository.

## Phase 1: Test the Target System

- [ ] Complete the system preparation in `pre_script_setup.md`.
- [ ] Run `./install.sh --packages --no-services` on the target system.
- [ ] Confirm the official packages install with `pacman`.
- [ ] Confirm Walker, Elephant, and the configured providers build through `yay` or `paru`, and `herdr-bin` installs as a binary package.
- [ ] Enable Ly and verify the Hyprland session appears at login.
- [ ] Run `./install.sh` and verify the user services start.
- [ ] Test the launcher, terminal, notifications, audio, Bluetooth, Wi-Fi, screenshots, lock screen, and idle behavior.
- [ ] Reboot and confirm the configuration persists.

## Phase 2: Customize Dotfiles

- [ ] Customize Hyprland keybindings and window rules.
- [ ] Customize monitor and input settings for the target hardware.
- [ ] Customize Waybar modules, layout, and visibility.
- [ ] Customize Ghostty font, opacity, padding, and terminal behavior.
- [ ] Customize Walker and Elephant providers and search behavior.
- [ ] Customize Mako, SwayOSD, Hyprlock, and Hypridle settings.
- [ ] Document personal defaults without reintroducing dynamic theme state.
- [ ] Decide whether machine-specific overrides need a separate local file strategy.

## Phase 3: Hardware and System Integration

- [ ] Confirm CPU microcode, firmware, GPU drivers, and hardware acceleration.
- [ ] Confirm the selected network, DNS, and Bluetooth services.
- [ ] Configure and test the firewall policy.
- [ ] Decide whether Btrfs and Snapper are needed on the target system.
- [ ] Enable and authenticate Tailscale if required.
- [ ] Verify suspend, resume, external displays, audio devices, and brightness controls.

## Phase 4: Stabilize the Extraction

- [ ] Test the installer from a repository path outside the home directory.
- [ ] Test backup behavior when destination files already exist.
- [ ] Add a non-destructive package/configuration preflight check if useful.
- [ ] Verify package names and AUR build behavior on a fresh vanilla Arch install.
- [ ] Review optional applications and remove anything not needed for the target.
- [ ] Document recovery steps for failed configuration or package updates.
