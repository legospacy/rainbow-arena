## About
Rainbow Arena is a game that I've worked on on and off since 2014. The engine
is there, but gameplay is lacking. I have a terrible habit of not finishing
projects, but I hope to finish this one eventually.

This is the second version of Rainbow Arena, or equivalently the first rewrite.
The old version can be found on the `archive-v1` branch.


## Goals
The end goal is for Rainbow Arena to be a chaotic multiplayer arena shooter,
with all sorts of crazy weapons, from standard projectile weapons firing
standard bullets, to sticky bomb launchers, to beam lasers, to tractor beams.
Since multiplayer is hard and I have no experience with writing netcode, I may
create a singleplayer campaign first.


## History
I've been playing around with LÖVE for a few years now. What always happened
is that I would start making a game, but then the scope would grow far too much
and I would have to rewrite the game, either to fit in all the new ideas or
because it got too complicated and messy. I just kept rewriting games, not
really getting anywhere.

So one day, I decided that I would make a game where everything was a circle,
to make the collision detection and resolution code a lot easier. Thus, Rainbow
Arena was born! This was in 2014.

Of course, the game still got pretty complex, and it has been rewritten once
already (this is the first rewrite). ~~But now I'm pretty happy with the
underlying engine, and now I can concentrate more on the actual gamey bits.~~ Nope.
Now I want to rewrite it in Moonscript.

This is the second version of the game, started in February 2016. I wrote the
core engine back then, then took a long break. Now I work on it occasionally,
when I feel like it.

We'll see how it turns out.


## Technical information
### Overview
The underlying core to Rainbow Arena is an Entity-Component System, or ECS. It is supported by an event system, using the Observer pattern.

The game has always made good use of HUMP by vrld
(https://github.com/vrld/hump); for example `hump.vector` is used pervasively
throughout the game.

### Entity-Component Systems
`TODO: Explain ECSs and how the game uses them.`

### History
#### First version
In the initial version of Rainbow Arena, I rolled my own ECS, `ces.lua`, since I was in the mindset of doing most things myself. I think that was good in the long run, because it helped me understand ECSs. What wasn't good was that I avoided classes and object orientation as much as possible.

The event system complements the ECS well. It was (and still is) implemented with `hump.signal`.

#### Now
Currently, the ECS is handled by tiny-ecs. It has more flexibility than my own
system, and it's probably just better anyway. The event system still uses `hump.signal`.
