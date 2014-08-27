local class = require("lib.hump.class")
local util = require("lib.self.util")

local map = util.math.map

local w_minigun = require("entities.weapons.minigun")
local weapon = class{__includes = w_minigun}

function weapon:init(arg)
	w_minigun.init(self, arg)
end

function weapon:start(host, world, pos, dir)
	self.barrel = -1

	w_minigun.start(self, host, world, pos, dir)
end

function weapon:fire(host, world, pos, dir)
	pos = pos + dir:perpendicular() * self.barrel * 10

	w_minigun.fire(self, host, world, pos, dir)

	self.barrel = self.barrel + 1
	if self.barrel > 1 then
		self.barrel = -1
	end
end


return weapon
