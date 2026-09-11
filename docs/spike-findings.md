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
