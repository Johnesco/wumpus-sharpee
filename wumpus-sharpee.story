## Hunt the Wumpus - a Sharpee/Chord treatment of the 1973 BASIC game.
##
## The cave is a five-by-five lattice with eleven tunnels cut out of it and six
## diagonal shafts added, so no room is where its coordinates say it should be
## and the map is worth drawing. Every room has a different set of neighbours,
## which is what makes the wumpus findable: blood in a room means the wumpus is
## in one of that room's neighbours, so no two rooms can ever give the same
## reading.
##
## The wumpus and the slime pit are entities with locations, not properties of
## rooms. Every warning, every death and every arrow is then a plain condition
## over where those two things are. Adjacency is authored, not computed: Chord
## has no adjacency predicate, by deliberate design. The map is one table, on
## the Cave region below; the warnings and the arrows are written against it.
## See docs/cave-map.md and docs/spike-findings.md.
##
## You get one arrow. An arrow flies straight on until the tunnel bends, so a
## shot can reach up to four rooms down a gallery - and any shot that does not
## find the wumpus wakes it, and it finds you.

story
  title: Hunt the Wumpus
  authors:
    John Googol
  id: wumpus-sharpee
  story-version: 0.4.0
  ifid: CDF72E4B-C043-4559-B972-9402939378A6
  description: Twenty-five dark rooms, one wumpus, one bottomless pit, and one arrow.
  prologue:
    You have been under this hill long enough to stop counting, and the last
    hour of it is missing entirely. There is no rope behind you and no daylight
    in any direction, only rooms, and more rooms, and the cold coming off them.

    One arrow on the string. Somewhere down here is the thing you came to kill,
    and it has not been asleep the whole time either.
  themes: retro-terminal, modern-dark, paper, system-6
  default-theme: retro-terminal
  states: searching, warned
  score kill worth 20
  use scoring
    rank "Trespasser" at 0
    rank "Wumpus-Slayer" at 20

  on every turn while the wumpus is here
    kill the player eaten
  end on

  on every turn while the slime pit is here
    kill the player swallowed
  end on

  on every turn while searching
    change the story to warned when the player is in the Cistern and (the wumpus is in the Font or the wumpus is in the Sump)
    change the story to warned when the player is in the Font and (the wumpus is in the Cistern or the wumpus is in the Flue or the wumpus is in the Sump)
    change the story to warned when the player is in the Flue and (the wumpus is in the Font or the wumpus is in the Rift or the wumpus is in the Crooked Stair)
    change the story to warned when the player is in the Rift and (the wumpus is in the Flue or the wumpus is in the Eyrie or the wumpus is in the Dry Vault or the wumpus is in the Chimney)
    change the story to warned when the player is in the Eyrie and (the wumpus is in the Rift or the wumpus is in the Chimney)
    change the story to warned when the player is in the Bone Shelf and (the wumpus is in the Sump or the wumpus is in the Weeping Gallery)
    change the story to warned when the player is in the Sump and (the wumpus is in the Cistern or the wumpus is in the Font or the wumpus is in the Bone Shelf or the wumpus is in the Crooked Stair)
    change the story to warned when the player is in the Crooked Stair and (the wumpus is in the Flue or the wumpus is in the Sump or the wumpus is in the Dry Vault or the wumpus is in the Anvil)
    change the story to warned when the player is in the Dry Vault and (the wumpus is in the Rift or the wumpus is in the Crooked Stair or the wumpus is in the Anvil)
    change the story to warned when the player is in the Chimney and (the wumpus is in the Rift or the wumpus is in the Eyrie or the wumpus is in the Cold Seep)
    change the story to warned when the player is in the Weeping Gallery and (the wumpus is in the Bone Shelf or the wumpus is in the Bellows or the wumpus is in the Larder)
    change the story to warned when the player is in the Throat and (the wumpus is in the Scree Fall or the wumpus is in the Larder or the wumpus is in the Drum)
    change the story to warned when the player is in the Scree Fall and (the wumpus is in the Throat or the wumpus is in the Anvil)
    change the story to warned when the player is in the Anvil and (the wumpus is in the Crooked Stair or the wumpus is in the Dry Vault or the wumpus is in the Scree Fall or the wumpus is in the Cold Seep or the wumpus is in the Dead Well)
    change the story to warned when the player is in the Cold Seep and (the wumpus is in the Chimney or the wumpus is in the Anvil)
    change the story to warned when the player is in the Bellows and (the wumpus is in the Weeping Gallery or the wumpus is in the Larder or the wumpus is in the Cellar)
    change the story to warned when the player is in the Larder and (the wumpus is in the Weeping Gallery or the wumpus is in the Throat or the wumpus is in the Bellows or the wumpus is in the Drum or the wumpus is in the Mire)
    change the story to warned when the player is in the Drum and (the wumpus is in the Throat or the wumpus is in the Larder or the wumpus is in the Gullet)
    change the story to warned when the player is in the Dead Well and (the wumpus is in the Anvil or the wumpus is in the Shambles or the wumpus is in the Rookery or the wumpus is in the Deep)
    change the story to warned when the player is in the Shambles and (the wumpus is in the Dead Well or the wumpus is in the Deep)
    change the story to warned when the player is in the Cellar and (the wumpus is in the Bellows or the wumpus is in the Mire)
    change the story to warned when the player is in the Mire and (the wumpus is in the Larder or the wumpus is in the Cellar)
    change the story to warned when the player is in the Gullet and (the wumpus is in the Drum or the wumpus is in the Rookery)
    change the story to warned when the player is in the Rookery and (the wumpus is in the Dead Well or the wumpus is in the Gullet or the wumpus is in the Deep)
    change the story to warned when the player is in the Deep and (the wumpus is in the Dead Well or the wumpus is in the Shambles or the wumpus is in the Rookery)
    phrase first-blood when warned
  end on

