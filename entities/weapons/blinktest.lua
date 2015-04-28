local class = require("lib.hump.class")

---

local wepm_shotdelay = require("entities.weapons.modules.shotdelay")

---

local wep_blinktest = class{}

---

function wep_blinktest:can_fire(host, world)
	return wepm_shotdelay.can_fire(wep_blinktest, host, world)
end

---

function wep_blinktest:init()
	wepm_shotdelay.init(wep_blinktest, 1)
end

function wep_blinktest:update(host, world, dt)
	wepm_shotdelay.update(wep_blinktest, host, world, dt)
end

function wep_blinktest:fire(host, world)

end

function wep_blinktest:firing(host, world, dt)
	if self:can_fire(world) then
		host.ColorPulse = 1
		wepm_shotdelay.on_fire(wep_blinktest, host, world)
	end
end

function wep_blinktest:cease(self, host, world)

end

---

return wep_blinktest
