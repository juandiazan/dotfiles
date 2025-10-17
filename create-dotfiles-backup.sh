#!/bin/zsh

currentDate=`date +%D_%H:%M:%S`

braveBrowserBookmarks="$HOME/.config/BraveSoftware/Brave-Browser/Default/Bookmarks"
zshConfig="$HOME/.zshrc"

dotfilesBackupDir="$HOME/dotfiles"
braveBackupDirectory="$dotfilesBackupDir/brave-browser"
zshBackupDirectory="$dotfilesBackupDir/zsh-omz"

BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
NO_COLOR='\033[0m'

print_color()
{
    echo -e "$1$2$NO_COLOR"
}

echo "-----------------------------"
echo "------ dotfile backup -------"
echo "-----------------------------"

echo "Backing up files..."

echo "Trying to back up brave browser bookmarks..."
if [ -f "$braveBrowserBookmarks" ]; then
    echo "File found! Backing up..."
    echo "."
    echo "."
    echo "."
    if [ -d "$braveBackupDirectory"]; then
        # cp $braveBrowserBookmarks $braveBackupDirectory/"bookmarks_$currentDate"
        print_color BOLD_GREEN "Done!"
    else
        print_color BOLD_YELLOW "Directory not found! Creating..."
        # create directory
    fi
else
    print_color BOLD_RED "Files not found! Skipping..."
fi

echo "Trying to back up zsh config..."
if [ -f $zshConfig ]; then
    echo "File found! Backing up..."
    echo "."
    echo "."
    echo "."
    if [ -d "$zshBackupDirectory" ]; then
        # cp $zshConfig ./zsh-omz/zsh-config
        print_color BOLD_GREEN "Done!"
    else
        print_color BOLD_YELLOW "Directory not found! Creating..."
        # create directory
    fi
else
    print_color BOLD_RED "File not found! Skipping..."
fi