## =========================================================================
## THE CAVE - one region, and the whole map is its exit table. Each tunnel
## is written once, from its west or north end; Chord infers the way back.
## Rooms that only ever receive tunnels have no row.
## =========================================================================

create the Cave, a region
  exits
    the Cistern: east to the Font, southeast to the Sump
    the Font: east to the Flue, south to the Sump
    the Flue: east to the Rift, south to the Crooked Stair
    the Rift: east to the Eyrie, southeast to the Chimney, south to the Dry Vault
    the Eyrie: south to the Chimney
    the Bone Shelf: east to the Sump, south to the Weeping Gallery
    the Sump: east to the Crooked Stair
    the Crooked Stair: east to the Dry Vault, southeast to the Anvil
    the Dry Vault: south to the Anvil
    the Chimney: south to the Cold Seep
    the Weeping Gallery: southeast to the Larder, south to the Bellows
    the Throat: east to the Scree Fall, southeast to the Drum, south to the Larder
    the Scree Fall: east to the Anvil
    the Anvil: east to the Cold Seep, south to the Dead Well
    the Bellows: east to the Larder, south to the Cellar
    the Larder: east to the Drum, south to the Mire
    the Drum: south to the Gullet
    the Dead Well: east to the Shambles, southeast to the Deep, south to the Rookery
    the Shambles: south to the Deep
    the Cellar: east to the Mire
    the Gullet: east to the Rookery
    the Rookery: east to the Deep

  The cave under the hill: twenty-five rooms and no way out.

## Every room in the cave is a `cavern`. The trait carries what is the same
## everywhere - the familiarity ladder MAP reads, and the daemon that prints
## the room's tunnel list on its own line every turn the hunter survives. A
## room supplies only what is its own: its prose, its two warnings, and the
## words of its tunnel list. The list is a phrase rather than a room detail
## because a detail is appended inside the description paragraph and drops
## {br}, so it could not get the line of its own the player needs to read it
## at a glance.

define trait cavern
  states: strange, seen-once, seen-twice, well-known
  on every turn while the player is in it and not the wumpus is here and not the slime pit is here
    phrase tunnels
  end on
end trait

