--------------------
----- MONITORS -----
--------------------
hl.monitor({
    output = "DP-3",
    mode = "1920x1080@144",
    position = "0x0",
    scale = "1"
})

hl.monitor({
    output = "HDMI-A-1",
    mode = "1920x1080@60",
    position = "1920x0",
    scale = "1",
    disabled = false
})

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "1"
})

for i = 1, 5 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "DP-3", persistent = true })
end

for i = 6, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1", persistent = true })
end
