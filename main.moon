-- Rainbow Arena, a game by Mirrexagon.
--
-- The code is under the MIT license (see `LICENSE-MIT`).
--
-- Sounds, music, and graphics are under the Creative Commons CC-BY 4.0 license (see `LICENSE-CC-BY-4.0`).
-- - Sound effects made with Bfxr (http://www.bfxr.net) and Audacity (http://www.audacityteam.org).
-- - Music made by me; see https://lmirx.net
--
-- Note that parts NOT made by me remain the property of their respective authors; these parts include:
-- - lib/hump is HUMP by vrld (https://github.com/vrld/hump)
-- - lib/tiny.lua is tiny-ecs by bakpakin (https://github.com/bakpakin/tiny-ecs)


love.load = ->


love.update = (dt) ->
    print dt

love.draw = ->
    love.graphics.setColor 1, 1, 1
    love.graphics.circle "line", 300, 300, 30
    love.graphics.print "Potato", 100, 100
