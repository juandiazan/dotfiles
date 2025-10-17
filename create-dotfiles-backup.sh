#!/bin/bash

# utilities
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_PURPLE='\033[1;35m'
NO_COLOR='\033[0m'
currentDate=$(date +%d-%m-%Y_%H:%M:%S)
getVsCodeExtensions=$(code --list-extensions)

# dotfiles locations
braveBrowserBookmarks="$HOME/.config/BraveSoftware/Brave-Browser/Default/Bookmarks"
zshConfig="$HOME/.zshrc"
vscodeSettings="$HOME/.config/Code/User/settings.json"

# dotfiles destinations
dotfilesBackupDir="$HOME/dotfiles"
braveBackupDirectory="$dotfilesBackupDir/brave-browser"
zshBackupDirectory="$dotfilesBackupDir/zsh-and-omz-config"
vsCodeBackupDirectory="$dotfilesBackupDir/vs-code"

print_color() {
	echo -e $1$2$NO_COLOR
}

create_dir_if_not_exists() {
	if [ ! -d $1 ]; then
		print_color $BOLD_YELLOW "Directory $1 not found. Creating..."
		mkdir -p $1
		print_color $BOLD_GREEN "Created $1"
	fi
}

print_color $BOLD_PURPLE "-----------------------------"
print_color $BOLD_PURPLE "------ dotfile backup -------"
print_color $BOLD_PURPLE "-----------------------------"

create_dir_if_not_exists $braveBackupDirectory
create_dir_if_not_exists $zshBackupDirectory
create_dir_if_not_exists $vsCodeBackupDirectory

echo "Backing up files..."

# Param 1 = name of what is being backed up
# Param 2 = backup origin (file)
# Param 3 = backup destination directory
# Param 4 = name of new file
backup_files() {
	echo "Trying to back up $1..."
	if [ -f $2 ]; then
		echo "File found! Backing up..."
		cp $2 "$3/$4"
		if [ $? -eq 0 ]; then
			print_color $BOLD_GREEN "Done!"
		else
			print_color $BOLD_RED "Could not copy file."
		fi

		# vs code files case; also get vs code extensions
		if [ "$1" == "VS Code settings" ]; then
			echo "Trying to back up VS Code installed extensions..."
			code --list-extensions >>"$vsCodeBackupDirectory/extensions.txt"
			if [ $? -eq 0 ]; then
				print_color $BOLD_GREEN "Done!"
			else
				print_color $BOLD_RED "Could save extensions."
			fi
		fi
	fi
}

backup_files "brave browser bookmarks" $braveBrowserBookmarks $braveBackupDirectory "bookmarks_$currentDate.html"
backup_files "zsh config" $zshConfig $zshBackupDirectory ".zshrc"
backup_files "VS Code settings" $vscodeSettings $vsCodeBackupDirectory "settings.json"
