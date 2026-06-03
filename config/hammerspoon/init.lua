if not hs.fs.attributes(hs.configdir .. "/Spoons/EmmyLua.spoon/init.lua") then
    hs.execute("curl -fsSL https://raw.githubusercontent.com/Hammerspoon/Spoons/HEAD/Spoons/EmmyLua.spoon.zip -o /tmp/EmmyLua.spoon.zip && unzip -o /tmp/EmmyLua.spoon.zip -d " .. hs.configdir .. "/Spoons/ && rm /tmp/EmmyLua.spoon.zip")
end
hs.loadSpoon("EmmyLua")

require("keymaps")
require("202020")

HsConfigWatcher = hs.pathwatcher.new(hs.configdir, function(files) if hs.fnutils.some(files, function(f) return f:sub(-4) == ".lua" end) then hs.reload() end end):start()
hs.alert.show("Hammerspoon config loaded")
