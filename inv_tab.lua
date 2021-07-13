local FORMSIZE = {x = 8, y = 5}
local SCROLLBAR = {width = 0.3}

sfinv.register_page("server_cosmetics:customize", {
	title = "Customize",
	is_in_nav = function(self, player)
		return ctf_teams.get(player) and true or false
	end,
	get = function(self, player, context)
		local current = ctf_cosmetics.get_extra_clothing(player)
		local props = player:get_properties()
		local walk_anim = player_api.registered_models[props.mesh].animations.walk
		local cosmetics = ""
		local pos = 0

		if not context.customize then context.customize = {colors = {}} end

		for clothing, clist in pairs(server_cosmetics.default_cosmetics) do
			local colors = {}
			context.customize.colors[clothing] = {}
			local current_color_idx = 1
			local prefix = clist._prefix or "Enable "

			for colorname, color in pairs(clist) do
				if colorname:sub(1, 1) ~= "_" then
					if current[clothing] == color then
						current_color_idx = #colors + 1
					end

					table.insert(context.customize.colors[clothing], colorname)
					context.customize.colors[clothing][colorname] = color
					table.insert(colors, HumanReadable(colorname))
				end
			end

			cosmetics = string.format([[%s
				checkbox[0.1,%f;%s;%s;%s]
				dropdown[2.2,%f;2.3;%s;%s;%d;true]
				]], cosmetics,
				pos, clothing, prefix..HumanReadable(clothing), current[clothing] and "true" or "false",
				pos+0.09, clothing.."_color", table.concat(colors, ","), current_color_idx
			)

			pos = pos + 0.8
		end

		local form = string.format(
			[[
				formspec_version[4]
				box[0,-0.2;%f,%f;#00000055]
				model[0,0.1;%f,%f;playerview;%s;%s;{0,160};;;%f,%f]

				scrollbaroptions[min=0;max=%f]
				scrollbar[%f,0;%f,%f;vertical;cosmetics_scrollbar;0]
				scroll_container[%f,0;%f,%f;cosmetics_scrollbar;vertical;0.1]
					%s
				scroll_container_end[]
			]],
			(FORMSIZE.x/2) - 0.8, FORMSIZE.y,
			FORMSIZE.x/2, FORMSIZE.y, props.mesh, table.concat(props.textures, ","), walk_anim.x, walk_anim.y,

			7 * 9,
			FORMSIZE.x-SCROLLBAR.width, SCROLLBAR.width, FORMSIZE.y,
			(FORMSIZE.x/2 + 0.1), 6.2 - SCROLLBAR.width, 5.91,

			cosmetics
		)

		return sfinv.make_formspec(player, context, form, true)
	end,
	on_player_receive_fields = function(self, player, context, fields)
		local pteam = ctf_teams.get(player)

		if not pteam then return end
		if not context.customize then context.customize = {colors = {}} end

		for fieldname, color in pairs(fields) do
			local clothing = fieldname:match("(.+)_color")

			if clothing and context.customize.colors[clothing] then
				local new_extra = false
				color = context.customize.colors[clothing][tonumber(color) or 1]

				if fields[clothing] == "false" then
					new_extra = {_remove = {clothing}}
				elseif server_cosmetics.can_use(player, clothing, color) then
					local current = ctf_cosmetics.get_extra_clothing(player)

					if current[clothing] or fields[clothing] == "true" then
						new_extra = {[clothing] = context.customize.colors[clothing][color]}
					end
				end

				if new_extra then
					ctf_cosmetics.set_extra_clothing(player, new_extra)
					player:set_properties({textures = {ctf_cosmetics.get_colored_skin(player, ctf_teams.team[pteam].color)}})
				end
			end
		end
		sfinv.set_page(player, sfinv.get_page(player))
	end,
})

ctf_teams.register_on_allocplayer(function(player)
	sfinv.set_page(player, sfinv.get_page(player))
end)
