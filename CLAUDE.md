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

A text treatment of the 1973 BASIC game. Sixteen rooms on a four-by-four grid
hold one wumpus and one bottomless slime pit. Rooms next to the wumpus show
blood; rooms next to the pit show slime; some show both. The player is a broke
hunter with a bow, three arrows, and a chart of the cave, and the whole game is
one deduction: work out which room holds the wumpus from warnings that never say
which side they came from, then stand next to it and shoot the right way.

The design goal is that the player never needs to enter a dangerous room to win,
and never has to draw a map — the chart is given, so the difficulty is inference,
not cartography.

## Design Documents

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
- Room descriptions do not list exits — the chart carries the topology.
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
- **Hazards never start in the entrance or next to it.** Every arm of the start
  block keeps the wumpus and the pit at least two rooms from the Cave Mouth, so the
  opening room is always clear of blood and slime.
- **A miss moves the wumpus.** It invalidates the player's deductions, which is
  what makes an arrow expensive. Inherited from the original.
- **The player is given the map.** A cave chart in the inventory lists all sixteen
  rooms and the grid. Drawing the map is not the interesting part.

## Current Feature Status

### Implemented
- [x] 16-room grid cave, plus the Hillside (the way out)
- [x] Randomised hazard placement, 8 hand-paired layouts
- [x] Blood and slime warnings, undirected, both can appear in one room
- [x] Death by wumpus and death by pit
- [x] Directional shooting (north/south/east/west), 48 map squares
- [x] Three arrows; a miss wakes the wumpus a stage and relocates it
- [x] The hunt: 8 turns after it starts hunting, it runs you down
- [x] Five endings: kill, eaten, pit, run down, walked out alive
- [x] Scoring with three ranks
- [x] Cave chart (in-game, readable)

### Planned
- [ ] Printable chart feelie in `feelies/` — blocked: the hub's Pages workflow
      copies `web lib assets audio sfx src` plus root files by extension, so a
      `feelies/` folder does not deploy today
- [ ] Superbats (`move the player to a random adjacent room`)
- [ ] A lantern on a burn clock, to cost the player something for wandering
- [ ] Sound (`assets/sfx/`) — blocked on the hub's flat-media gap
- [ ] More layouts, or a larger cave

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

- **`@sharpee/*` is pinned exactly, and the whole scope is pinned.** 5.3.1 ships
  broken for npm consumers (`ERR_PACKAGE_PATH_NOT_EXPORTED` on `./assertion-core`,
  which kills `sharpee test`). Pinning the nine direct dependencies is not enough —
  25 transitive `@sharpee/*` packages still resolve to 5.3.1 — so `package.json`
  carries an `overrides` block covering all 34. Drop it when a fixed release lands.
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
  Not yet played in a browser; not yet shipped.
