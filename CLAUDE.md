# Hunt the Wumpus — Claude Project Memory

> Project-specific context for Claude Code sessions in this game. Shared context (toolchain, commands, testing standard, Chord conventions) comes from the workspace `CLAUDE.md` one level up, which Claude Code loads automatically. Do not restate it here; link to it.

<!-- workspace: ../CLAUDE.md -->

## Project Identity

**Name:** Hunt the Wumpus
**Purpose:** Sixteen dark rooms, one wumpus, one bottomless pit, and three arrows to tell them apart.
**Engine:** Sharpee, written in Chord (`wumpus-sharpee.story`)
**Repository:** https://github.com/Johnesco/wumpus-sharpee
**Live:** https://johnesco.github.io/ifhub/app.html?game=wumpus-sharpee
**Created:** 2026-09-10 with `tools/new_game.py`

## Project Context

A text treatment of the 1973 BASIC game. Twenty-five rooms on a cut five-by-five
lattice hold one wumpus and one bottomless slime pit. Rooms next to the wumpus
show blood; rooms next to the pit show slime; some show both. The player wakes
somewhere in the middle of it with one arrow and no way out, and the whole game
is one deduction: work out which room holds the wumpus from warnings that never
say which side they came from, then stand somewhere safe and shoot down the right
tunnel.

The player never needs to enter a dangerous room to win — that is checked, not
hoped for (see `docs/cave-map.md`). There is no escape ending: the goal is the
kill, and the only other endings are the three ways of dying.

## Design Documents

- `docs/cave-map.md` — the map, and the four properties a cave has to have here
  for the game to be winnable by deduction. Read it before touching the topology.
- `docs/spike-findings.md` — what the language does and does not do for this
  game, proved by compiling and playing it rather than by reading docs. Read it
  before changing the shooting actions or the start block.

The story file is the rest of the design record.

## Writing Style Rules

- Second person, present tense, past tense for what the cave has already done.
- Warnings are *identical everywhere*. Blood and slime read the same in every
  room on purpose: they are a signal the player learns, not a mood. Never vary
  them for flavour.
- Never say which direction a warning came from. The ambiguity is the puzzle.
- Room descriptions do not list exits. The tunnel list is a separate line, put
  there by the header daemon, so it reads as a menu rather than as prose.
- Concrete nouns, no adjective stacks. The cave is unpleasant because of what is
  in it, not because the prose says it is unpleasant.

## File Structure Overview

```
wumpus-sharpee/
├── CLAUDE.md                THIS FILE
├── README.md                public documentation
├── wumpus-sharpee.story           the game; import .chord fragments as it grows
├── wumpus-sharpee.tests.json        tests document, replayed by sharpee test
├── wumpus-sharpee.config.json       IFID
├── ifhub.conf               the IF Hub card
├── browser/wumpus-sharpee.css       author CSS override, loaded last
├── assets/  feelies/        media the story uses; extras the player opens
├── .github/                 issue and PR templates from sdlc-baseline
└── docs/                    design docs (optional)
```

Built output at the root (`play.html`, `game.js`, `*.css`, `lib/`, `tests.html`, `walkthrough*.txt`) is written by the workspace build and committed. `dist/` and `node_modules/` are ignored.

## Key Design Decisions (do not change without discussion)

- **The wumpus and the slime pit are entities with locations, not properties of
  rooms.** Everything else follows from this: warnings, deaths and arrows are all
  plain conditions over where those two things are, and they stay correct when the
  wumpus moves. Making them room states instead would break the moving wumpus.
