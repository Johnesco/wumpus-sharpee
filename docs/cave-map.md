# The cave

Twenty-five rooms on a five-by-five lattice. Eleven of the forty grid tunnels
are **cut** (rock falls) and six **diagonal shafts** are added, so the cave is
drawable on paper but cannot be solved by coordinate arithmetic: knowing a room
is "one east" of another tells you nothing about whether you can walk it.

North is up, west is left. Nothing joins on a diagonal unless it is drawn below.

```
    Cistern    -----      Font     -----      Flue     -----      Rift     -----     Eyrie
          \                |                   |                   |  \                |
   Bone Shelf  -----      Sump     ----- Crooked Stair -----   Dry Vault            Chimney
       |                                          \                |                   |
Weeping Gallery          Throat    -----   Scree Fall  -----     Anvil     -----   Cold Seep
       |  \                |  \                                    |
    Bellows    -----     Larder    -----      Drum             Dead Well   -----    Shambles
       |                   |                   |                   |  \                |
     Cellar    -----      Mire               Gullet    -----    Rookery    -----      Deep
```

`|` a tunnel straight down, `\` down-and-east, `/` down-and-west,
`-----` straight across. A blank gap is solid rock.

Horizontal joins, row by row (west to east):

- row 1: open Cistern-Font, Font-Flue, Flue-Rift, Rift-Eyrie
- row 2: open Bone Shelf-Sump, Sump-Crooked Stair, Crooked Stair-Dry Vault — **blocked** Dry Vault|Chimney
- row 3: open Throat-Scree Fall, Scree Fall-Anvil, Anvil-Cold Seep — **blocked** Weeping Gallery|Throat
- row 4: open Bellows-Larder, Larder-Drum, Dead Well-Shambles — **blocked** Drum|Dead Well
- row 5: open Cellar-Mire, Gullet-Rookery, Rookery-Deep — **blocked** Mire|Gullet

Every room and its tunnels:

| Room | Tunnels |
|---|---|
| the Cistern | east to Font, southeast to Sump |
| the Font | east to Flue, south to Sump, west to Cistern |
| the Flue | east to Rift, south to Crooked Stair, west to Font |
| the Rift | east to Eyrie, southeast to Chimney, south to Dry Vault, west to Flue |
| the Eyrie | south to Chimney, west to Rift |
| the Bone Shelf | east to Sump, south to Weeping Gallery |
| the Sump | north to Font, east to Crooked Stair, west to Bone Shelf, northwest to Cistern |
| the Crooked Stair | north to Flue, east to Dry Vault, southeast to Anvil, west to Sump |
| the Dry Vault | north to Rift, south to Anvil, west to Crooked Stair |
| the Chimney | north to Eyrie, south to Cold Seep, northwest to Rift |
| the Weeping Gallery | north to Bone Shelf, southeast to Larder, south to Bellows |
| the Throat | east to Scree Fall, southeast to Drum, south to Larder |
| the Scree Fall | east to Anvil, west to Throat |
| the Anvil | north to Dry Vault, east to Cold Seep, south to Dead Well, west to Scree Fall, northwest to Crooked Stair |
| the Cold Seep | north to Chimney, west to Anvil |
| the Bellows | north to Weeping Gallery, east to Larder, south to Cellar |
| the Larder | north to Throat, east to Drum, south to Mire, west to Bellows, northwest to Weeping Gallery |
| the Drum | south to Gullet, west to Larder, northwest to Throat |
| the Dead Well | north to Anvil, east to Shambles, southeast to Deep, south to Rookery |
| the Shambles | south to Deep, west to Dead Well |
| the Cellar | north to Bellows, east to Mire |
| the Mire | north to Larder, west to Cellar |
| the Gullet | north to Drum, east to Rookery |
| the Rookery | north to Dead Well, east to Deep, west to Gullet |
| the Deep | north to Shambles, west to Rookery, northwest to Dead Well |

## Why this shape

The map is not decorative — it is checked. A cave is only usable here if all of
the following hold, and the generator refuses to emit a story otherwise:

- **Connected.** Every room reachable from every other.
- **Degree 2 to 5.** No dead ends (a degree-1 room can be sealed off by a single
  hazard) and no hubs (a room with seven tunnels has blood on the walls almost
  always, which makes its reading worthless).
- **Every room has a unique set of neighbours.** Blood in a room means the wumpus
  is in one of that room's neighbours, so the reading the player gets for a wumpus
  at X is exactly X's neighbour set. If two rooms shared a neighbour set, a wumpus
  in either would look identical from everywhere in the cave and the game would be
  unwinnable by deduction. This check caught the Flue and the Dry Vault.
- **Every legal (wumpus, pit, start) triple is winnable** without ever standing in
  a hazard: from the start room there is a path, through safe rooms only, to a room
  adjacent to the wumpus. This check caught a wumpus in the Cistern with the pit in
  the Sump, where the only firing position was walled off behind the two hazards.

Current figures: 37 tunnels, average degree 2.96 (the original's dodecahedron is
exactly 3.0), longest arrow flight 4 rooms, and 32 of the 74 possible shots reach
past the first room.
