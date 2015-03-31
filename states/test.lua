local test = {}

---

local vector = require("lib.hump.vector")
local screenshake = require("lib.self.screenshake")
local util = require("lib.self.util")

local circle = require("util.circle")
local color = require("util.color")

local World = require("logic.world")

---

local circle_colliding = circle.colliding
local table_nelem = util.table.nelem

---

local PLAYER_RADIUS = 30

SOUND_POSITION_SCALE = 256

---

local world

function test:init()
	world = World.new()
	world:load_system_dir("systems")
end

local function generate_position(radius)

	local angle = love.math.random() * 2*math.pi
	local magnitude = love.math.random(0, world.r)

	return vector.new(
		magnitude * math.cos(angle),
		magnitude * math.sin(angle)
	)
end

local function find_position(radius, tries)
	for try = 1, tries or 10 do
		local ok = true

		local pos = generate_position(radius)
		for entity in pairs(world:get_entities_with{"Position", "Radius"}) do
			if circle_colliding(pos,radius, entity.Position,entity.Radius) then
				ok = false
				break
			end
		end

		if ok then return pos end
	end
end

-- https://stackoverflow.com/questions/667034/simple-physics-based-movement
local function calculate_drag_accel(max_speed, accel_time)
	local drag = 5/accel_time -- drag = 5/t_max
	local accel = max_speed * drag -- acc = v_max * drag
	return drag, accel
end

function test:enter(previous, w, h, nbots)
	world:clear_entities()

	world.r = r or 600

	local c_drag, c_accel = calculate_drag_accel(800, 5)

	local proj = require("entities.miniturret"){
		drag = c_drag,

		weapon = require("entities.weapons.minigun"){
			projectile = require("entities.projectiles.bullet")(),
			shot_sound = "audio/weapons/laser_shot.wav"
		}
	}

	local weapon = require("entities.weapons.projectile"){
		max_heat = 3,
		shot_heat = 0.01,

		kind = "single",
		projectile = proj,
		projectile_speed = 300,
		shot_delay = 1,

		shot_sound = "audio/weapons/laser_shot.wav"
	}

	local combatant = require("entities.combatant")

	world:spawn_entity(combatant{
		team = "Player",
		player = true,

		position = find_position(PLAYER_RADIUS),

		radius = PLAYER_RADIUS,
		color = {255, 255, 255},
		health = 30,

		drag = c_drag,
		move_acceleration = c_accel,

		weapon = require("entities.weapons.minigun"){
			projectile = require("entities.projectiles.bullet")(),
			shot_sound = "audio/weapons/laser_shot.wav"
		}
	})

	-- Place test balls.
	for n = 1, 50 do
		local color = {color.hsv_to_rgb(love.math.random(0, 359), 255, 255)}

		world:spawn_entity(combatant{
			name = "Ball " .. n,
			team = "Enemy",

			position = find_position(PLAYER_RADIUS),

			radius = PLAYER_RADIUS,
			color = color,
			health = 30,

			drag = c_drag,
			move_acceleration = c_accel
		})
	end
end

function test:update(dt)
	world:update(dt)
end

function test:draw()
	world:draw{
		ui = function(self)
			love.graphics.setColor(255, 255, 255)
			love.graphics.print("Speed multiplier: " .. self.speed, 10, 10)
			love.graphics.print(
				"Entities: " .. table_nelem(self.entities),
				10, 10 + love.graphics.getFont():getHeight()
			)
		end
	}
end


function test:keypressed(key, isrepeat)
	world:emit_event("KeyPressed", key, isrepeat)
end

function test:keyreleased(key)
	world:emit_event("KeyReleased", key)
end

function test:mousepressed(x, y, b)
	if b == "wd" then
		world.speed = world.speed - 0.1
	elseif b == "wu" then
		world.speed = world.speed + 0.1
	end

	world:emit_event("MousePressed", x, y, b)
end

function test:mousereleased(x, y, b)
	world:emit_event("MouseReleased", x, y, b)
end

return test
