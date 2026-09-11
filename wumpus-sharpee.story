## Hunt the Wumpus - a Sharpee/Chord treatment of the 1973 BASIC game.
## The cave is a four-by-four grid. The wumpus and the slime pit are entities
## with locations, not properties of rooms, which is what lets every warning,
## every death and every arrow be a plain condition over where they are.
##
## Adjacency is authored, not computed: Chord has no adjacency predicate, by
## deliberate design (the ADR names it a non-goal). The map is hand-drawn, so
## its adjacency is authoring-time data. See docs/spike-findings.md.

story
  title: Hunt the Wumpus
  authors:
    John Googol
  id: wumpus-sharpee
  story-version: 0.1.0
  ifid: CDF72E4B-C043-4559-B972-9402939378A6
  description: Sixteen dark rooms, one wumpus, one bottomless pit, and three arrows to tell them apart.
  themes: modern-dark, retro-terminal, paper, system-6
  score kill worth 20
  score escape worth 5
  use scoring
    rank "Trespasser" at 0
    rank "Survivor" at 5
    rank "Wumpus-Slayer" at 20

  on every turn while the wumpus is here
    kill the player eaten
  end on

  on every turn while the slime pit is here
    kill the player swallowed
  end on

## =========================================================================
## THE CAVE - four by four, north at the top, no diagonals.
## Each edge is declared once; Chord makes exits two-way.
## =========================================================================

