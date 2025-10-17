#!/bin/zsh

dotfilesBackupDir="$HOME/dotfiles"
braveBrowserBookmarks="$HOME/.config/BraveSoftware/Brave-Browser/Default/Bookmarks"
zshConfig="$HOME/.zshrc"

braveBackupDirectory="$HOME/dotfiles/brave-browser"
zshBackupDirectory="$HOME/dotfiles/zsh-omz"

BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
NO_COLOR='\033[0m'

print_red()
{
    echo -e "$BOLD_RED$1$NO_COLOR"
}

print_green()
{
    echo -e "$BOLD_GREEN$1$NO_COLOR"
}

echo "-----------------------------"
echo "------ dotfile backup -------"
echo "-----------------------------"

echo -e "Backing up files..."

echo "Trying to back up brave browser bookmarks..."
if [ -f "$braveBrowserBookmarks" ]; then
    echo "File found! Backing up..."
    echo "."
    echo "."
    echo "."
    # copia lo que esta en la ruta a un archivo llamado "brave_bookmarks" en el directorio actual
    # checkear que si el directorio no existe lo cree
    # cp $braveBrowserBookmarks ./brave/brave_bookmarks
    if [ -d ""]
    print_green "Done!"
else
    print_red "File not found! Skipping..."
fi

echo "Trying to back up zsh config..."
if [ -f $zshConfig ]; then
    echo "File found! Backing up..."
    echo "."
    echo "."
    echo "."
    # checkear que si el directorio no existe lo cree
    # cp $zshConfig ./zsh-omz/zsh-config
    print_green "Done!"
else
    print_red "File not found! Skipping..."
fi