create the Cistern, a room, cavern
  in the Cave
  aka cistern
  phrase tunnels:
    Tunnels lead east and southeast.

  A pool sunk into the rock, its rim cut square by somebody a long time ago,
  using tools. Whoever it was did not finish the fourth side.

  phrase detail while the wumpus is in the Font or the wumpus is in the Sump:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Font or the slime pit is in the Sump:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Font, a room, cavern
  in the Cave
  aka font, basin
  phrase tunnels:
    Tunnels lead east, south and west.

  A basin worn into the floor, brimful of water so still it reads as glass.
  Something has been drinking here. The mud at the rim is printed and printed
  again, always the same shape, always far too wide.

  phrase detail while the wumpus is in the Cistern or the wumpus is in the Flue or the wumpus is in the Sump:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Cistern or the slime pit is in the Flue or the slime pit is in the Sump:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Flue, a room, cavern
  in the Cave
  aka flue, chimney shaft
  phrase tunnels:
    Tunnels lead east, south and west.

  A shaft climbs out of the ceiling and narrows to nothing, too tight to
  follow even if you wanted to. Cold air comes down it in a steady draw, the
  way breath goes into a body rather than out of one.

  phrase detail while the wumpus is in the Font or the wumpus is in the Rift or the wumpus is in the Crooked Stair:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Font or the slime pit is in the Rift or the slime pit is in the Crooked Stair:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Rift, a room, cavern
  in the Cave
  aka rift, seam
  phrase tunnels:
    Tunnels lead east, southeast, south and west.

  The floor splits along a seam you could lose a boot in. Pebbles kicked
  over the edge rattle for a long time and never quite arrive.

  phrase detail while the wumpus is in the Flue or the wumpus is in the Eyrie or the wumpus is in the Dry Vault or the wumpus is in the Chimney:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Flue or the slime pit is in the Eyrie or the slime pit is in the Dry Vault or the slime pit is in the Chimney:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Eyrie, a room, cavern
  in the Cave
  aka eyrie, nest
  phrase tunnels:
    Tunnels lead south and west.

  A ledge high in a chamber whose floor you cannot see. Something roosted
  here once and left the shells of its eggs, each one the size of a skull.

  phrase detail while the wumpus is in the Rift or the wumpus is in the Chimney:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Rift or the slime pit is in the Chimney:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Bone Shelf, a room, cavern
  in the Cave
  aka shelf, bones, bone
  phrase tunnels:
    Tunnels lead east and south.

  A ledge of pale flowstone, and laid along it the small bones of animals
  that came in and did not leave. They have been sorted by size. That is
  considerably worse than scattered.

  phrase detail while the wumpus is in the Sump or the wumpus is in the Weeping Gallery:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Sump or the slime pit is in the Weeping Gallery:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Sump, a room, cavern
  in the Cave
  aka sump
  phrase tunnels:
    Tunnels lead north, east, west and northwest.

  Standing water over the whole floor, ankle deep and absolutely still. It
  takes the light off your lantern and returns none of it.

  phrase detail while the wumpus is in the Cistern or the wumpus is in the Font or the wumpus is in the Bone Shelf or the wumpus is in the Crooked Stair:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Cistern or the slime pit is in the Font or the slime pit is in the Bone Shelf or the slime pit is in the Crooked Stair:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Crooked Stair, a room, cavern
  in the Cave
  aka stair, crooked, steps
  phrase tunnels:
    Tunnels lead north, east, southeast and west.

  The rock has collapsed into steps, every one of them canted the wrong way.
  You climb it sideways with a hand on the wall, and the wall is wet.

  phrase detail while the wumpus is in the Flue or the wumpus is in the Sump or the wumpus is in the Dry Vault or the wumpus is in the Anvil:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Flue or the slime pit is in the Sump or the slime pit is in the Dry Vault or the slime pit is in the Anvil:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Dry Vault, a room, cavern
  in the Cave
  aka vault, dry
  phrase tunnels:
    Tunnels lead north, south and west.

  A high round chamber, bone dry, walls smoothed as if poured. Your smallest
  sound comes back four times and the fourth one is not yours.

  phrase detail while the wumpus is in the Rift or the wumpus is in the Crooked Stair or the wumpus is in the Anvil:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Rift or the slime pit is in the Crooked Stair or the slime pit is in the Anvil:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Chimney, a room, cavern
  in the Cave
  aka chimney
  phrase tunnels:
    Tunnels lead north, south and northwest.

  A vertical crack you have to turn sideways to pass, your back on one face
  and your boots on the other. It exhales when you are halfway through.

  phrase detail while the wumpus is in the Rift or the wumpus is in the Eyrie or the wumpus is in the Cold Seep:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Rift or the slime pit is in the Eyrie or the slime pit is in the Cold Seep:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Weeping Gallery, a room, cavern
  in the Cave
  aka gallery, weeping
  phrase tunnels:
    Tunnels lead north, southeast and south.

  Water beads across every inch of the ceiling and lets go a drop at a time,
  in no rhythm you can learn. The floor has gone soft with it.

  phrase detail while the wumpus is in the Bone Shelf or the wumpus is in the Bellows or the wumpus is in the Larder:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Bone Shelf or the slime pit is in the Bellows or the slime pit is in the Larder:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Throat, a room, cavern
  in the Cave
  aka throat, gullet passage
  phrase tunnels:
    Tunnels lead east, southeast and south.

  The passage narrows to a gullet of ribbed stone and swallows you through it.
  The air here is warmer. You would rather it were not warmer.

  phrase detail while the wumpus is in the Scree Fall or the wumpus is in the Larder or the wumpus is in the Drum:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Scree Fall or the slime pit is in the Larder or the slime pit is in the Drum:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Scree Fall, a room, cavern
  in the Cave
  aka scree, fall
  phrase tunnels:
    Tunnels lead east and west.

  A slope of broken rock runs down out of a collapse overhead. Everything you
  put your weight on wants to travel.

  phrase detail while the wumpus is in the Throat or the wumpus is in the Anvil:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Throat or the slime pit is in the Anvil:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Anvil, a room, cavern
  in the Cave
  aka anvil
  phrase tunnels:
    Tunnels lead north, east, south, west and northwest.

  A single block of fallen ceiling sits square in the middle of the floor,
  flat on top, and scored all over with long parallel grooves. Four of them,
  evenly spaced, over and over.

  phrase detail while the wumpus is in the Crooked Stair or the wumpus is in the Dry Vault or the wumpus is in the Scree Fall or the wumpus is in the Cold Seep or the wumpus is in the Dead Well:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Crooked Stair or the slime pit is in the Dry Vault or the slime pit is in the Scree Fall or the slime pit is in the Cold Seep or the slime pit is in the Dead Well:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Cold Seep, a room, cavern
  in the Cave
  aka seep, cold
  phrase tunnels:
    Tunnels lead north and west.

  Water comes through the wall here without any sound at all, sheeting down
  the rock and vanishing into a crack. It is colder than the air by a lot.

  phrase detail while the wumpus is in the Chimney or the wumpus is in the Anvil:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Chimney or the slime pit is in the Anvil:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Bellows, a room, cavern
  in the Cave
  aka bellows, slot
  phrase tunnels:
    Tunnels lead north, east and south.

  Air pushes through a low slot in the far wall and draws back again, in and
  out, on a slow patient count. Either something very large is asleep down
  there, or the hill itself is breathing.

  phrase detail while the wumpus is in the Weeping Gallery or the wumpus is in the Larder or the wumpus is in the Cellar:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Weeping Gallery or the slime pit is in the Larder or the slime pit is in the Cellar:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Larder, a room, cavern
  in the Cave
  aka larder
  phrase tunnels:
    Tunnels lead north, east, south, west and northwest.

  Dry, and cold, and used. Things have been carried here and set down: hide,
  a hoof, a boot with the foot still in it. None of it is fresh. None of it
  is old either.

  phrase detail while the wumpus is in the Weeping Gallery or the wumpus is in the Throat or the wumpus is in the Bellows or the wumpus is in the Drum or the wumpus is in the Mire:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Weeping Gallery or the slime pit is in the Throat or the slime pit is in the Bellows or the slime pit is in the Drum or the slime pit is in the Mire:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Drum, a room, cavern
  in the Cave
  aka drum
  phrase tunnels:
    Tunnels lead south, west and northwest.

  The floor rings hollow underfoot, one deep struck note that travels further
  than you would like it to. There is a space beneath this space.

  phrase detail while the wumpus is in the Throat or the wumpus is in the Larder or the wumpus is in the Gullet:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Throat or the slime pit is in the Larder or the slime pit is in the Gullet:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Dead Well, a room, cavern
  in the Cave
  aka well, dead well, shaft
  phrase tunnels:
    Tunnels lead north, east, southeast and south.

  A shaft drops straight down through the middle of the floor, ringed by a lip
  of stone worn smooth by something that uses it. Nothing comes back up out
  of it. Not even sound.

  phrase detail while the wumpus is in the Anvil or the wumpus is in the Shambles or the wumpus is in the Rookery or the wumpus is in the Deep:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Anvil or the slime pit is in the Shambles or the slime pit is in the Rookery or the slime pit is in the Deep:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Shambles, a room, cavern
  in the Cave
  aka shambles
  phrase tunnels:
    Tunnels lead south and west.

  The passage has been widened, and not by water. The tool marks are gouges,
  four at a time, and they are at the height of your shoulder.

  phrase detail while the wumpus is in the Dead Well or the wumpus is in the Deep:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Dead Well or the slime pit is in the Deep:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Cellar, a room, cavern
  in the Cave
  aka cellar
  phrase tunnels:
    Tunnels lead north and east.

  A low flat room with a floor of dried mud, cracked into plates. Something
  crossed it while it was still wet and the prints have set like pottery.

  phrase detail while the wumpus is in the Bellows or the wumpus is in the Mire:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Bellows or the slime pit is in the Mire:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Mire, a room, cavern
  in the Cave
  aka mire, mud
  phrase tunnels:
    Tunnels lead north and west.

  Mud to the ankle, and it pulls. Whatever walks here regularly has worn a
  channel through the middle, and the channel is wider than the passage.

  phrase detail while the wumpus is in the Larder or the wumpus is in the Cellar:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Larder or the slime pit is in the Cellar:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Gullet, a room, cavern
  in the Cave
  aka gullet
  phrase tunnels:
    Tunnels lead north and east.

  The rock closes overhead and the floor tilts down, and for thirty feet you
  are walking inside something that was shaped by swallowing.

  phrase detail while the wumpus is in the Drum or the wumpus is in the Rookery:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Drum or the slime pit is in the Rookery:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Rookery, a room, cavern
  in the Cave
  aka rookery
  phrase tunnels:
    Tunnels lead north, east and west.

  The ceiling is pocked with hundreds of shallow hollows, each one polished.
  Nothing lives in them now. Everything that did left at the same time.

  phrase detail while the wumpus is in the Dead Well or the wumpus is in the Gullet or the wumpus is in the Deep:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Dead Well or the slime pit is in the Gullet or the slime pit is in the Deep:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Deep, a room, cavern
  in the Cave
  aka deep
  phrase tunnels:
    Tunnels lead north, west and northwest.

  The passage ends in air. Your light finds no wall, no ceiling, no floor
  beyond the edge you are standing on. The cave has been getting to this the
  whole time.

  phrase detail while the wumpus is in the Dead Well or the wumpus is in the Shambles or the wumpus is in the Rookery:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Dead Well or the slime pit is in the Shambles or the slime pit is in the Rookery:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

