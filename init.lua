server_cosmetics = {
	default_cosmetics = {
		hair = {
			brown  = "#472E16",
			black  = "#222"   ,
			grey   = "#AAA"   ,
			blonde = "#E6CC7C",
		},
		eyes = {
			blue  = "#2859C5",
			green = "#477C47",
			brown = "#2D1400",
		},
		skin = {
			_prefix = "Modify ",
			tan      = "#cca586",
			dark_tan = "#6d4832",
			brown    = "#412d1b",
		}
	},
}

local old = ctf_cosmetics.get_clothing_texture
function ctf_cosmetics.get_clothing_texture(player, texture, ...)
	if texture == "skin" then
		return "server_cosmetics_skin.png"
	else
		return old(player, texture, ...)
	end
end

minetest.register_on_joinplayer(function(player)
	local current = ctf_cosmetics.get_extra_clothing(player)

	if not current.hair then
		ctf_cosmetics.set_extra_clothing(player, {
			hair = server_cosmetics.default_cosmetics.hair["brown"],
			eyes = server_cosmetics.default_cosmetics.eyes["blue"],
		})
	end
end)

function server_cosmetics.can_use(player, clothing, color)
	if not color then return false end

	if server_cosmetics.default_cosmetics[clothing] and
	server_cosmetics.default_cosmetics[clothing][color] then
		return true
	else
		return false
	end
end

local function include(file)
	dofile(minetest.get_modpath(minetest.get_current_modname()).."/"..file)
end

include("inv_tab.lua")
