#!/bin/zsh

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

# -------------------------------------------------------
# ------------------------ BRAVE ------------------------
# -------------------------------------------------------
echo "Trying to back up brave browser bookmarks..."
if [ -f $braveBrowserBookmarks ]; then
	echo "File found! Backing up..."
	cp $braveBrowserBookmarks "$braveBackupDirectory/bookmarks_$currentDate.html"
	if [ $? -eq 0 ]; then
		print_color $BOLD_GREEN "Done!"
	else
		print_color $BOLD_RED "Could not copy file."
	fi
else
	print_color $BOLD_RED "Files not found! Skipping..."
fi

# -------------------------------------------------------
# ------------------------- ZSH -------------------------
# -------------------------------------------------------
echo "Trying to back up zsh config..."
if [ -f $zshConfig ]; then
	echo "File found! Backing up..."
	cp $zshConfig "$zshBackupDirectory/.zshrc"
	if [ $? -eq 0 ]; then
		print_color $BOLD_GREEN "Done!"
	else
		print_color $BOLD_RED "Could not copy file."
	fi
else
	print_color $BOLD_RED "File not found! Skipping..."
fi

# -------------------------------------------------------
# ----------------------- VS Code -----------------------
# -------------------------------------------------------
echo "Trying to back up VS Code settings..."
if [ -f $vscodeSettings ]; then
	echo "File found! Backing up..."
	cp $vscodeSettings "$vsCodeBackupDirectory/settings.json"
	if [ $? -eq 0 ]; then
		print_color $BOLD_GREEN "Done!"
	else
		print_color $BOLD_RED "Could not copy file."
	fi
else
	print_color $BOLD_RED "File not found! Skipping..."
fi

echo "Trying to back up VS Code installed extensions..."
code --list-extensions >>"$vsCodeBackupDirectory/extensions.txt"
if [ $? -eq 0 ]; then
	print_color $BOLD_GREEN "Done!"
else
	print_color $BOLD_RED "Could save extensions."
fi
