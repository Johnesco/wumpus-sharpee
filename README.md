# Hunt the Wumpus

Sixteen dark rooms, one wumpus, one bottomless pit, and three arrows to tell them apart.

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

The cave is a four-by-four grid, sixteen rooms, no diagonals. Somewhere in it are
a wumpus and a bottomless slime pit, in different rooms, placed fresh each game.

- A room **next to** the wumpus has blood on the walls.
- A room **next to** the pit has slime on the walls.
- A room can have both, and neither warning tells you which side it came from.

Walk into the wumpus and it eats you. Walk into the pit and you go down it. So you
never want to enter either one — you want to stand **next to** the wumpus and
`SHOOT NORTH` (or south, east, west) into the room you think it is in.

Three arrows. A miss wastes one, wakes the wumpus a little, and moves it somewhere
else, which is worse than losing the arrow. Wake it all the way and it comes
looking for you.

You carry a chart of the cave — `READ CHART`. You can also give up and walk out
north from the Cave Mouth, which counts for something, but not for much.

## Walkthrough

`walkthrough.txt` at the root is the tests document's main line, and it wins.
It is written against seed 42, so it only works under `sharpee test`; a live game
places the hazards somewhere else.