## =========================================================================
## THE HAZARDS - placed by the start block, never by hand.
## =========================================================================

create the wumpus, a person, proper, concealed
  pronouns it
  states: sleeping, shot

  Vast, and blind, and in no hurry whatsoever.

create the slime pit, a thing, scenery, concealed
  aka pit, slime, hole

  A hole that goes down considerably further than sound does.

## =========================================================================
## THE HUNTER
## =========================================================================

## Each move steps the familiarity ladder of the room the hunter arrives in,
## once. The rungs are stepped from the top down so a room climbs one rung
## per visit, never three; `each` finds the one room that is at that rung
## and has the player in it.

create the hunter, a person
  playable
  aka me, myself, self
  starts in the Cistern
  carries the bow
  carries the note

  after going
    each here-again
      change the match to well-known
    end each
    each here-new
      change the match to seen-twice
    end each
    each here-strange
      change the match to seen-once
    end each
  end after

  Lean, out of work, and a long way underground.

create the bow, a thing
  aka arrow, arrows, quiver, shortbow
  readable

  A short bow, drawn smooth at the grip by somebody else's hands, and one
  arrow. There was never more than one arrow.

create the note, a thing
  aka paper, scrap, rules, instructions
  readable

  A scrap of oiled paper, folded to the size of a palm, carried by every
  hunter who has tried this and left behind by most of them.

  on the player reading
    phrase note-text
  end on