create the Cave Mouth
  a room
  aka mouth, entrance
  north to the Hillside
  east to the Font
  south to the Bone Shelf

  Daylight gets three steps in and gives up. Behind you, the hillside and
  the long walk back. Ahead, a throat of cold limestone that smells of wet
  rock and air that has not been outside in a very long time.

  phrase detail while the wumpus is in the Bone Shelf or the wumpus is in the Font:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Bone Shelf or the slime pit is in the Font:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Font
  a room
  aka font, basin
  east to the Flue
  south to the Sump

  A basin worn into the floor, brimful of water so still it reads as glass.
  Something has been drinking here. The mud at the rim is printed and
  printed again, always the same shape, always far too wide.

  phrase detail while the wumpus is in the Sump or the wumpus is in the Flue or the wumpus is in the Cave Mouth:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Sump or the slime pit is in the Flue or the slime pit is in the Cave Mouth:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Flue
  a room
  aka flue, chimney
  east to the Rift
  south to the Crooked Stair

  A chimney climbs out of the ceiling and narrows to nothing, too tight to
  follow even if you wanted to. Cold air comes down it in a steady draw, the
  way breath goes into a body rather than out of one.

  phrase detail while the wumpus is in the Crooked Stair or the wumpus is in the Rift or the wumpus is in the Font:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Crooked Stair or the slime pit is in the Rift or the slime pit is in the Font:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Rift
  a room
  aka rift, seam
  south to the Dry Vault

  The floor splits along a seam you could lose a boot in. Pebbles kicked
  over the edge rattle for a long time and never quite arrive.

  phrase detail while the wumpus is in the Dry Vault or the wumpus is in the Flue:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Dry Vault or the slime pit is in the Flue:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Bone Shelf
  a room
  aka shelf, bones
  east to the Sump
  south to the Cistern

  A ledge of pale flowstone, and laid along it the small bones of animals
  that came in and did not leave. They have been sorted by size. That is
  considerably worse than scattered.

  phrase detail while the wumpus is in the Cave Mouth or the wumpus is in the Cistern or the wumpus is in the Sump:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Cave Mouth or the slime pit is in the Cistern or the slime pit is in the Sump:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Sump
  a room
  aka sump
  east to the Crooked Stair
  south to the Weeping Gallery

  Standing water over the whole floor, ankle deep and absolutely still. It
  takes the light off your lantern and returns none of it.

  phrase detail while the wumpus is in the Font or the wumpus is in the Weeping Gallery or the wumpus is in the Crooked Stair or the wumpus is in the Bone Shelf:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Font or the slime pit is in the Weeping Gallery or the slime pit is in the Crooked Stair or the slime pit is in the Bone Shelf:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Crooked Stair
  a room
  aka stair, crooked, steps
  east to the Dry Vault
  south to the Throat

  The rock has collapsed into steps, every one of them canted the wrong
  way. You climb it sideways with a hand on the wall, and the wall is wet.

  phrase detail while the wumpus is in the Flue or the wumpus is in the Throat or the wumpus is in the Dry Vault or the wumpus is in the Sump:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Flue or the slime pit is in the Throat or the slime pit is in the Dry Vault or the slime pit is in the Sump:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Dry Vault
  a room
  aka vault, dry
  south to the Scree Fall

  A high round chamber, bone dry, walls smoothed as if poured. Your
  smallest sound comes back four times and the fourth one is not yours.

  phrase detail while the wumpus is in the Rift or the wumpus is in the Scree Fall or the wumpus is in the Crooked Stair:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Rift or the slime pit is in the Scree Fall or the slime pit is in the Crooked Stair:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Cistern
  a room
  aka cistern
  east to the Weeping Gallery
  south to the Bellows

  A pool sunk into the rock with its rim cut square by somebody, a long
  time ago, using tools. Whoever it was did not finish the fourth side.

  phrase detail while the wumpus is in the Bone Shelf or the wumpus is in the Bellows or the wumpus is in the Weeping Gallery:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Bone Shelf or the slime pit is in the Bellows or the slime pit is in the Weeping Gallery:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Weeping Gallery
  a room
  aka gallery, weeping
  east to the Throat
  south to the Larder

  Water beads across every inch of the ceiling and lets go a drop at a
  time, in no rhythm you can learn. The floor has gone soft with it.

  phrase detail while the wumpus is in the Sump or the wumpus is in the Larder or the wumpus is in the Throat or the wumpus is in the Cistern:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Sump or the slime pit is in the Larder or the slime pit is in the Throat or the slime pit is in the Cistern:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Throat
  a room
  aka throat, gullet
  east to the Scree Fall
  south to the Drum

  The passage narrows to a gullet of ribbed stone and swallows you through
  it. The air here is warmer. You would rather it were not warmer.

  phrase detail while the wumpus is in the Crooked Stair or the wumpus is in the Drum or the wumpus is in the Scree Fall or the wumpus is in the Weeping Gallery:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Crooked Stair or the slime pit is in the Drum or the slime pit is in the Scree Fall or the slime pit is in the Weeping Gallery:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Scree Fall
  a room
  aka scree, fall
  south to the Dead Well

  A slope of broken rock runs down out of a collapse overhead. Everything
  you put your weight on wants to travel.

  phrase detail while the wumpus is in the Dry Vault or the wumpus is in the Dead Well or the wumpus is in the Throat:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Dry Vault or the slime pit is in the Dead Well or the slime pit is in the Throat:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Bellows
  a room
  aka bellows, slot
  east to the Larder

  Air pushes through a low slot in the far wall and draws back again, in
  and out, on a slow patient count. Either something very large is asleep
  down there, or the hill itself is breathing.

  phrase detail while the wumpus is in the Cistern or the wumpus is in the Larder:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Cistern or the slime pit is in the Larder:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Larder
  a room
  aka larder
  east to the Drum

  Dry, and cold, and used. Things have been carried here and set down:
  hide, a hoof, a boot with the foot still in it. None of it is fresh. None
  of it is old either.

  phrase detail while the wumpus is in the Weeping Gallery or the wumpus is in the Drum or the wumpus is in the Bellows:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Weeping Gallery or the slime pit is in the Drum or the slime pit is in the Bellows:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Drum
  a room
  aka drum
  east to the Dead Well

  The floor rings hollow underfoot, one deep struck note that travels
  further than you would like it to. There is a space beneath this space.

  phrase detail while the wumpus is in the Throat or the wumpus is in the Dead Well or the wumpus is in the Larder:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Throat or the slime pit is in the Dead Well or the slime pit is in the Larder:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Dead Well
  a room
  aka well, dead well, shaft

  A shaft drops straight down through the middle of the floor, ringed by a
  lip of stone worn smooth by something that uses it. Nothing comes back up
  out of it. Not even sound.

  phrase detail while the wumpus is in the Scree Fall or the wumpus is in the Drum:
    Blood is smeared along the walls here, dragged and dried and not yours.

  phrase detail while the slime pit is in the Scree Fall or the slime pit is in the Drum:
    A grey slime films the rock, cold and freshly laid, and the air has
    turned sweetish.

