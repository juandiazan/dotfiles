--------------------
----- PROGRAMS -----
--------------------

--- PROGRAMS
local terminal = "kitty"

---------------------
----- AUTOSTART -----
---------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar & ckb-next & swaync & hypridle & hyprpaper & hyprsunset &")
    hl.exec_cmd("rfkill unblock bluetooth")
    hl.exec_cmd("ags run")
end)