## =========================================================================
## REMEMBERING - MAP does not draw a map. It asks how well you know the
## room you are standing in. The conditions are OPEN - they mention `it` -
## so `any <condition>` and `each <condition>` find the one room that is
## both at that rung and the room the player is standing in.
## =========================================================================

define condition here-strange: it is strange and the player is in it
define condition here-new: it is seen-once and the player is in it
define condition here-again: it is seen-twice and the player is in it
define condition here-known: it is well-known and the player is in it

define action recalling
  grammar
    map or remember or recall or think
    think back
    get bearings
  phrase recall-new when any here-new
  phrase recall-again when any here-again
  phrase recall-known when any here-known

## =========================================================================
## SHOOTING - one action per direction, one line per room you can shoot from.
## The room list after `the wumpus is in` is the arrow's flight: it carries
## straight on while the tunnel does, so a shot down a gallery reaches
## rooms you have never stood in. A hit sets the wumpus to `shot`, and the
## miss keys off that, because a `win` does not stop the rest of the body.
## =========================================================================

define action shooting-north
  grammar
    shoot or fire [arrow] north or n
  the player must hold the bow: shoot-no-bow
  change the wumpus to shot when the player is in the Sump and the wumpus is in the Font
  change the wumpus to shot when the player is in the Crooked Stair and the wumpus is in the Flue
  change the wumpus to shot when the player is in the Dry Vault and the wumpus is in the Rift
  change the wumpus to shot when the player is in the Chimney and the wumpus is in the Eyrie
  change the wumpus to shot when the player is in the Weeping Gallery and the wumpus is in the Bone Shelf
  change the wumpus to shot when the player is in the Anvil and (the wumpus is in the Dry Vault or the wumpus is in the Rift)
  change the wumpus to shot when the player is in the Cold Seep and (the wumpus is in the Chimney or the wumpus is in the Eyrie)
  change the wumpus to shot when the player is in the Bellows and (the wumpus is in the Weeping Gallery or the wumpus is in the Bone Shelf)
  change the wumpus to shot when the player is in the Larder and the wumpus is in the Throat
  change the wumpus to shot when the player is in the Dead Well and (the wumpus is in the Anvil or the wumpus is in the Dry Vault or the wumpus is in the Rift)
  change the wumpus to shot when the player is in the Cellar and (the wumpus is in the Bellows or the wumpus is in the Weeping Gallery or the wumpus is in the Bone Shelf)
  change the wumpus to shot when the player is in the Mire and (the wumpus is in the Larder or the wumpus is in the Throat)
  change the wumpus to shot when the player is in the Gullet and the wumpus is in the Drum
  change the wumpus to shot when the player is in the Rookery and (the wumpus is in the Dead Well or the wumpus is in the Anvil or the wumpus is in the Dry Vault or the wumpus is in the Rift)
  change the wumpus to shot when the player is in the Deep and the wumpus is in the Shambles
  award kill when the wumpus is shot
  win kill-wumpus when the wumpus is shot
  kill the player woke-it when not the wumpus is shot