create the Hillside
  a room
  aka hill, outside, daylight

  Open air, and a sky gone orange along its bottom edge. The cave mouth is a
  black notch in the hill behind you, no wider than a door, and you are on
  the outside of it.

  after the player entering
    award escape
    win walked-out
  end after

## =========================================================================
## THE HAZARDS - placed by the start block, never by hand.
## =========================================================================

create the wumpus
  a person, proper, concealed
  pronouns it
  states: sleeping, stirring, hunting, shot

  Vast, and blind, and in no hurry whatsoever.

create the slime pit
  scenery, concealed
  aka pit, slime, hole

  A hole that goes down considerably further than sound does.

## =========================================================================
## THE HUNTER
## =========================================================================

create the hunter
  a person
  playable
  aka me, myself, self
  starts in the Cave Mouth
  carries the bow
  carries the cave chart

  Lean, out of work, and running out of daylight.

create the bow
  aka arrows, arrow, quiver, shortbow
  states: three-arrows, two-arrows, one-arrow, empty

  A short bow, drawn smooth at the grip by somebody else's hands.

  on the player examining
    phrase arrows-three when the bow is three-arrows
    phrase arrows-two when the bow is two-arrows
    phrase arrows-one when the bow is one-arrow
    phrase arrows-none when the bow is empty
  end on

create the cave chart
  aka chart, map, paper
  readable

  A square of oiled paper, four rooms by four, drawn by somebody who got out.

  on the player reading
    phrase chart-text
  end on

## =========================================================================
## SHOOTING - one action per direction. Each `change` line is one square of
## the map: stand here, and the arrow lands there. A hit sets the wumpus
## to `shot`, and everything after it keys off that, because a `win` does
## not stop the rest of the body from running.
## =========================================================================

define action shooting-north
  grammar
    shoot north
    fire north
    shoot arrow north
    fire arrow north
  the player must hold the bow: shoot-no-bow
  refuse when the bow is empty: shoot-no-arrows
  change the wumpus to shot when the player is in the Bone Shelf and the wumpus is in the Cave Mouth
  change the wumpus to shot when the player is in the Sump and the wumpus is in the Font
  change the wumpus to shot when the player is in the Crooked Stair and the wumpus is in the Flue
  change the wumpus to shot when the player is in the Dry Vault and the wumpus is in the Rift
  change the wumpus to shot when the player is in the Cistern and the wumpus is in the Bone Shelf
  change the wumpus to shot when the player is in the Weeping Gallery and the wumpus is in the Sump
  change the wumpus to shot when the player is in the Throat and the wumpus is in the Crooked Stair
  change the wumpus to shot when the player is in the Scree Fall and the wumpus is in the Dry Vault
  change the wumpus to shot when the player is in the Bellows and the wumpus is in the Cistern
  change the wumpus to shot when the player is in the Larder and the wumpus is in the Weeping Gallery
  change the wumpus to shot when the player is in the Drum and the wumpus is in the Throat
  change the wumpus to shot when the player is in the Dead Well and the wumpus is in the Scree Fall
  change the bow to empty when the bow is one-arrow
  change the bow to one-arrow when the bow is two-arrows
  change the bow to two-arrows when the bow is three-arrows
  award kill when the wumpus is shot
  win kill-wumpus when the wumpus is shot
  phrase arrow-missed when not the wumpus is shot
  change the wumpus to hunting when the wumpus is stirring and not the wumpus is shot
  change the wumpus to stirring when the wumpus is sleeping and not the wumpus is shot
  move the wumpus to a random adjacent room when not the wumpus is shot

