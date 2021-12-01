minetest.register_entity("server_cosmetics:santa_hat", {
	visual = "mesh",
	mesh = "server_cosmetics_santa_hat.b3d",
	textures = {"server_cosmetics_santa_hat.png"},
	physical = false,
	makes_footstep_sound = false,
	backface_culling = false,
	shaded = false,
	static_save = false,
	pointable = false,
	glow = 1,
	on_punch = function() return true end,
	on_step = function(self, dtime)
		self.timer = (self.timer or 0) + dtime
		if self.timer < 0.3 then return end
		self.timer = 0

		local player = self.object:get_attach()

		if not player or not player:is_player() then
			self.object:remove()
			return
		end

		local vel = player:get_velocity()
		local movement = vector.length(vel)

		if movement ~= 0 then
			if vel.y <= -12 then
				self.object:set_animation({x = 15, y = 23}, 34)
				return
			elseif movement ~= vel.y then
				self.object:set_animation({x = 1, y = 13}, 16)
				return
			end
		end

		self.object:set_animation({x = 1, y = 1}, 1)
	end
})