--------------------
----- PROGRAMS -----
--------------------

--- PROGRAMS
local terminal = "kitty"

---------------------
----- AUTOSTART -----
---------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar & ckb-next & swaync & hypridle & hyprpaper")
    hl.exec_cmd("rfkill unblock bluetooth")
end)
