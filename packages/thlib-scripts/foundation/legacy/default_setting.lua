
---@class legacy.default_setting.player_keys
local p1 = {
	up = KEY.Up,
	down = KEY.Down,
	left = KEY.Left,
	right = KEY.Right,
	slow = KEY.LeftShift,
	shoot = KEY.Z,
	spell = KEY.X,
	special = KEY.C,
}

---@type legacy.default_setting.player_keys
local p2 = {
	up = KEY.NumPad5,
	down = KEY.NumPad2,
	left = KEY.NumPad1,
	right = KEY.NumPad3,
	slow = KEY.A,
	shoot = KEY.S,
	spell = KEY.D,
	special = KEY.F,
}

---@class legacy.default_setting.system_keys
local sys = {
	repfast = KEY.LeftControl,
	repslow = KEY.LeftShift,
	menu = KEY.Escape,
	snapshot = KEY.Home,
	retry = KEY.R,
}

---@class legacy.default_setting
default_setting = {
	username = 'User',
	locale = "en_us",
	timezone = 8,
	resx = 640,
	resy = 480,
	windowed = true,
	vsync = false,
	sevolume = 100,
	bgmvolume = 100,
	keys = p1,
	keys2 = p2,
	keysys = sys,
}

return default_setting
