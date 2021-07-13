server_cosmetics = {
	default_cosmetics = {
		hair = {
			black  = "#222",
			grey =   "#AAA",
			blonde = "#E6CC7C",
		},
		eyes = {
			green = "#477C47",
			brown = "#3E2A1A"
		}
	},
}

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
