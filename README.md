# Hunt the Wumpus

Twenty-five dark rooms, one wumpus, one bottomless pit, and one arrow.

Play it on IF Hub: https://johnesco.github.io/ifhub/app.html?game=wumpus-sharpee

Written in [Chord](https://sharpee.net/chord/) for the [Sharpee](https://sharpee.net) engine. The whole game is `wumpus-sharpee.story`.

## Building

This game is built and published from the Sharpee workspace, which holds the shared tooling:

```
npx sharpee play                           # play in the terminal
npx sharpee test                           # replay wumpus-sharpee.tests.json
python ../tools/build.py wumpus-sharpee --force    # gates, build, tests, lay out the hub folder
python C:/code/ifhub/tools/ship.py wumpus-sharpee  # publish and list on IF Hub
```

## How it plays

You wake deep in a cave, in a quiet room well away from the wumpus, with no way
out and one arrow on the string. The cave is a five-by-five grid of twenty-five
rooms, but eleven of its tunnels have fallen in and six diagonal shafts have been
cut through, so no room is where its place on the grid says it should be.
Somewhere in it are a wumpus and a bottomless slime pit, in different rooms,
placed fresh each game.

- A room **next to** the wumpus has blood on the walls.
- A room **next to** the pit has slime on the walls.
- A room can have both, and neither warning tells you which tunnel it came from.

Walk into the wumpus and it eats you. Walk into the pit and you go down it. You
never have to enter either one to win: every layout is checked to be winnable
without ever setting foot in either. Stand somewhere safe and `SHOOT` down the
tunnel you think leads to it — `SHOOT EAST`, `SHOOT NORTHWEST`, whichever way the
tunnel runs.

One arrow. It flies straight on for as long as the tunnel does, up to four rooms
down a gallery, so a wumpus can be shot from further off than its neighbours. A
shot that does not find it wakes it, and it finds you.

`MAP` does not draw you a map — nobody down here has one. It stirs what you know
about the room you are standing in: whether this is the first time, whether you
have been through once already, or whether you have crossed it often enough to
walk it in the dark. The cave itself is yours to draw, from the tunnel list that
prints every turn. `READ NOTE` has the rules.

The first time you find blood, the game stops and explains what it means. After
that you are on your own.

## Walkthrough

`walkthrough.txt` at the root is the tests document's main line, and it wins.
It is written against seed 42, so it only works under `sharpee test`; a live game
places the hazards somewhere else.
