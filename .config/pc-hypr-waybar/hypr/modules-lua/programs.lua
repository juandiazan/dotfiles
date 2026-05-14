--------------------
----- PROGRAMS -----
--------------------

--- PROGRAMS
local terminal = "kitty"
local fileManager = "nautilus"
local browser = "librewolf"

--- MENUS
local appMenu = "pkill rofi pkill rofi || bash ~/.config/rofi/launcher.sh"
local configsMenu = "pkill rofi || bash ~/dotfiles/scripts/change-config.sh"
local shutdownMenu = "pkill rofi || bash ~/dotfiles/scripts/shutdown-menu.sh"

--- UTILITIES
local restartWaybar = "pkill waybar; waybar &"
local reloadSwaync = "swaync-client -R && swaync-client -rs"