define action shooting-east
  grammar
    shoot or fire [arrow] east or e
  the player must hold the bow: shoot-no-bow
  change the wumpus to shot when the player is in the Cistern and (the wumpus is in the Font or the wumpus is in the Flue or the wumpus is in the Rift or the wumpus is in the Eyrie)
  change the wumpus to shot when the player is in the Font and (the wumpus is in the Flue or the wumpus is in the Rift or the wumpus is in the Eyrie)
  change the wumpus to shot when the player is in the Flue and (the wumpus is in the Rift or the wumpus is in the Eyrie)
  change the wumpus to shot when the player is in the Rift and the wumpus is in the Eyrie
  change the wumpus to shot when the player is in the Bone Shelf and (the wumpus is in the Sump or the wumpus is in the Crooked Stair or the wumpus is in the Dry Vault)
  change the wumpus to shot when the player is in the Sump and (the wumpus is in the Crooked Stair or the wumpus is in the Dry Vault)
  change the wumpus to shot when the player is in the Crooked Stair and the wumpus is in the Dry Vault
  change the wumpus to shot when the player is in the Throat and (the wumpus is in the Scree Fall or the wumpus is in the Anvil or the wumpus is in the Cold Seep)
  change the wumpus to shot when the player is in the Scree Fall and (the wumpus is in the Anvil or the wumpus is in the Cold Seep)
  change the wumpus to shot when the player is in the Anvil and the wumpus is in the Cold Seep
  change the wumpus to shot when the player is in the Bellows and (the wumpus is in the Larder or the wumpus is in the Drum)
  change the wumpus to shot when the player is in the Larder and the wumpus is in the Drum
  change the wumpus to shot when the player is in the Dead Well and the wumpus is in the Shambles
  change the wumpus to shot when the player is in the Cellar and the wumpus is in the Mire
  change the wumpus to shot when the player is in the Gullet and (the wumpus is in the Rookery or the wumpus is in the Deep)
  change the wumpus to shot when the player is in the Rookery and the wumpus is in the Deep
  award kill when the wumpus is shot
  win kill-wumpus when the wumpus is shot
  kill the player woke-it when not the wumpus is shot

define action shooting-southeast
  grammar
    shoot or fire [arrow] southeast or se
  the player must hold the bow: shoot-no-bow
  change the wumpus to shot when the player is in the Cistern and the wumpus is in the Sump
  change the wumpus to shot when the player is in the Rift and the wumpus is in the Chimney
  change the wumpus to shot when the player is in the Crooked Stair and the wumpus is in the Anvil
  change the wumpus to shot when the player is in the Weeping Gallery and the wumpus is in the Larder
  change the wumpus to shot when the player is in the Throat and the wumpus is in the Drum
  change the wumpus to shot when the player is in the Dead Well and the wumpus is in the Deep
  award kill when the wumpus is shot
  win kill-wumpus when the wumpus is shot
  kill the player woke-it when not the wumpus is shot

