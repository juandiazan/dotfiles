#!/bin/zsh

currentDate=`date +%d-%m-%Y_%H:%M:%S`

braveBrowserBookmarks="$HOME/.config/BraveSoftware/Brave-Browser/Default/Bookmarks"
zshConfig="$HOME/.zshrc"

dotfilesBackupDir="$HOME/dotfiles"
braveBackupDirectory="$dotfilesBackupDir/brave-browser"
zshBackupDirectory="$dotfilesBackupDir/zsh-and-omz-config"

BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
NO_COLOR='\033[0m'

print_color()
{
    echo -e $1$2$NO_COLOR
}

echo "-----------------------------"
echo "------ dotfile backup -------"
echo "-----------------------------"
echo "Backing up files..."

# -------------------------------------------------------
# ------------------------ BRAVE ------------------------
# -------------------------------------------------------
echo "Trying to back up brave browser bookmarks..."
if [ -f $braveBrowserBookmarks ]; then
    echo "File found! Backing up..."
    echo "."
    echo "."
    echo "."
    if [ -d $braveBackupDirectory ]; then
        cp $braveBrowserBookmarks "$braveBackupDirectory/bookmarks_$currentDate"
        if [ $? -eq 0 ]; then
            print_color $BOLD_GREEN "Done!"
        else
            print_color $BOLD_RED "Could not copy file."
        fi
    else
        print_color $BOLD_YELLOW "Directory not found. Trying to create..."
        mkdir -p $braveBackupDirectory
        if [ $? -eq 0 ]; then
            print_color $BOLD_GREEN "Directory created successfully."
            cp $braveBrowserBookmarks "$braveBackupDirectory/bookmarks_$currentDate"
            print_color $BOLD_GREEN "Done!"
        else
            print_color $BOLD_RED "Failed to create directory."
        fi
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
    echo "."
    echo "."
    echo "."
    if [ -d $zshBackupDirectory ]; then
        cp $zshConfig "$zshBackupDirectory/.zshrc"
        if [ $? -eq 0 ]; then
            print_color $BOLD_GREEN "Done!"
        else
            print_color $BOLD_RED "Could not copy file."
        fi
    else
        print_color $BOLD_YELLOW "Directory not found. Trying to create..."
        mkdir -p $zshBackupDirectory
        if [ $? -eq 0 ]; then
            print_color $BOLD_GREEN "Directory created successfully."
            cp $zshConfig "$zshBackupDirectory/.zshrc"
            print_color $BOLD_GREEN "Done!"
        else
            print_color $BOLD_RED "Failed to create directory."
        fi
    fi
else
    print_color $BOLD_RED "File not found! Skipping..."
fi