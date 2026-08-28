# Pre-script Arch Setup

This document covers the operating-system preparation to complete before
running `./install.sh`. It is a companion to the [ArchWiki Installation
guide](https://wiki.archlinux.org/title/Installation_guide), not a replacement
for it.

The extraction installer is intentionally focused on the user-level desktop
configuration. It does not select hardware drivers, install a kernel, choose a
bootloader, configure `/etc`, create Btrfs snapshots, or set up a firewall.
Those choices belong to the Arch installation.

## 1. Install Arch

Use the latest official Arch Linux `x86_64` installation image. Arch is a
rolling-release distribution, so do not use an old image without updating it.
Verify the ISO signature before booting it.

Recommended choices for this project:

- UEFI and GPT partitioning
- A minimal `archinstall` profile or a manual installation
- The regular `linux` kernel unless you have a reason to use another kernel
- A normal, unprivileged user account for daily work
- A bootloader documented by the ArchWiki for your chosen filesystem

The official Arch installation image requires Secure Boot to be disabled unless
you have prepared your own signed boot chain. Secure Boot can be configured
later.

During a manual installation, the essential package set should include:

```text
base linux linux-firmware sudo git base-devel pciutils
```

Add exactly one CPU microcode package:

```text
# AMD CPU
amd-ucode

# Intel CPU
intel-ucode
```

The `linux-firmware` package covers common device firmware, but some hardware
needs an additional firmware package. Check the relevant ArchWiki hardware
page when a device is not working.

## Why Hardware Setup Is Manual

Arch uses `udev` and kernel modules to recognize and load drivers that are
already installed. It does not try to select every hardware-specific package
for the machine.

Omarchy adds its own `omarchy-hw-*` helpers and installation scripts that inspect
`lspci`, DMI information, `/sys`, and device IDs. Those scripts select packages
and apply workarounds for NVIDIA, Broadcom, Intel audio, ASUS, Surface, T2
Macs, and other supported hardware. They are useful for a distribution that
supports many machines, but they also modify system-level files and boot
configuration.

For one known machine, the traditional Arch approach is easier to audit and
maintain: use the ArchWiki page for the detected hardware, install the required
packages, and add only a workaround that the machine actually needs.

After the first boot, update the new system before installing the desktop:

```bash
sudo pacman -Syu
```

## 2. Network Setup

Choose one primary network-management approach. Do not enable multiple
services that attempt to manage the same interfaces.

This extraction includes `iwd` and uses `impala` for its Wi-Fi panel. `iwd`
handles Wi-Fi authentication, but the installed system still needs a complete
network configuration, including IP address and DNS handling. Configure `iwd`
with a compatible network service according to the
[ArchWiki Network configuration](https://wiki.archlinux.org/title/Network_configuration)
article.

Bluetooth support requires the `bluez` service and appropriate firmware. The
desktop package manifest includes the relevant desktop-side packages, but
system services and hardware exceptions remain system-level setup.

## 3. Hardware Drivers

Arch normally detects and loads kernel modules through `udev` during boot. It
does not automatically install every optional userspace driver package. Identify
hardware with:

```bash
lspci -nnk
lsusb
```

### Graphics

Use the [ArchWiki GPU installation guide](https://wiki.archlinux.org/title/Graphics_processing_unit#Installation)
and the page for the specific GPU vendor.

- AMD: install `mesa` and `vulkan-radeon`.
- Intel: install `mesa` and `vulkan-intel`; add Intel media-driver packages if hardware video acceleration is needed.
- NVIDIA: choose the driver matching both the GPU generation and installed kernel. Current supported cards commonly use `nvidia-open`, `nvidia-open-lts`, or `nvidia-open-dkms`; older cards may require a legacy package from the AUR.

For Wayland and Hyprland, do not install Xorg-only `xf86-video-*` packages
unless the relevant ArchWiki page specifically requires one. Do not install
the NVIDIA driver directly from NVIDIA's website. Use Arch packages so the
driver remains synchronized with kernel updates.

The extraction's package manifest does not contain GPU-specific driver
selection, kernel packages, CPU microcode, or all firmware variants. Install
those before bootstrapping the desktop.

### Hardware-specific exceptions

Most systems need no special handling beyond the kernel, firmware, microcode,
and graphics packages. For unusual laptops or devices, search the ArchWiki by
the exact model before copying a workaround from another distribution.

Common examples include Broadcom Wi-Fi, Intel SOF audio, hybrid NVIDIA
graphics, ASUS gaming laptops, Surface devices, and Apple T2 hardware.

## 4. Firewall

A firewall is not enabled automatically on Arch. For a simple desktop policy,
use `firewalld`, which manages the kernel's modern `nftables` framework:

```bash
sudo pacman -S firewalld
sudo systemctl enable --now firewalld
```

Start with the public zone and allow only services that you intentionally make
reachable. Do not run `ufw`, `firewalld`, and a separate hand-written
`nftables` ruleset at the same time. If you prefer direct rules and understand
the IPv4 and IPv6 policy, use `nftables` instead.

If Tailscale is installed later, review the firewall policy for the `tailscale0`
interface and allow only the services that should be reachable over Tailscale.
Tailscale encryption does not replace host firewall policy.

References:

- [ArchWiki Firewalls](https://wiki.archlinux.org/title/Firewalls)
- [ArchWiki Firewalld](https://wiki.archlinux.org/title/Firewalld)
- [ArchWiki Nftables](https://wiki.archlinux.org/title/Nftables)

## 5. Btrfs and Snapshots

Btrfs is a good choice for an Arch desktop when quick rollback after a system
update is valuable. It is not mandatory. Ext4 is simpler if you want fewer
filesystem and bootloader decisions.

Choose Btrfs during the initial installation rather than converting an
existing system solely to get snapshots. A practical layout is:

```text
@             mounted at /
@home         mounted at /home
@snapshots    mounted at /.snapshots
```

Use `compress=zstd` as a normal mount option. Keep `/home` separate so a root
rollback does not automatically revert personal files. Decide how `/var/log`,
database data, containers, and other frequently changing data should be
handled before creating snapshot policies.

Install the basic tools after the first boot:

```bash
sudo pacman -S btrfs-progs snapper snap-pac
```

`snapper` manages Btrfs snapshots. `snap-pac` adds pre/post snapshots around
`pacman` transactions. Configure the Snapper root and home subvolumes using
the [ArchWiki Snapper guide](https://wiki.archlinux.org/title/Snapper), then
enable the timeline and cleanup timers only after setting sensible limits.

Optional boot integration depends on the bootloader:

- GRUB: `grub-btrfs` and, optionally, `snap-pac-grub`
- Limine: `limine-snapper-sync`
- Other bootloaders: follow their specific ArchWiki integration guidance

Boot integration is optional. Snapshots can still be restored from an Arch
live environment. Snapshots are not backups: a failed disk can destroy the
live filesystem and every snapshot on it. Keep important files on another
disk or remote backup, and schedule periodic Btrfs scrubs.

References:

- [ArchWiki Btrfs](https://wiki.archlinux.org/title/Btrfs)
- [ArchWiki Btrfs snapshots](https://wiki.archlinux.org/title/Btrfs#Snapshots)
- [ArchWiki Snapper](https://wiki.archlinux.org/title/Snapper)

## 6. AUR Prerequisites

The extraction installs these requested applications from the AUR:

- `herdr`
- `brave-origin-bin`, the AUR package providing Brave Origin

The installer uses `yay` or `paru`. Install one before running the extraction.
Build an AUR helper as the regular user, never with `sudo makepkg`:

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si
```

Review AUR `PKGBUILD` files before building them. The extraction installer also
accepts an explicit helper:

```bash
AUR_HELPER=paru ./install.sh --packages
```

## 7. Login Manager (Ly)

The extraction does not install or configure a display manager. If you want the
text-based Ly login screen, install it as a system package and enable it on one
TTY. Replace `tty2` if you choose another TTY:

```bash
sudo pacman -S ly
sudo systemctl enable ly@tty2.service
sudo systemctl disable getty@tty2.service
```

Enable only one login manager. Ly will offer the installed Wayland sessions,
including Hyprland after the Hyprland package is installed. See the
[ArchWiki Ly guide](https://wiki.archlinux.org/title/Ly) for configuration and
TTY-specific details.

## 8. Bootstrap Order

Complete the system-level steps above first. Then, from the extraction
repository and as the normal user, install the desktop packages while deferring
user services:

```bash
./install.sh --packages --no-services
```

This installs the official packages from `packages.txt` with `pacman`, then
`herdr` and `brave-origin-bin` from `aur-packages.txt` through the selected AUR
helper. `neovim` is already in the official package manifest, along with
`tmux`, `tailscale`, and `ghostty`. Ghostty is the only terminal supported by
the extraction's launcher scripts.

After confirming the packages and hardware work, enable the extraction's user
services:

```bash
./install.sh
```

The installer does not configure a display manager, bootloader, kernel,
firewall, Tailscale authentication, or Btrfs rollback policy.

For Tailscale, enable and authenticate it separately when ready:

```bash
sudo systemctl enable --now tailscaled
sudo tailscale up
```

## Useful References

- [ArchWiki Installation guide](https://wiki.archlinux.org/title/Installation_guide)
- [ArchWiki General recommendations](https://wiki.archlinux.org/title/General_recommendations)
- [ArchWiki Microcode](https://wiki.archlinux.org/title/Microcode)
- [ArchWiki Hardware video acceleration](https://wiki.archlinux.org/title/Hardware_video_acceleration)
- [ArchWiki System backup](https://wiki.archlinux.org/title/System_backup)
