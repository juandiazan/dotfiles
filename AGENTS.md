# AGENTS.md​


## Project
Personal project for setting up a new machine with custom software and configurations. Used for installing software, backing up dotfiles and restoring a backup.
​

## Language/technologies

- Shellscript
- Backups are on JSON, JSONC, TOML or other formats
​

## Structure

backups/ — contains folders containing all important files to back up

src/ — contains the project's code
src/ui/ — contains functions used to show info on console
src/config/ — contains the logic for backing up files and restoring backups
src/pkg/ — contains the logic for detecting the package manager to use and installing programs

## Conventions

- All the software to install is located in src/pkg/packages.sh in a dictonary with format (software name, package name) 
- All the configs to back up and to restore are located in /src/config/configs.sh