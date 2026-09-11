# Spike findings — Chord 3.6.0, Sharpee 5.3.0 (2026-09-10)

Run against a throwaway 2x2 cave before the real map was written. Each form was
gate-checked with `sharpee compose --check` and then played with `sharpee play`.

| Form | Verdict |
|---|---|
| `select randomly` with `move` statements in `before the game starts` | Works. Placement varies per run; `sharpee play` picks a fresh seed each time. |
| `phrase detail while the wumpus is in X or the wumpus is in Y:` on a room | Works. Two details on one room both fire and append in declaration order. |
| `on every turn while the wumpus is here` / `kill the player` in the header | Works, and collapses what would have been an `after the player entering` clause in all 16 rooms into two header lines. The room description renders first, then the death. |
| `move the wumpus to a random adjacent room` | Works. Adjacency as a *move destination* ships even though adjacency as a *condition* is an explicit ADR non-goal. |
| `define condition` referencing another `define condition` | Works. Conditions compose. |
| `concealed` on the wumpus | Needed. Without it the room prints "You can see wumpus here." one line before the death. |

## The one that bit

**`win` does not halt the statements after it.** A `win` that fires still lets the
rest of the action body run, so a naive fallthrough prints the miss text *after*
the ending:

```
> shoot east
The arrow goes into the dark and something very large stops breathing.

*** You have killed the wumpus ***

The arrow clatters off bare rock. Somewhere, something wakes up.
```

Every statement after a conditional `win` needs its own guard. The shape adopted
here sets a state on the hit, then keys both the `win` and the miss branch off
that state, so the lookup table stays flat and no condition is written twice:

```chord
  change the wumpus to shot when the player is in the Cave Mouth and the wumpus is in the Font
  ...
  win kill-wumpus when the wumpus is shot
  phrase arrow-missed when not the wumpus is shot
  move the wumpus to a random adjacent room when not the wumpus is shot
```

## Ordering trick for a one-way state ladder

Advancing a `states: sleeping, stirring, hunting` ladder by one step per miss has
to be written **backwards**, or a sleeping wumpus advances twice in one turn as
the statements run in order:

```chord
  change the wumpus to hunting when the wumpus is stirring and not the wumpus is shot
  change the wumpus to stirring when the wumpus is sleeping and not the wumpus is shot
```

## Toolchain

`@sharpee/*` 5.3.1 is broken for npm consumers (`ERR_PACKAGE_PATH_NOT_EXPORTED`
on `./assertion-core`, which kills `sharpee test`). Pinning the nine direct
dependencies to 5.3.0 is **not** enough — 25 transitive `@sharpee/*` packages
still resolve to 5.3.1. This project pins the whole scope with an npm
`overrides` block.

---

# Second pass — the irregular cave (2026-09-11)

Found while rebuilding the game as 25 rooms on a cut lattice.

| Form | Verdict |
|---|---|
| Diagonal exits (`northeast to the Sump`) | Work. The direction set is eight compass points plus up and down, so a lattice can carry corner-wise shafts. |
| `prologue:` in the story header | Exists, and takes multi-line prose with blank-line paragraph breaks. The terminal client does not print it; the browser client does. |
| `phrase detail` with no `while` | Refused — `analysis.detail-unconditional`: *"unconditional detail belongs in the description."* |
| Multi-word entity heads in tests `states` | Never match. `wumpus.location = Drum` passes; `slime pit.location = Cistern` fails silently because the head is two words. |

## `move the player` is a silent no-op in the start block

This one cost the most. `before the game starts` accepts

```chord
  move the player to the Shambles
```

gate-clean, and then **does nothing** — the character stays wherever `starts in`
put them. The first sign of it was the player waking up inside the slime pit and
dying on turn one, because the hazards had moved and the player had not.

Naming the character entity works:

```chord
before the game starts
  change the player to the hunter
  select randomly
    move the wumpus to the Drum
    move the slime pit to the Cistern
    move the hunter to the Shambles
  ...
```

`the player` presumably is not bound yet at that point in the boot. Nothing
warns; the story simply starts in the wrong room.

## A `detail` cannot carry a line break

`phrase detail while …:` appends inside the description's paragraph, and it
**silently drops `{br}`** — at the start of the text, in the middle, anywhere.
So a detail can never be given a line of its own.

