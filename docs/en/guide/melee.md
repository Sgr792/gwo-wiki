---
title: Standalone Melee Weapons
order: 6
category:
  - Content-Pack Authoring
---

## 25. Independent melee state

Standalone melee weapons are not firearms with zero ammunition. Place definitions under `weapons/melee/` and use a melee render/state contract with equip, idle, inspect, sprint, holster, and attack actions.

Common attack families are discovered from existing clips:

- `melee_miss_*`
- `melee_hit_*`
- `melee_fatal_*`

The runtime can choose among all numbered variants without a fixed maximum. Keep attack recovery, hit timing, air swings, and interruption rules in the melee state machine. Use weapon-size-specific sound sets rather than firearm melee audio.

Validate first-person hands, third-person pose, offhand stow, fixed display, inspect audio, draw/holster audio, consecutive attacks, hits, misses, and fatal variants.
