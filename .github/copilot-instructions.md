# Copilot Instructions for Dotfiles Repository

## Project Overview

This is a personal dotfiles and system setup project for configuring a new machine. It provides tools for:
- Installing software with automatic package manager detection
- Backing up important configuration files
- Restoring configurations from backups

## Technology Stack

- **Language**: Bash/Shell Script
- **Backup Formats**: JSON, JSONC, TOML, and other configuration formats

## Project Structure

```
backups/          - Folders containing all important files to back up
src/
  ├── ui/        - Console display functions (colored output, menus)
  ├── config/    - Logic for backing up and restoring configuration files
  └── pkg/       - Logic for detecting package managers and installing programs
setup.sh          - Main entry point with interactive menu system
```

## Key Conventions

### Adding New Software to Install

All software to install is defined in `src/pkg/packages.sh` as a bash associative array with the format:
```bash
[display_name]="package_name"
```

Example:
```bash
declare -A PACKAGES=(
    [librewolf]="librewolf-bin"
    [discord]="discord"
    [zsh]="zsh"
)
```

### Adding New Configurations to Back Up/Restore

All configurations are listed in `src/config/configs.sh`:
- `CONFIGS` array: All available configurations for applying/restoring
- `BACKUP_TARGETS` array: Configurations that can be backed up

Example structure:
```bash
CONFIGS=(
    "zsh config"
    "kitty config"
    "starship config"
)

BACKUP_TARGETS=(
    "zsh config"
    "kitty config"
)
```

Configuration file paths are defined in `src/config/backup-configs.sh` using variables like:
```bash
zsh_config="$HOME/.zshrc"
kitty_config="$HOME/.config/kitty/kitty.conf"
```

## UI Module

The `src/ui/colored_print.sh` module provides consistent console output:
- `BOLD_RED`, `BOLD_GREEN`, `BOLD_YELLOW`, `BOLD_PURPLE`, `NO_COLOR` color constants
- `print_color()` function for colored output

Usage:
```bash
source "$SCRIPT_DIR/src/ui/colored_print.sh"
print_color $BOLD_GREEN "Success message"
```

## Running the Project

Execute the main setup script:
```bash
./setup.sh
```

This opens an interactive menu with three main options:
1. Install software
2. Apply configurations
3. Backup configurations

## Package Manager Detection

The system automatically detects the available package manager:
- **Arch Linux**: `pacman` (with optional `yay` or `paru` AUR helper)
- **Debian/Ubuntu**: `apt`
- **Fedora/RHEL**: `dnf`
- Falls back to "unsupported" if none are detected

Detection logic is in `src/pkg/detect-package-manager.sh`.