That matters for anything the player needs to find at a glance. The tunnel list
here ("Tunnels lead north and east.") began as a detail and rendered as the tail
of a five-sentence paragraph. It is now a header daemon instead:

```chord
  on every turn
    phrase tunnels-cistern when the player is in the Cistern
    phrase tunnels-font when the player is in the Font
    ...
  end on
```

A bare `on every turn` with no `while` is legal. Daemon output is its own block,
so the tunnel list lands under the room description with a blank line above it,
which is what the original did with TUNNELS LEAD TO. It also correctly prints
nothing on a turn the player dies, because the kill ends the turn first.

---

# Third pass — the tutorial and the recall command (2026-09-11)

## A story state cannot name an absence

`states: unblooded, blooded` is refused — `analysis.negated-state`: *"`unblooded`
names the absence of `blooded`, not a condition of the story."* The latch for
"has the player seen blood yet" is `states: searching, warned` instead. Both
names say what the story *is*.

## Asking about the room the player is standing in

MAP reports how well the player knows the room they are in. The obvious shape is
one line per room per rung — 75 of them. The short way is an **open condition**:
one that mentions `it` is a predicate over entities, and `any <condition>` asks
whether anything satisfies it.

```chord
define condition here-new: it is seen-once and the player is in it
define condition here-again: it is seen-twice and the player is in it
define condition here-known: it is well-known and the player is in it

define action recalling
  grammar
    map
    remember
  phrase recall-new when any here-new
  phrase recall-again when any here-again
  phrase recall-known when any here-known
```

`the player is in it` is legal, and `any` finds the single room that is both at
that rung and holding the player. Three lines instead of seventy-five.

The rungs themselves are an ordinary one-way ladder stepped on the way in,
written backwards so a room cannot climb two rungs in one turn:

```chord
  after the player entering
    change the Larder to well-known when the Larder is seen-twice
    change the Larder to seen-twice when the Larder is seen-once
    change the Larder to seen-once when the Larder is strange
  end after
```

**`after the player entering` does not fire for the room the player starts in.**
Being placed there is not entering it, so the starting room stays on rung zero
and reports itself as never visited while the player is standing in it. The
start block seeds it: each arm of the `select randomly` ends with
`change <that room> to seen-once`.

## The auto-map that was built and then removed

An earlier pass drew a real ASCII map from live world state, as an ADR-259 text
hatch (`define text mapgrid from "./map.ts"`). It worked, and it is gone — the
design went somewhere better, and the findings are kept because the next person
to want computed text will hit all of them:

- **`sharpee build` handles a hatch-bearing story.** `hasHatches` selects a build
  route rather than failing it; the build generates `src/hatch-modules.ts`, checks
  the bindings resolve, and prints a notice that the bundle now carries author code.
- **A text producer can read the world.** Entities are enumerable by walking the
  id space, which is **base 36** with a kind prefix: `r01`..`r0p` for 25 rooms,
  `a02` the wumpus, `o01` the slime pit. `r10` does not exist, so a decimal probe
  stops at `r09` and looks like a dead end. `entity.traits.room` carries `visited`
  and `exits` (`{EAST: {destination: 'r02'}}`), and `world.getContainingRoom(id)`
  locates anything.
- **The prose pipeline collapses all whitespace**, which flattens any ASCII art.
  The exemption is on the phrase: `{ kind: 'literal', whitespace: 'verbatim', … }`.
- **That fixes the content, not the rendering.** The spaces reach the DOM and the
  browser collapses them again, so `white-space: pre-wrap` is still needed in the
  author stylesheet. A stale cached stylesheet looks exactly like a rule that does
  not work: the served file was correct while the loaded sheet had zero rules.
- **The font is built in, the bracket spelling is not.** `decorations.css` ships
  an ADR-174 vocabulary — `sharpee-font-mono`, `sharpee-code`, `sharpee-command` —
  all styled monospace. Writing `[font-mono:…]` in Chord phrase text does **not**
  reach it at 3.6.0: it renders literally in both the terminal and the browser.
  Attaching it structurally from a hatch does work, and produces a real
  `<span class="sharpee-font-mono">`:

  ```ts
  return {
    kind: 'literal',
    whitespace: 'verbatim',
    decorations: [{ className: 'sharpee-font-mono', content: [grid] }],
    text: grid,
  };
  ```

  So: font from the platform, whitespace from one line of author CSS.
