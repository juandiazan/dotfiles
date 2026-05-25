# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Running the project

```bash
./setup.sh
```

Interactive menu with three options: install software (1), apply configs (2), backup configs (3).

## Architecture

The project is pure Bash. `setup.sh` is the entry point — it sources all modules and runs `main_menu` in a loop.

**Module layout:**

- `src/ui/colored_print.sh` — color constants (`BOLD_RED`, `BOLD_GREEN`, etc.) and `print_color <color> <text>`
- `src/ui/menus.sh` — static menu renderers (no logic)
- `src/pkg/detect-package-manager.sh` — `detect_pkg_manager` (pacman/apt/dnf) and `detect_aur_helper` (yay/paru)
- `src/pkg/packages.sh` — four category arrays (`PROGRAMS_APPS`, `PROGRAMS_DEV`, `PROGRAMS_TUI`, `PROGRAMS_CUSTOMIZATION`) + `PACKAGES` associative array mapping display name → package name
- `src/pkg/install-packages.sh` — interactive selector and installer; for Arch it tries pacman first then falls back to the AUR helper
- `src/config/configs.sh` — `CONFIGS` (all apply-able configs) and `BACKUP_TARGETS` (subset that can be backed up)
- `src/config/apply-configs.sh` — interactive selector + `apply_selected_configs` (giant case statement, one branch per config name)
- `src/config/backup-configs.sh` — interactive selector + `backup_selected` / `run_backup_for_target` (another case statement)

**Backup store:** `.config/` inside this repo is the backup destination. `BACKUPS_DIR` in both config scripts resolves to `<repo-root>/.config`.

## Key conventions

**Adding a new package** — two places in `src/pkg/packages.sh`:
1. Add the display name to the appropriate category array (`PROGRAMS_APPS`, `PROGRAMS_DEV`, `PROGRAMS_TUI`, or `PROGRAMS_CUSTOMIZATION`)
2. Add `[display_name]="pkg_name"` to `PACKAGES`

Special install logic (like oh-my-zsh or spicetify) goes in the `case` block inside `install_selected_software` in `src/pkg/install-packages.sh`.

**Adding a new config** — three places:
1. Add the name string to `CONFIGS` in `src/config/configs.sh` (and optionally `BACKUP_TARGETS` if it should be back-up-able)
2. Add a `case` branch in `apply_selected_configs` (`src/config/apply-configs.sh`) that copies from `$BACKUPS_DIR/<subdir>` to the live location
3. Add a matching `case` branch in `run_backup_for_target` (`src/config/backup-configs.sh`) that copies the live file(s) into `$BACKUPS_DIR/<subdir>`

The config name string must be identical across all three files — it's used as the key everywhere.

**Path resolution:** every script resolves its own `SCRIPT_DIR` via `"$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"` and then derives `SETUP_DIR` (repo root) relative to that. Never use relative paths directly.
