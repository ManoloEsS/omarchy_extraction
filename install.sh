#!/bin/bash

set -euo pipefail

REPO_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
CONFIG_DIR="$HOME/.config"
BIN_DIR="$HOME/.local/bin"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/desktop-extraction"
BACKUP_STAMP=$(date +%s)
INSTALL_PACKAGES=false
INSTALL_SERVICES=true
INSTALL_AUR=true

usage() {
  cat <<USAGE
Usage: $0 [--packages] [--no-services] [--skip-aur]

  --packages       Install packages.txt with pacman and aur-packages.txt with yay or paru.
  --no-services    Do not enable the user services.
  --skip-aur       Install only packages.txt; skip AUR packages.
USAGE
}

warn() {
  printf 'Warning: %s\n' "$*" >&2
}

while (( $# > 0 )); do
  case $1 in
    --packages) INSTALL_PACKAGES=true ;;
    --no-services) INSTALL_SERVICES=false ;;
    --skip-aur) INSTALL_AUR=false ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 1 ;;
  esac
  shift
done

install_packages() {
  command -v pacman >/dev/null 2>&1 || {
    printf 'pacman is required for --packages\n' >&2
    exit 1
  }

  mapfile -t packages < <(sed -e 's/[[:space:]]*#.*$//' -e '/^[[:space:]]*$/d' "$REPO_DIR/packages.txt")
  sudo pacman -S --needed "${packages[@]}"

  if [[ $INSTALL_AUR == true ]]; then
    install_aur_packages
  fi
}

install_aur_packages() {
  local aur_helper="${AUR_HELPER:-}"

  if [[ -z $aur_helper ]]; then
    if command -v yay >/dev/null 2>&1; then
      aur_helper=yay
    elif command -v paru >/dev/null 2>&1; then
      aur_helper=paru
    fi
  fi

  if [[ -z $aur_helper ]] || ! command -v "$aur_helper" >/dev/null 2>&1; then
    printf 'An AUR helper is required for aur-packages.txt. Install yay or paru, or rerun with --skip-aur.\n' >&2
    exit 1
  fi

  mapfile -t aur_packages < <(sed -e 's/[[:space:]]*#.*$//' -e '/^[[:space:]]*$/d' "$REPO_DIR/aur-packages.txt")
  "$aur_helper" -S --needed "${aur_packages[@]}"
}

backup_destination() {
  local destination="$1"

  if [[ -e $destination || -L $destination ]]; then
    mv -- "$destination" "$destination.bak.$BACKUP_STAMP"
    printf 'Backed up %s to %s.bak.%s\n' "$destination" "$destination" "$BACKUP_STAMP"
  fi
}

link_file() {
  local source="$1"
  local destination="$2"

  mkdir -p -- "$(dirname -- "$destination")"

  if [[ -L $destination ]] && [[ $(readlink -- "$destination") == "$source" ]]; then
    return
  fi

  backup_destination "$destination"
  ln -s -- "$source" "$destination"
}

install_config() {
  local relative_path
  local source
  local destination

  config_files=(
    config/hypr/hyprland.conf
    config/hypr/autostart.conf
    config/hypr/envs.conf
    config/hypr/input.conf
    config/hypr/looknfeel.conf
    config/hypr/monitors.conf
    config/hypr/windows.conf
    config/hypr/apps.conf
    config/hypr/hypridle.conf
    config/hypr/hyprlock.conf
    config/hypr/hyprsunset.conf
    config/hypr/xdph.conf
    config/hypr/bindings.conf
    config/hypr/bindings/apps.conf
    config/hypr/bindings/clipboard.conf
    config/hypr/bindings/media.conf
    config/hypr/bindings/tiling.conf
    config/hypr/bindings/utilities.conf
    config/environment.d/desktop-extraction.conf
    config/ghostty/config
    config/waybar/config.jsonc
    config/waybar/style.css
    config/walker/config.toml
    config/walker/themes/desktop/style.css
    config/walker/themes/desktop/layout.xml
    config/elephant/calc.toml
    config/elephant/desktopapplications.toml
    config/elephant/symbols.toml
    config/swayosd/config.toml
    config/swayosd/style.css
    config/mako/config
    config/systemd/user/desktop-elephant.service
    config/systemd/user/desktop-walker.service
    config/systemd/user/desktop-swayosd.service
  )

  for relative_path in "${config_files[@]}"; do
    source="$REPO_DIR/$relative_path"
    destination="$CONFIG_DIR/${relative_path#config/}"
    link_file "$source" "$destination"
  done

  mkdir -p -- "$STATE_DIR"
}

install_commands() {
  local script
  local name

  mkdir -p -- "$BIN_DIR"

  for script in "$REPO_DIR"/bin/*; do
    [[ -f $script ]] || continue
    name=$(basename -- "$script")
    link_file "$script" "$BIN_DIR/$name"
  done
}

install_services() {
  command -v systemctl >/dev/null 2>&1 || {
    warn "systemctl was not found; user services were not enabled"
    return
  }

  systemctl --user daemon-reload

  if command -v elephant >/dev/null 2>&1; then
    systemctl --user enable --now desktop-elephant.service || warn "could not start desktop-elephant.service"
  else
    warn "elephant is not installed; Walker application providers will not work"
  fi

  if command -v walker >/dev/null 2>&1; then
    systemctl --user enable --now desktop-walker.service || warn "could not start desktop-walker.service"
  else
    warn "walker is not installed"
  fi

  if command -v swayosd-server >/dev/null 2>&1; then
    systemctl --user enable --now desktop-swayosd.service || warn "could not start desktop-swayosd.service"
  else
    warn "swayosd is not installed; multimedia OSD will not work"
  fi
}

if [[ $INSTALL_PACKAGES == true ]]; then
  install_packages
fi

install_config
install_commands

if [[ $INSTALL_SERVICES == true ]]; then
  install_services
fi

printf '\nInstalled Arch Desktop Extraction into %s\n' "$REPO_DIR"
printf 'Restart Hyprland or reload its configuration to apply it.\n'
