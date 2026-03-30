#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
DOTFILES_DIR="$SETUP_DIR"

source "$SETUP_DIR/src/ui/colored_print.sh" || {
	echo "Failed to load print script."
	exit 1
}
source "$SETUP_DIR/src/ui/menus.sh" || {
	echo "Failed to load menu script."
	exit 1
}

source "$SCRIPT_DIR/configs.sh" || {
	echo "Failed to load config list."
	exit 1
}

current_date="$(date +%d-%m-%Y_%H:%M:%S)"

# ============= config locations =============
# git credentials are not backed up
zsh_config="$HOME/.zshrc"
kitty_config="$HOME/.config/kitty/kitty.conf"
starship_config="$HOME/.config/starship.toml"
fastfetch_config="$HOME/.config/fastfetch/config.jsonc"
rofi_config_dir="$HOME/.config/rofi"
# spicetify theme is not backed up
hyprland_config_dir="$HOME/.config/hypr" # for laptop (omarchy)
hypr_desktop_config="$HOME/.config/hypr/hyprland.conf" # for desktop (cachyos)

waybar_files_dir="$HOME/.config/waybar"
#browser bookmarks TODO
vscode_settings="$HOME/.config/Code/User/settings.json"
# ============= config locations =============


# ============= backup destinations =============
backups_root_dir="$DOTFILES_DIR/backups"

zsh_backup_dir="$backups_root_dir/zsh"
kitty_backup_dir="$backups_root_dir/kitty-config"
starship_backup_dir="$backups_root_dir/starship-config"
fastfetch_backup_dir="$backups_root_dir/fastfetch-config"
rofi_backup_dir="$backups_root_dir/rofi"
# spicetify theme is not backed up

# browser bookmarks TODO
vscode_backup_dir="$backups_root_dir/vs-code"

# for laptop (omarchy)
laptop_hypr_waybar_base="$backups_root_dir/laptop-hypr-waybar"
hyprland_laptop_backup_dir="$laptop_hypr_waybar_base/hypr" 
waybar_laptop_backup_dir="$laptop_hypr_waybar_base/waybar"

# for pc (cachy)
pc_hypr_waybar_base="$backups_root_dir/pc-hypr-waybar"
hyprland_pc_backup_dir="$pc_hypr_waybar_base/hypr" 
waybar_pc_backup_dir="$pc_hypr_waybar_base/waybar"

create_dir_if_not_exists() {
	if [ ! -d "$1" ]; then
		print_color "$BOLD_YELLOW" "Directory $1 not found. Creating..."
		mkdir -p "$1"
		if [ $? -eq 0 ]; then
			print_color "$BOLD_GREEN" "Created $1"
		else
			print_color "$BOLD_RED" "Could not create $1"
		fi
	fi
}
# ============= backup destinations =============

declare -a SELECTED_BACKUPS=()

select_backups() {
	while true; do
		clear
		show_backup_selection_menu
		read -p "Choice: " choice

		case "$choice" in
			"b")
				backup_selected
				break
			;;
			"c")
				SELECTED_BACKUPS=()
			;;
			"s")
				SELECTED_BACKUPS=("${BACKUP_TARGETS[@]}")
			;;
			"q")
				clear
				break
			;;
			*)
				if [[ "$choice" =~ ^[1-9]+$ ]]; then
					index=$((choice - 1))
					current_target="${BACKUP_TARGETS[$index]}"
					if [[ " ${SELECTED_BACKUPS[*]} " == *" $current_target "* ]]; then
						remove_from_selected "$current_target"
					else
						SELECTED_BACKUPS+=("$current_target")
					fi
				else
					print_color "$BOLD_RED" "Invalid option. Press enter to continue."
					read -p ""
				fi
			;;
		esac
	done
}

remove_from_selected() {
	new_selected=()
	for item in "${SELECTED_BACKUPS[@]}"; do
		[[ "$item" != "$1" ]] && new_selected+=("$item")
	done
	SELECTED_BACKUPS=("${new_selected[@]}")
}

show_backup_selection_menu() {
	echo "Select files/configurations to back up:"
	for i in "${!BACKUP_TARGETS[@]}"; do
		current_target="${BACKUP_TARGETS[$i]}"
		if [[ " ${SELECTED_BACKUPS[*]} " == *" $current_target "* ]]; then
			mark="[x]"
		else
			mark="[ ]"
		fi
		printf "%2d) %s %s\n" "$((i + 1))" "$mark" "$current_target"
	done
	backup_actions_menu
}