define action shooting-south
  grammar
    shoot south
    fire south
    shoot arrow south
    fire arrow south
  the player must hold the bow: shoot-no-bow
  refuse when the bow is empty: shoot-no-arrows
  change the wumpus to shot when the player is in the Cave Mouth and the wumpus is in the Bone Shelf
  change the wumpus to shot when the player is in the Font and the wumpus is in the Sump
  change the wumpus to shot when the player is in the Flue and the wumpus is in the Crooked Stair
  change the wumpus to shot when the player is in the Rift and the wumpus is in the Dry Vault
  change the wumpus to shot when the player is in the Bone Shelf and the wumpus is in the Cistern
  change the wumpus to shot when the player is in the Sump and the wumpus is in the Weeping Gallery
  change the wumpus to shot when the player is in the Crooked Stair and the wumpus is in the Throat
  change the wumpus to shot when the player is in the Dry Vault and the wumpus is in the Scree Fall
  change the wumpus to shot when the player is in the Cistern and the wumpus is in the Bellows
  change the wumpus to shot when the player is in the Weeping Gallery and the wumpus is in the Larder
  change the wumpus to shot when the player is in the Throat and the wumpus is in the Drum
  change the wumpus to shot when the player is in the Scree Fall and the wumpus is in the Dead Well
  change the bow to empty when the bow is one-arrow
  change the bow to one-arrow when the bow is two-arrows
  change the bow to two-arrows when the bow is three-arrows
  award kill when the wumpus is shot
  win kill-wumpus when the wumpus is shot
  phrase arrow-missed when not the wumpus is shot
  change the wumpus to hunting when the wumpus is stirring and not the wumpus is shot
  change the wumpus to stirring when the wumpus is sleeping and not the wumpus is shot
  move the wumpus to a random adjacent room when not the wumpus is shot

define action shooting-east
  grammar
    shoot east
    fire east
    shoot arrow east
    fire arrow east
  the player must hold the bow: shoot-no-bow
  refuse when the bow is empty: shoot-no-arrows
  change the wumpus to shot when the player is in the Cave Mouth and the wumpus is in the Font
  change the wumpus to shot when the player is in the Font and the wumpus is in the Flue
  change the wumpus to shot when the player is in the Flue and the wumpus is in the Rift
  change the wumpus to shot when the player is in the Bone Shelf and the wumpus is in the Sump
  change the wumpus to shot when the player is in the Sump and the wumpus is in the Crooked Stair
  change the wumpus to shot when the player is in the Crooked Stair and the wumpus is in the Dry Vault
  change the wumpus to shot when the player is in the Cistern and the wumpus is in the Weeping Gallery
  change the wumpus to shot when the player is in the Weeping Gallery and the wumpus is in the Throat
  change the wumpus to shot when the player is in the Throat and the wumpus is in the Scree Fall
  change the wumpus to shot when the player is in the Bellows and the wumpus is in the Larder
  change the wumpus to shot when the player is in the Larder and the wumpus is in the Drum
  change the wumpus to shot when the player is in the Drum and the wumpus is in the Dead Well
  change the bow to empty when the bow is one-arrow
  change the bow to one-arrow when the bow is two-arrows
  change the bow to two-arrows when the bow is three-arrows
  award kill when the wumpus is shot
  win kill-wumpus when the wumpus is shot
  phrase arrow-missed when not the wumpus is shot
  change the wumpus to hunting when the wumpus is stirring and not the wumpus is shot
  change the wumpus to stirring when the wumpus is sleeping and not the wumpus is shot
  move the wumpus to a random adjacent room when not the wumpus is shot

define action shooting-west
  grammar
    shoot west
    fire west
    shoot arrow west
    fire arrow west
  the player must hold the bow: shoot-no-bow
  refuse when the bow is empty: shoot-no-arrows
  change the wumpus to shot when the player is in the Font and the wumpus is in the Cave Mouth
  change the wumpus to shot when the player is in the Flue and the wumpus is in the Font
  change the wumpus to shot when the player is in the Rift and the wumpus is in the Flue
  change the wumpus to shot when the player is in the Sump and the wumpus is in the Bone Shelf
  change the wumpus to shot when the player is in the Crooked Stair and the wumpus is in the Sump
  change the wumpus to shot when the player is in the Dry Vault and the wumpus is in the Crooked Stair
  change the wumpus to shot when the player is in the Weeping Gallery and the wumpus is in the Cistern
  change the wumpus to shot when the player is in the Throat and the wumpus is in the Weeping Gallery
  change the wumpus to shot when the player is in the Scree Fall and the wumpus is in the Throat
  change the wumpus to shot when the player is in the Larder and the wumpus is in the Bellows
  change the wumpus to shot when the player is in the Drum and the wumpus is in the Larder
  change the wumpus to shot when the player is in the Dead Well and the wumpus is in the Drum
  change the bow to empty when the bow is one-arrow
  change the bow to one-arrow when the bow is two-arrows
  change the bow to two-arrows when the bow is three-arrows
  award kill when the wumpus is shot
  win kill-wumpus when the wumpus is shot
  phrase arrow-missed when not the wumpus is shot
  change the wumpus to hunting when the wumpus is stirring and not the wumpus is shot
  change the wumpus to stirring when the wumpus is sleeping and not the wumpus is shot
  move the wumpus to a random adjacent room when not the wumpus is shot