define action shooting-south
  grammar
    shoot or fire [arrow] south or s
  the player must hold the bow: shoot-no-bow
  change the wumpus to shot when the player is in the Font and the wumpus is in the Sump
  change the wumpus to shot when the player is in the Flue and the wumpus is in the Crooked Stair
  change the wumpus to shot when the player is in the Rift and (the wumpus is in the Dry Vault or the wumpus is in the Anvil or the wumpus is in the Dead Well or the wumpus is in the Rookery)
  change the wumpus to shot when the player is in the Eyrie and (the wumpus is in the Chimney or the wumpus is in the Cold Seep)
  change the wumpus to shot when the player is in the Bone Shelf and (the wumpus is in the Weeping Gallery or the wumpus is in the Bellows or the wumpus is in the Cellar)
  change the wumpus to shot when the player is in the Dry Vault and (the wumpus is in the Anvil or the wumpus is in the Dead Well or the wumpus is in the Rookery)
  change the wumpus to shot when the player is in the Chimney and the wumpus is in the Cold Seep
  change the wumpus to shot when the player is in the Weeping Gallery and (the wumpus is in the Bellows or the wumpus is in the Cellar)
  change the wumpus to shot when the player is in the Throat and (the wumpus is in the Larder or the wumpus is in the Mire)
  change the wumpus to shot when the player is in the Anvil and (the wumpus is in the Dead Well or the wumpus is in the Rookery)
  change the wumpus to shot when the player is in the Bellows and the wumpus is in the Cellar
  change the wumpus to shot when the player is in the Larder and the wumpus is in the Mire
  change the wumpus to shot when the player is in the Drum and the wumpus is in the Gullet
  change the wumpus to shot when the player is in the Dead Well and the wumpus is in the Rookery
  change the wumpus to shot when the player is in the Shambles and the wumpus is in the Deep
  award kill when the wumpus is shot
  win kill-wumpus when the wumpus is shot
  kill the player woke-it when not the wumpus is shot

define action shooting-west
  grammar
    shoot or fire [arrow] west or w
  the player must hold the bow: shoot-no-bow
  change the wumpus to shot when the player is in the Font and the wumpus is in the Cistern
  change the wumpus to shot when the player is in the Flue and (the wumpus is in the Font or the wumpus is in the Cistern)
  change the wumpus to shot when the player is in the Rift and (the wumpus is in the Flue or the wumpus is in the Font or the wumpus is in the Cistern)
  change the wumpus to shot when the player is in the Eyrie and (the wumpus is in the Rift or the wumpus is in the Flue or the wumpus is in the Font or the wumpus is in the Cistern)
  change the wumpus to shot when the player is in the Sump and the wumpus is in the Bone Shelf
  change the wumpus to shot when the player is in the Crooked Stair and (the wumpus is in the Sump or the wumpus is in the Bone Shelf)
  change the wumpus to shot when the player is in the Dry Vault and (the wumpus is in the Crooked Stair or the wumpus is in the Sump or the wumpus is in the Bone Shelf)
  change the wumpus to shot when the player is in the Scree Fall and the wumpus is in the Throat
  change the wumpus to shot when the player is in the Anvil and (the wumpus is in the Scree Fall or the wumpus is in the Throat)
  change the wumpus to shot when the player is in the Cold Seep and (the wumpus is in the Anvil or the wumpus is in the Scree Fall or the wumpus is in the Throat)
  change the wumpus to shot when the player is in the Larder and the wumpus is in the Bellows
  change the wumpus to shot when the player is in the Drum and (the wumpus is in the Larder or the wumpus is in the Bellows)
  change the wumpus to shot when the player is in the Shambles and the wumpus is in the Dead Well
  change the wumpus to shot when the player is in the Mire and the wumpus is in the Cellar
  change the wumpus to shot when the player is in the Rookery and the wumpus is in the Gullet
  change the wumpus to shot when the player is in the Deep and (the wumpus is in the Rookery or the wumpus is in the Gullet)
  award kill when the wumpus is shot
  win kill-wumpus when the wumpus is shot
  kill the player woke-it when not the wumpus is shot

define action shooting-northwest
  grammar
    shoot or fire [arrow] northwest or nw
  the player must hold the bow: shoot-no-bow
  change the wumpus to shot when the player is in the Sump and the wumpus is in the Cistern
  change the wumpus to shot when the player is in the Chimney and the wumpus is in the Rift
  change the wumpus to shot when the player is in the Anvil and the wumpus is in the Crooked Stair
  change the wumpus to shot when the player is in the Larder and the wumpus is in the Weeping Gallery
  change the wumpus to shot when the player is in the Drum and the wumpus is in the Throat
  change the wumpus to shot when the player is in the Deep and the wumpus is in the Dead Well
  award kill when the wumpus is shot
  win kill-wumpus when the wumpus is shot
  kill the player woke-it when not the wumpus is shot



## =========================================================================
## TEXT
## =========================================================================

