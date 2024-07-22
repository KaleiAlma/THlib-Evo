
lstg.plugin.RegisterEvent("afterTHlib", "Stage Background Extensions", 99, function()
    lstg.DoFile("THlib/background/spellcard/spellcard.lua")
    lstg.DoFile("THlib/background/temple/temple.lua")
end)
