local util = require("lib.self.util")

local circle = require("util.circle")

---

local circle_aabb = circle.aabb

---

local DEFAULT_BLAST_COLOR = {255, 255, 255}

---

return {
	systems = {
		{
			name = "UpdateBlast",
			requires = {"Position", "Blast"},
			update = function(entity, world, dt)
				local blast = entity.Blast

				if blast.radius and blast.duration and blast.func then
					blast.progress = blast.progress or 0
					blast.affected = blast.affected or {}

					---

					blast.progress = blast.progress + (dt/blast.duration)
					if blast.progress > 1 then
						entity.Blast = nil
						return
					end

					local current_radius = blast.progress * blast.radius

					for affected in pairs(world.hash:get_objects_in_range(
						circle_aabb(current_radius, entity.Position.x, entity.Position.y)))
					do
						if not blast.affected[affected] then
							local dist_vec = (affected.Position - entity.Position)
							local dir_vec = dist_vec:normalized()

							if affected.Radius then
								dist_vec = dist_vec - (dir_vec * affected.Radius)
							end
							local dist = dist_vec:len()

							local in_circle = 1 - (dist/current_radius)

							if in_circle > 0 then
								blast.affected[affected] = true

								local impact = 1 - (dist/blast.radius)
								blast.func(affected, impact, dir_vec)
							end
						end
					end
				end
			end
		},

		{
			name = "DrawBlast",
			requires = {"Position", "Blast"},
			draw = function(entity, world)
				local color = entity.Color or DEFAULT_BLAST_COLOR

				local cradius = entity.Blast.radius * entity.Blast.progress
				local fade = 1 - entity.Blast.progress

				love.graphics.setColor(color[1], color[2], color[3], fade * 255)
				love.graphics.circle("line", entity.Position.x, entity.Position.y, cradius)

				love.graphics.setColor(color[1], color[2], color[3], fade * 64)
				love.graphics.circle("fill", entity.Position.x, entity.Position.y, cradius)
			end
		}
	}
}
