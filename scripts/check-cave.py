#!/usr/bin/env python3
"""Check that everything the story says about adjacency agrees with its map.

Chord has no adjacency predicate, so the cave's neighbours are written out by
hand in four places besides the map itself: each room's tunnel list, each
room's blood and slime warnings, the first-blood daemon, and the arrow flights
in the six shooting actions. This script compiles the story, reads the map the
compiler built (the Cave region's exit table, with the reverse of every tunnel
inferred), and checks every one of those places against it. It also checks the
four properties docs/cave-map.md requires of the map, and the start layouts.

Run from the project root:  python scripts/check-cave.py
Exits non-zero, naming each disagreement, if anything is wrong.
"""

import json
import re
import subprocess
import sys
from collections import deque
from pathlib import Path

STORY = Path(__file__).resolve().parent.parent / "wumpus-sharpee.story"

# Clockwise from north: the order the tunnel lists are written in.
COMPASS = ["north", "northeast", "east", "southeast",
           "south", "southwest", "west", "northwest"]
OPPOSITE = {d: COMPASS[(i + 4) % 8] for i, d in enumerate(COMPASS)}
MAX_FLIGHT = 4
MIN_START_DISTANCE = 3

problems = []


def problem(message):
    problems.append(message)


def compile_ir():
    npx = "npx.cmd" if sys.platform == "win32" else "npx"
    result = subprocess.run([npx, "sharpee", "compose", STORY.name],
                            cwd=STORY.parent, capture_output=True, text=True)
    if result.returncode != 0:
        sys.exit("compose failed:\n" + result.stderr + result.stdout)
    return json.loads(result.stdout)


def build_map(ir):
    """room name -> {direction: room name}, with reverses inferred."""
    names = {e["id"]: e["name"] for e in ir["entities"]}
    rooms = {e["name"] for e in ir["entities"]
             if any(k["name"] == "room" for k in e.get("kinds", []))}
    exits = {room: {} for room in rooms}
    for e in ir["entities"]:
        for x in e.get("exits") or []:
            here, there = e["name"], names[x["to"]["id"]]
            exits[here][x["direction"]] = there
            if not x.get("oneWay"):
                exits[there].setdefault(OPPOSITE[x["direction"]], here)
    return exits


def rooms_in(text, thing):
    """Every `the <thing> is in the <Room>` in a condition."""
    return set(re.findall(rf"the {thing} is in the ([A-Z][A-Za-z ]+?)(?=\)| or |$|:)", text))


def blocks(source):
    """`create the <Room>, a room` blocks, by room name."""
    found = {}
    for m in re.finditer(r"^create the ([^\n,]+), a room\b.*?(?=^\S)", source, re.S | re.M):
        found[m.group(1)] = m.group(0)
    return found


def phrase_list(directions):
    ordered = [d for d in COMPASS if d in directions]
    if len(ordered) == 1:
        return ordered[0]
    return ", ".join(ordered[:-1]) + " and " + ordered[-1]


def distances(exits, start, blocked=()):
    seen = {start: 0}
    queue = deque([start])
    while queue:
        room = queue.popleft()
        for there in exits[room].values():
            if there not in seen and there not in blocked:
                seen[there] = seen[room] + 1
                queue.append(there)
    return seen


def check_topology(exits):
    neighbours = {r: frozenset(d.values()) for r, d in exits.items()}
    start = next(iter(exits))
    if len(distances(exits, start)) != len(exits):
        problem("the cave is not connected")
    for room, near in neighbours.items():
        if not 2 <= len(near) <= 5:
            problem(f"{room} has {len(near)} neighbours; the cave allows 2 to 5")
    seen = {}
    for room, near in neighbours.items():
        if near in seen:
            problem(f"{room} and {seen[near]} have the same neighbours, "
                    "so a wumpus in either reads the same from everywhere")
        seen[near] = room
    return neighbours


def check_rooms(source, exits, neighbours):
    found = blocks(source)
    if set(found) != set(exits):
        problem(f"room blocks {sorted(set(found) ^ set(exits))} do not match the map")
    for room, block in found.items():
        tunnels = re.search(r"phrase tunnels:\n\s+(.+)", block)
        want = f"Tunnels lead {phrase_list(exits[room])}."
        if not tunnels or tunnels.group(1).strip() != want:
            problem(f"{room}'s tunnel list should read {want!r}")
        for thing in ("wumpus", "slime pit"):
            detail = re.search(rf"phrase detail while (the {thing} is in .*):", block)
            got = rooms_in(detail.group(1), thing) if detail else set()
            if got != neighbours[room]:
                problem(f"{room}'s {thing} warning names {sorted(got)}, "
                        f"its neighbours are {sorted(neighbours[room])}")