## =========================================================================
## THE HUNT - once it is awake and looking, it finds you.
## =========================================================================

define sequence the hunt
  when the wumpus becomes hunting
    phrase wumpus-hunting
  8 turns later
    kill the player run-down when not the wumpus is shot
end sequence

## =========================================================================
## TEXT
## =========================================================================

define phrases en-US
  eaten:
    The dark ahead of you is not dark, it is bulk, and it has been waiting
    for you to finish walking into it.

    *** You have been eaten by the wumpus ***
  swallowed:
    The floor is not floor. It takes your leg to the hip and then the rest
    of you, without hurrying, and without any sound at all.

    *** You have fallen into the slime pit ***
  kill-wumpus:
    You loose. The arrow goes out into the black, strikes something that is
    not rock, and buries itself.

    The cave fills with a sound you will be hearing for the rest of your
    life. Then it stops, and a great deal of weight settles onto the floor,
    and the cave is only a cave again.

    *** You have killed the wumpus ***
  walked-out:
    You come up out of the mouth into the last of the light, and you keep
    walking, and you do not look back at the hill until you are a mile from
    it.

    The wumpus is still in there. It will be in there tomorrow.

    *** You left the cave alive ***
  run-down:
    It comes through the dark at a speed nothing that size has any business
    reaching, and it turns out not to be blind after all. Or it turns out
    not to need to be.

    *** The wumpus ran you down ***
  arrow-missed:
    You loose into the dark. The arrow strikes bare rock somewhere past it
    and clatters away down a slope you cannot see.

    Something very large shifts its weight, and stops, and listens.
  shoot-no-bow:
    You would need the bow for that.
  shoot-no-arrows:
    The quiver is empty. Whatever happens next happens without arrows.
  arrows-three:
    A short bow, drawn smooth at the grip by somebody else's hands. Three
    arrows in the quiver.
  arrows-two:
    A short bow, drawn smooth at the grip by somebody else's hands. Two
    arrows left.
  arrows-one:
    A short bow, drawn smooth at the grip by somebody else's hands. One
    arrow left.
  arrows-none:
    A short bow, and an empty quiver.
  wumpus-hunting:
    Somewhere behind you, or below you, something stands up.

    It has stopped guessing where you are.
  chart-text:
    The chart is a square, four rooms by four, with north at the top:{br}
    {br}
    Cave Mouth - Font - Flue - Rift{br}
    Bone Shelf - Sump - Crooked Stair - Dry Vault{br}
    Cistern - Weeping Gallery - Throat - Scree Fall{br}
    Bellows - Larder - Drum - Dead Well{br}
    {br}
    Every room joins the rooms beside it in its row and the rooms above and
    below it in its column. Nothing joins on a diagonal. The mouth is the
    top left corner, and the way out is north from it.{br}
    {br}
    Along the bottom, in a different hand and a good deal less carefully:{br}
    BLOOD ON THE WALLS MEANS IT IS NEXT DOOR. SLIME MEANS THE PIT IS.{br}
    NEITHER ONE TELLS YOU WHICH SIDE.{br}
    WORK IT OUT BEFORE YOU SPEND AN ARROW.

## =========================================================================
## THE START - the hazards land here, and never beside the mouth.
## =========================================================================

before the game starts
  change the player to the hunter
  select randomly
    move the wumpus to the Throat
    move the slime pit to the Cistern
  or
    move the wumpus to the Dead Well
    move the slime pit to the Flue
  or
    move the wumpus to the Sump
    move the slime pit to the Scree Fall
  or
    move the wumpus to the Larder
    move the slime pit to the Rift
  or
    move the wumpus to the Dry Vault
    move the slime pit to the Weeping Gallery
  or
    move the wumpus to the Cistern
    move the slime pit to the Drum
  or
    move the wumpus to the Rift
    move the slime pit to the Bellows
  or
    move the wumpus to the Crooked Stair
    move the slime pit to the Dead Well
  end select
end before
