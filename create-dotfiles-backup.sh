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
gitConfig="$HOME/.config/git/config"
waybarConfig="$HOME/.config/waybar/config.jsonc"
waybarStyle="$HOME/.config/waybar/style.css"
hyprlandConfig="$HOME/.config/hypr"

# dotfiles destinations
dotfilesBackupDir="$HOME/dotfiles"
braveBackupDirectory="$dotfilesBackupDir/brave-browser"
zshBackupDirectory="$dotfilesBackupDir/zsh-and-omz-config"
vsCodeBackupDirectory="$dotfilesBackupDir/vs-code"
gitBackupDirectory="$dotfilesBackupDir/git"
waybarConfigBackupDirectory="$dotfilesBackupDir/waybar"
hyprlandConfigBackupDirectory="$dotfilesBackupDir/hyprland"


# param 1 = color
# param 2 = text
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
create_dir_if_not_exists $gitBackupDirectory
create_dir_if_not_exists $waybarConfigBackupDirectory
create_dir_if_not_exists $hyprlandConfigBackupDirectory

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
			code --list-extensions >"$vsCodeBackupDirectory/extensions.txt"
			if [ $? -eq 0 ]; then
				print_color $BOLD_GREEN "Done!"
			else
				print_color $BOLD_RED "Could not save extensions."
			fi
		fi
		# end of vs code case
	
	elif [ -d $2 ]; then
		echo "Directory found! Backing up..."

		# hyprland config case
        if [ "$1" == "hyprland config" ]; then
            for confFile in $2/*.conf; do
                if [ -f "$confFile" ]; then
                    echo "Backing up $confFile..."
                    cp "$confFile" "$3/"
                    if [ $? -eq 0 ]; then
                        print_color $BOLD_GREEN "Successfully backed up $confFile!"
                    else
                        print_color $BOLD_RED "Failed to back up $confFile."
                    fi
                fi
            done
        fi
		# end of hyprland case

	else
		print_color $BOLD_RED "File not found. Could not create backup."
	fi
}

# backup_files "brave browser bookmarks" $braveBrowserBookmarks $braveBackupDirectory "bookmarks_$currentDate.html"
# backup_files "zsh config" $zshConfig $zshBackupDirectory ".zshrc"
# backup_files "VS Code settings" $vscodeSettings $vsCodeBackupDirectory "settings.json"
# backup_files "git user settings" $gitConfig $gitBackupDirectory "config"
backup_files "waybar config" $waybarConfig $waybarConfigBackupDirectory "config.jsonc"
backup_files "waybar style" $waybarStyle $waybarConfigBackupDirectory "style.css"
backup_files "hyprland config" $hyprlandConfig $hyprlandConfigBackupDirectory "hyprland.conf"