def check_first_blood(source, neighbours):
    lines = re.findall(r"change the story to warned when the player is in the (.+?) and \((.+)\)", source)
    got = {room: rooms_in(cond, "wumpus") for room, cond in lines}
    for room, near in neighbours.items():
        if got.get(room) != near:
            problem(f"the first-blood line for {room} names {sorted(got.get(room, []))}, "
                    f"its neighbours are {sorted(near)}")


def flight(exits, room, direction):
    path = []
    while direction in exits[room] and len(path) < MAX_FLIGHT:
        room = exits[room][direction]
        path.append(room)
    return path


def check_shooting(source, exits):
    actions = re.findall(r"^define action shooting-(\w+)\n(.*?)(?=^\S)", source, re.S | re.M)
    shot = {d for d, _ in actions}
    used = {d for room in exits.values() for d in room}
    if shot != used:
        problem(f"shooting actions cover {sorted(shot)}, the tunnels run {sorted(used)}")
    positions = 0
    for direction, body in actions:
        if not re.search(rf"^    shoot or fire \[arrow\] {direction} or \w+$", body, re.M):
            problem(f"shooting-{direction} has no `shoot or fire [arrow] {direction}` grammar")
        got = {room: rooms_in(cond, "wumpus") for room, cond in re.findall(
            r"change the wumpus to shot when the player is in the (.+?) and \(?(the wumpus is in .*?)\)?$",
            body, re.M)}
        for room in exits:
            want = set(flight(exits, room, direction))
            positions += bool(want)
            if got.get(room, set()) != want:
                problem(f"shooting {direction} from {room} should reach {sorted(want)}, "
                        f"the action has {sorted(got.get(room, []))}")
    for example in re.findall(r"SHOOT\s+([A-Z]+)", source):
        if example.lower() in COMPASS and example.lower() not in shot:
            problem(f"the text tells the player to SHOOT {example}, which no action parses")
    return positions


def check_starts(source, exits, neighbours):
    start = source[source.index("before the game starts"):]
    layouts = re.findall(r"move the wumpus to the (.+)\n\s+move the slime pit to the (.+)\n"
                         r"\s+move the hunter to the (.+)\n\s+change the (.+) to seen-once", start)
    if not layouts:
        problem("no start layouts found")
    for wumpus, pit, hunter, seen in layouts:
        tag = f"layout wumpus={wumpus} pit={pit} start={hunter}"
        if seen != hunter:
            problem(f"{tag}: marks {seen} seen, not the start room")
        if hunter in (wumpus, pit) or wumpus == pit:
            problem(f"{tag}: two of the three share a room")
        if wumpus in neighbours[hunter] or pit in neighbours[hunter]:
            problem(f"{tag}: the start room shows a warning")
        if distances(exits, hunter).get(wumpus, 0) < MIN_START_DISTANCE:
            problem(f"{tag}: the start is fewer than {MIN_START_DISTANCE} rooms from the wumpus")
        safe = distances(exits, hunter, blocked=(wumpus, pit))
        if not any(flight(exits, room, d)[:1] and wumpus in flight(exits, room, d)
                   for room in safe for d in exits[room]):
            problem(f"{tag}: no safe room has a shot at the wumpus")
    return len(layouts)


def main():
    source = STORY.read_text(encoding="utf-8")
    exits = build_map(compile_ir())
    neighbours = check_topology(exits)
    check_rooms(source, exits, neighbours)
    check_first_blood(source, neighbours)
    positions = check_shooting(source, exits)
    layouts = check_starts(source, exits, neighbours)
    tunnels = sum(len(d) for d in exits.values()) // 2
    if problems:
        print("\n".join(problems))
        sys.exit(f"check-cave: {len(problems)} problem(s)")
    print(f"check-cave: ok - {len(exits)} rooms, {tunnels} tunnels, "
          f"{positions} firing positions, {layouts} start layouts")


if __name__ == "__main__":
    main()