- **Adjacency is authored, not computed.** Chord has no adjacency predicate and
  the upstream ADR names that a deliberate non-goal. The map is hand-drawn, so its
  adjacency is authoring-time data: each room names its own neighbours in its two
  `detail` phrases, and each shooting action carries one `change` line per square
  of the map. Pure Chord, no TypeScript hatch — a hatch here would be misuse under
  the rule on sharpee.net (*"if the language can already express what the hatch
  does, the hatch is misuse"*).
- **A `win` does not stop the rest of an action body.** Every statement after a
  conditional `win` needs its own guard or its text prints after the ending. The
  shooting actions set the wumpus to `shot` and key both the win and the miss off
  that state. See `docs/spike-findings.md`.
- **You wake deep in the cave and there is no way out.** The goal is the kill,
  so there is no entrance, no escape ending, and no reward for leaving. The start
  room is drawn at random from the layout and is always clear of both hazards and
  both warnings, and at least three rooms from the wumpus.
- **One arrow, and a miss is fatal.** Any shot that does not find the wumpus wakes
  it and it finds you — including a shot into solid rock, which needs no special
  case and costs no extra conditions. This is deliberately the harshest version of
  the rule; it is why the tunnel list has to be legible.
- **Arrows fly straight on while the tunnel does.** A shot can cross up to four
  rooms down a gallery, so sight-lines are a second thing to work out and a
  wumpus can be killed from further off than its neighbours. The room list in each
  `change the wumpus to shot` line is that flight path.
- **There is no map in the game, and `MAP` is not a map.** The cave is drawn on
  paper by the player, from the tunnel list printed every turn. `MAP` (also
  `REMEMBER`, `RECALL`, `THINK`) instead stirs what the hunter knows about the
  room they are standing in — first time here, been here once, been here often
  enough to walk it in the dark. It is orientation, not cartography, and it never
  tells the player anything they did not earn.
- **The whole game is Chord. No TypeScript.** An auto-drawing ASCII map was built
  as a text hatch and then removed when the design changed; `docs/spike-findings.md`
  keeps what was learned. Nothing in the game now needs computed text, so nothing
  reaches for a hatch — which is the upstream rule anyway: if the language can say
  it, a hatch is misuse.
- **The first blood is taught, once.** The moment the player stands in a room
  with blood, a one-shot passage explains what fresh blood means, that it never
  says which tunnel, and that the answer is to shoot rather than to go and look.
  It is latched on a story state (`searching` -> `warned`) so it can never repeat.
- **`move the hunter`, never `move the player`, in the start block.** The latter
  is gate-clean and does nothing, which puts the player in whatever room
  `starts in` named while the hazards move around them. See
  `docs/spike-findings.md`.

## Current Feature Status

### Implemented
- [x] 25-room cave: a 5x5 lattice with 11 tunnels cut and 6 diagonal shafts added
- [x] Machine-checked topology — connected, degree 2-5, unique warning signatures,
      every legal layout winnable without entering a hazard
- [x] Randomised wumpus, pit and start room over 10 layouts
- [x] Blood and slime warnings, undirected, both can appear in one room
- [x] Death by wumpus and death by pit
- [x] Shooting in all 8 compass directions, 74 firing positions
- [x] Crooked arrows — a shot carries on while the tunnel runs straight, up to 4 rooms
- [x] One arrow; any miss is fatal
- [x] Four endings: kill, eaten, pit, woke it
- [x] Tunnel list every turn, on its own line
- [x] Prologue, and a hunter's note carrying the rules (but not the map)
- [x] `MAP` / `REMEMBER` / `RECALL` — how well you know the room you are in,
      over a three-rung familiarity ladder per room
- [x] One-shot first-blood tutorial

- [x] `walkthrough-guide.txt` — the hub's Commands tab. Written as a strategy
      guide, not a command list, because the cave is randomised and a list of
      moves is wrong for every player but one. Its `> command` lines mirror
      `walkthrough.txt` exactly so the hub can still pair them with the
      transcript — **keep them in step if either file changes.**

### Planned
- [ ] Printable blank 5x5 grid feelie to map on — blocked: the hub's Pages workflow
      copies `web lib assets audio sfx src` plus root files by extension, so a
      `feelies/` folder does not deploy today
- [ ] Superbats (`move the hunter to a random adjacent room`)
- [ ] A lantern on a burn clock, to cost the player something for wandering
- [ ] Sound (`assets/sfx/`) — blocked on the hub's flat-media gap
- [ ] A second pit, if playtesting says the cave is too safe
- [ ] A first-slime tutorial to match the first-blood one, if it reads as missing

## Working in this project

**SDLC profile:** core

Shared rules live in the workspace: `../CLAUDE.md` (loaded automatically), `../reference/chord-cookbook.md` (Chord lessons that are true here), `../reference/tests-document.md` (the tests document). Build and ship from the workspace:

```bash
python ../tools/build.py wumpus-sharpee --force
python C:/code/ifhub/tools/ship.py wumpus-sharpee
```

This project uses the [sdlc-baseline](https://github.com/Johnesco/sdlc-baseline) universal workflow. Claude must follow these canonical docs:

- [Workflow (7 steps)](https://github.com/Johnesco/sdlc-baseline/blob/main/docs/workflow.md) — ticket-first, decide before you build, documentation-aware
- [Roles & hat-switch protocol](https://github.com/Johnesco/sdlc-baseline/blob/main/docs/roles.md) — PO / BA / Dev / Documenter / QA
- [Definition of Done](https://github.com/Johnesco/sdlc-baseline/blob/main/docs/definition-of-done.md) — exit criteria by issue type, verification-first
- [Severity & priority matrix](https://github.com/Johnesco/sdlc-baseline/blob/main/docs/severity-matrix.md)
- [Commit, PR, and branch conventions](https://github.com/Johnesco/sdlc-baseline/blob/main/docs/commit-conventions.md)
- [Release management](https://github.com/Johnesco/sdlc-baseline/blob/main/docs/release-management.md)
- [Testing](https://github.com/Johnesco/sdlc-baseline/blob/main/docs/testing.md) — the local gate here is `python ../tools/build.py wumpus-sharpee`, which fails on any failed assertion
- [Backlog hygiene](https://github.com/Johnesco/sdlc-baseline/blob/main/docs/backlog-hygiene.md)
- [ADR protocol](https://github.com/Johnesco/sdlc-baseline/blob/main/docs/adrs.md)
- [Profiles](https://github.com/Johnesco/sdlc-baseline/blob/main/docs/profiles.md)

**Three non-negotiables:**

1. **No code without a ticket.** An Issue, or an ADR stub for a decision.
2. **Decide before you build.** Anything above a tuning tweak gets a six-line ADR stub first.
3. **Claude cannot QA its own work.** The Verify column is always human-owned.

### Project-specific deviations

- **`@sharpee/*` is pinned exactly, and the whole scope is pinned** with an npm
  `overrides` block covering every package. This started as a defence against
  a release that shipped broken for npm consumers and which plain `^` ranges pulled
  in through transitive dependencies even when the direct pins were correct. Keep
  the pinning: version drift between games is expected here, and each game bumps
  deliberately.
- **Watch for `walkthrough.coverage.json`.** If that marker file ever appears at
  the repo root, delete it before building. It tells `tools/build.py` to keep a
  room-sweeping walkthrough instead of deriving one from the tests document, and a
  room sweep cannot survive this game: two of the sixteen rooms kill you, so every
  command after the first lethal room records `Error: Engine is not running`.
  `walkthrough.txt` must stay the tests document's main line.

### Architecture Decisions

ADRs live in `docs/adr/` once the first one exists (index: `docs/adr/README.md`). Format, stub, and threshold rule: [sdlc-baseline `docs/adrs.md`](https://github.com/Johnesco/sdlc-baseline/blob/main/docs/adrs.md).

## Project History

### Recent Changes
- 2026-09-10: Scaffolded with `tools/new_game.py` (`sharpee init`, templates, sdlc-baseline GitHub templates).
- 2026-09-10: Spiked the mechanics on a throwaway 2x2 cave, then built the full
  game — 16 rooms, randomised hazards, four shooting actions, five endings.
  Story 0.1.0, 21 cards / 70 assertions across 5 lines, gate-clean and built.
- 2026-09-12: **Story 0.3.2 — recompiled on the current toolchain.** The two
  temporary workarounds taken on 2026-09-11 are both gone, because the release
  fixed what they stood in for:
  `RESTART` works after an ending again (and yields a genuinely fresh game, new
  layout and all), so the reload note is off the four endings; and the published
  `exports` maps name their subpaths, so `scripts/fix-sharpee-exports.mjs` and its
  `postinstall` hook are deleted — verified by a wiped `node_modules` and a clean
  `npm ci` with no shim at all. Also fixed a real bug the recompile exposed: the
  hunter's note told the player to SHOOT SOUTHWEST, a direction no tunnel in the
  cave uses, so it never parsed. The note's example directions are now derived
  from the map and cannot drift from it again.
- 2026-09-11: **Story 0.3.0.** Rebuilt the cave and the rules around three
  decisions: the grid was too easy to solve, the escape ending was competing with
  the actual goal, and a new player was given no way in.
  - The cave is now 25 rooms on a 5x5 lattice with 11 tunnels cut and 6 diagonal
    shafts added, checked by machine for connectivity, degree, unique warning
    signatures and winnability (`docs/cave-map.md`).
  - You wake deep in it, in a random clear room, with no way out and one arrow.
    A miss is fatal; arrows fly straight on while the tunnel does.
  - The tunnel list prints every turn, on its own line.
  - The first time you find blood, a one-shot passage explains what it means and
    that the answer is to shoot rather than to go and look.
  - `MAP` recalls how well you know the room you are standing in. An auto-drawing
    ASCII map was built first, as a TypeScript hatch, and removed when the design
    changed — the findings are kept in `docs/spike-findings.md`. The game is pure
    Chord again.
  - 22 cards / 77 assertions across 5 lines. Gate-clean, built, played in a
    browser. Not yet shipped to the hub.
