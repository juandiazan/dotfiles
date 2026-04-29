#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
BACKUPS_DIR="$SETUP_DIR/.config"

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

create_dir_if_not_exists $BACKUPS_DIR

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
				if [[ "$choice" =~ ^[0-9]+$ ]]; then
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

	for target in "${SELECTED_BACKUPS[@]}"; do
		run_backup_for_target "$target"
	done
}

run_backup_for_target() {
	local target="$1"
	local backup_status=0

	print_color "$BOLD_PURPLE" "====> Trying to back up $target..."

	case "$target" in
		"zsh config")
			echo "$BACKUPS_DIR/zsh"
			create_dir_if_not_exists "$BACKUPS_DIR/zsh"
			backup_item "file" "$HOME/.zshrc" "$BACKUPS_DIR/zsh/.zshrc" || backup_status=1
		;;
		"kitty config")
			create_dir_if_not_exists "$BACKUPS_DIR/kitty"
			backup_item "directory" "$CONFIG_DIR/kitty" "$BACKUPS_DIR/kitty" || backup_status=1
		;;
		"starship config")
			create_dir_if_not_exists "$BACKUPS_DIR/starship"
			backup_item "file" "$CONFIG_DIR/starship.toml" "$BACKUPS_DIR/starship/starship.toml" || backup_status=1
		;;
		"fastfetch config")
			create_dir_if_not_exists "$BACKUPS_DIR/fastfetch"
			backup_item "file" "$CONFIG_DIR/fastfetch/config.jsonc" "$BACKUPS_DIR/fastfetch/config.jsonc" || backup_status=1
		;;
		"rofi config")
			create_dir_if_not_exists "$BACKUPS_DIR/rofi"
			backup_item "directory" "$CONFIG_DIR/rofi" "$BACKUPS_DIR/rofi" || backup_status=1
		;;
		"swaync config")
			create_dir_if_not_exists "$BACKUPS_DIR/rofi"
			backup_item "directory" "$CONFIG_DIR/swaync" "$BACKUPS_DIR/swaync" || backup_status=1
		;;
		"hypr and waybar for laptop")
			create_dir_if_not_exists "$BACKUPS_DIR/laptop-hypr-waybar"
			create_dir_if_not_exists "$BACKUPS_DIR/laptop-hypr-waybar/hypr"
			create_dir_if_not_exists "$BACKUPS_DIR/laptop-hypr-waybar/waybar"
			backup_item "directory" "$CONFIG_DIR/hypr" "$BACKUPS_DIR/laptop-hypr-waybar/hypr" || backup_status=1
			backup_item "directory" "$CONFIG_DIR/waybar" "$BACKUPS_DIR/laptop-hypr-waybar/waybar" || backup_status=1
		;;
		"hypr and waybar for pc")
			create_dir_if_not_exists "$BACKUPS_DIR/pc-hypr-waybar"
			create_dir_if_not_exists "$BACKUPS_DIR/pc-hypr-waybar/hypr"
			create_dir_if_not_exists "$BACKUPS_DIR/pc-hypr-waybar/waybar"
			backup_item "directory" "$CONFIG_DIR/hypr" "$BACKUPS_DIR/pc-hypr-waybar/hypr" || backup_status=1
			backup_item "directory" "$CONFIG_DIR/waybar" "$BACKUPS_DIR/pc-hypr-waybar/waybar" || backup_status=1
		;;
		"vscodium settings")
			create_dir_if_not_exists "$BACKUPS_DIR/vscodium"
			backup_item "file" "$CONFIG_DIR/VSCodium/User/settings.json" "$BACKUPS_DIR/vscodium/settings.json" || backup_status=1
		;;
		"vscodium extensions")
			create_dir_if_not_exists "$BACKUPS_DIR/vscodium"
			backup_vscodium_extensions || backup_status=1
		;;
		*)
			print_color "$BOLD_RED" "$target is not supported."
			return 1
		;;
	esac

	if [ "$backup_status" -eq 0 ]; then
		print_color "$BOLD_GREEN" "Successfully backed up $target."
	else
		print_color "$BOLD_RED" "Failed to back up $target."
	fi
	SELECTED_BACKUPS=()
}

backup_item() {
	local item_type="$1"
	local source_path="$2"
	local destination="$3"

	case "$item_type" in
		"file")
			if [ ! -f "$source_path" ]; then
				print_color "$BOLD_RED" "File not found: $source_path"
				return 1
			fi
			cp "$source_path" "$destination"
		;;
		"directory")
			if [ ! -d "$source_path" ]; then
				print_color "$BOLD_RED" "Directory not found: $source_path"
				return 1
			fi
			cp -r "$source_path"/. "$destination/"
		;;
		*)
			print_color "$BOLD_RED" "Unsupported backup type: $item_type"
			return 1
		;;
	esac
}

backup_vscodium_extensions() {
	echo "Trying to back up VSCodium installed extensions..."
	if ! command -v codium >/dev/null 2>&1; then
		print_color "$BOLD_RED" "VSCodium CLI (codium) not found. Skipping extensions backup."
		return 1
	fi

	codium --list-extensions >"$BACKUPS_DIR/vscodium/extensions.txt"
	if [ $? -eq 0 ]; then
		print_color "$BOLD_GREEN" "Saved VSCodium extensions list."
	else
		print_color "$BOLD_RED" "Could not save extensions."
		return 1
	fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	select_backups
fi