define phrases en-US
  eaten:
    The dark ahead of you is not dark, it is bulk, and it has been waiting for
    you to finish walking into it.

    *** You have been eaten by the wumpus ***
  swallowed:
    The floor is not floor. It takes your leg to the hip and then the rest of
    you, without hurrying, and without any sound at all.

    *** You have fallen into the slime pit ***
  kill-wumpus:
    You loose. The arrow goes out along the tunnel, strikes something that is
    not rock, and buries itself.

    The cave fills with a sound you will be hearing for the rest of your life.
    Then it stops, and a great deal of weight settles onto the floor, and the
    cave is only a cave again.

    *** You have killed the wumpus ***
  woke-it:
    You loose. The arrow goes out along the tunnel and finds nothing but rock,
    and the sound of it goes everywhere at once.

    For a moment nothing happens. Then, a long way off, something enormous
    stops pretending to be asleep, and the dark between you and it turns out
    to be no distance at all.

    *** The wumpus found you first ***
  shoot-no-bow:
    You would need the bow for that.
  first-blood:
    You stop, and look at it properly. The blood on this wall is not old. It is
    still tacky, it is smeared rather than spattered, and whatever left it here
    was dragging something heavy and in no hurry about it.

    Fresh blood means the wumpus is close - not in this room, but in one of the
    rooms at the other end of these tunnels. That is all it means. It will never
    tell you which tunnel, and the slime that marks the pit works exactly the
    same way.

    So do not go and look. Going and looking is how the blood got here.

    You have an arrow, and an arrow will go down a tunnel without you. Work the
    room out from what you have seen, stand somewhere you trust, and SHOOT along
    the tunnel you want - SHOOT NORTH, SHOOT SOUTHEAST. Keep the map.

    You only get the one arrow.
  recall-new:
    You have not stood here before. Every shape in this room is news, and none
    of the news is good.
  recall-again:
    You have been here once already. The room comes back to you a half-second
    before your light reaches the walls, which is the only warning you are
    likely to get down here.
  recall-known:
    You have crossed this room enough times to walk it in the dark, and you may
    yet have to. Nothing about it has changed. Nothing about it is going to.
  tunnels:
    Tunnels lead somewhere you have not been told about.
  note-text:
    Written small, in a hand that got worse toward the bottom:{br}
    {br}
    BLOOD ON THE WALLS MEANS IT IS NEXT DOOR.{br}
    SLIME MEANS THE PIT IS.{br}
    NEITHER ONE TELLS YOU WHICH SIDE. THAT IS THE WHOLE PROBLEM.{br}
    {br}
    DO NOT WALK INTO EITHER ONE TO BE SURE. YOU WILL BE SURE.{br}
    {br}
    STAND IN A ROOM YOU TRUST AND SHOOT ALONG A TUNNEL - SHOOT NORTH, SHOOT
    SOUTHEAST. AN ARROW ONLY GOES WHERE A TUNNEL GOES, AND IT KEEPS GOING
    WHILE THE TUNNEL RUNS STRAIGHT, SO YOU CAN KILL IT FROM FURTHER OFF THAN
    YOU THINK.{br}
    {br}
    YOU HAVE ONE ARROW. IF IT DOES NOT FIND HIM, HE FINDS YOU.{br}
    {br}
    DRAW THE MAP. FIVE ACROSS AND FIVE DOWN, BUT NOT EVERY WALL IS OPEN AND
    SOME OF THE WAYS THROUGH GO CORNERWISE. WRITE IT DOWN AS YOU GO.

## =========================================================================
## THE START - you wake somewhere in the middle of it, in a room that is
## clear of both hazards and of both warnings, and a fair walk from the
## wumpus. Note `move the hunter`, not `move the player`: in a start block
## the latter is a silent no-op and the character stays wherever `starts in`
## put them. There is no way out. There was never going to be a way out.
## =========================================================================

before the game starts
  change the player to the hunter
  select randomly
    move the wumpus to the Throat
    move the slime pit to the Bellows
    move the hunter to the Cistern
    change the Cistern to seen-once
  or
    move the wumpus to the Mire
    move the slime pit to the Shambles
    move the hunter to the Eyrie
    change the Eyrie to seen-once
  or
    move the wumpus to the Deep
    move the slime pit to the Flue
    move the hunter to the Sump
    change the Sump to seen-once
  or
    move the wumpus to the Shambles
    move the slime pit to the Drum
    move the hunter to the Font
    change the Font to seen-once
  or
    move the wumpus to the Rookery
    move the slime pit to the Cellar
    move the hunter to the Dry Vault
    change the Dry Vault to seen-once
  or
    move the wumpus to the Bone Shelf
    move the slime pit to the Anvil
    move the hunter to the Rift
    change the Rift to seen-once
  or
    move the wumpus to the Font
    move the slime pit to the Rift
    move the hunter to the Shambles
    change the Shambles to seen-once
  or
    move the wumpus to the Drum
    move the slime pit to the Cistern
    move the hunter to the Shambles
    change the Shambles to seen-once
  or
    move the wumpus to the Anvil
    move the slime pit to the Throat
    move the hunter to the Font
    change the Font to seen-once
  or
    move the wumpus to the Rift
    move the slime pit to the Font
    move the hunter to the Larder
    change the Larder to seen-once
  end select
end before