backup_selected() {
	if [ "${#SELECTED_BACKUPS[@]}" -eq 0 ]; then
		print_color "$BOLD_YELLOW" "No backup target selected."
		read -p "Press enter to continue."
		return
	fi

	create_dir_if_not_exists "$zsh_backup_dir"
	create_dir_if_not_exists "$kitty_backup_dir"
	create_dir_if_not_exists "$vscode_backup_dir"
	create_dir_if_not_exists "$starship_backup_dir"
	create_dir_if_not_exists "$fastfetch_backup_dir"
	create_dir_if_not_exists "$rofi_backup_dir"

	create_dir_if_not_exists "$hyprland_laptop_backup_dir"
	create_dir_if_not_exists "$waybar_laptop_backup_dir"

	create_dir_if_not_exists "$hyprland_pc_backup_dir"
	create_dir_if_not_exists "$waybar_pc_backup_dir"

	for target in "${SELECTED_BACKUPS[@]}"; do
		print_color "$BOLD_PURPLE" "=====> Backing up $target..."
		run_backup_for_target "$target"
	done
}

run_backup_for_target() {
	case "$1" in
		"zsh config")
			backup_file "$zsh_config" "$zsh_backup_dir" ".zshrc"
		;;
		"kitty config")
			backup_file "$kitty_config" "$kitty_backup_dir" "kitty.conf"
		;;
		"starship config")
			backup_file "$starship_config" "$starship_backup_dir" "starship.toml"
		;;
		"fastfetch config")
			backup_file "$fastfetch_config" "$fastfetch_backup_dir" "config.jsonc"
		;;
		"rofi config")
			backup_directory "rofi" "$rofi_config_dir" "$rofi_backup_dir"
		;;
		"hypr and waybar for laptop")
			backup_directory "hyprland laptop" "$hyprland_config_dir" "$hyprland_backup_dir"
			backup_directory "waybar laptop" "$waybar_files_dir" "$waybar_laptop_backup_dir"
		;;
		"hypr and waybar for pc")
			backup_directory "hyprland pc" "$hyprland_config_dir" "$hyprland_pc_backup_dir"
			backup_directory "waybar pc" "$waybar_files_dir" "$waybar_pc_backup_dir"
		;;
		"vs code settings and extensions")
			backup_file "$vscode_settings" "$vscode_backup_dir" "settings.json"
			backup_vscode_extensions
		;;
		*)
			print_color "$BOLD_RED" "$1 is not supported."
		;;
	esac
}

backup_file() {
	local source_file="$1"
	local destination_dir="$2"
	local output_name="$3"

	if [ ! -f "$source_file" ]; then
		print_color "$BOLD_RED" "File not found: $source_file"
		return
	fi

	cp "$source_file" "$destination_dir/$output_name"
	if [ $? -eq 0 ]; then
		print_color "$BOLD_GREEN" "Done!"
	else
		print_color "$BOLD_RED" "Could not copy file."
	fi
}

backup_directory() {
	local label="$1"
	local source_dir="$2"
	local destination_dir="$3"

	echo "Trying to back up $label config..."
	if [ ! -d "$source_dir" ]; then
		print_color "$BOLD_RED" "Directory not found: $source_dir"
		return
	fi

	cp -r "$source_dir"/. "$destination_dir/"
	if [ $? -eq 0 ]; then
		print_color "$BOLD_GREEN" "Successfully backed up $label directory."
	else
		print_color "$BOLD_RED" "Failed to back up $label directory."
	fi
}

backup_vscode_extensions() {
	echo "Trying to back up VS Code installed extensions..."
	if ! command -v code >/dev/null 2>&1; then
		print_color "$BOLD_RED" "VS Code CLI (code) not found. Skipping extensions backup."
		return
	fi

	code --list-extensions >"$vscode_backup_dir/extensions.txt"
	if [ $? -eq 0 ]; then
		print_color "$BOLD_GREEN" "Saved VS Code extensions list."
	else
		print_color "$BOLD_RED" "Could not save extensions."
	fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	select_backups
fi
