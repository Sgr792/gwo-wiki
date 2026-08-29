---
title: Standalone Melee Weapons
order: 6
category:
  - Content-Pack Authoring
---

## 25. Independent melee state

Standalone melee weapons are not firearms with zero ammunition. Place definitions under `weapons/melee/` and use a melee render/state contract with equip, idle, inspect, sprint, holster, and attack actions.

Define standalone-melee attacks explicitly in `melee.combos.*.attacks`. Names such as `swipe_01` and `stab_01` are authored clip names; the combo configuration owns selection order, damage timing, and chaining:

```json
{
  "id": "example:example_knife",
  "display_name": "Example Melee Weapon",
  "creative_category": "melee",
  "creative_sort": 10,
  "model_data": 2100,
  "damage": 7.0,
  "melee": {
    "enabled": true,
    "damage": 7.0,
    "range": 3.0,
    "angle": 42.0,
    "knockback": 0.35,
    "combos": {
      "primary": {
        "mode": "random",
        "reset_ms": 700,
        "attacks": [
          {
            "animation": "swipe_01",
            "duration_ms": 833,
            "commit_ms": 180,
            "chain_open_ms": 390
          },
          {
            "animation": "stab_01",
            "duration_ms": 833,
            "commit_ms": 250,
            "chain_open_ms": 470
          }
        ]
      }
    }
  },
  "render": "weapons/melee/render/example_knife.render.json"
}
```

`melee_miss_*`, `melee_hit_*`, and `melee_fatal_*` are firearm-melee result sets. Do not present them as the standalone weapon's primary combo unless that standalone definition explicitly lists those exact clips. Keep attack recovery, hit timing, air swings, and interruption rules in the standalone melee state machine. Use weapon-size-specific sound sets rather than firearm-melee audio.

Validate first-person hands, third-person pose, offhand stow, fixed display, inspect audio, draw/holster audio, consecutive attacks, hits, misses, and fatal variants.

### 25.1 Beginner order and timing

Do not convert a firearm by only deleting ammunition fields. Create gameplay under `weapons/melee/` and rendering under `weapons/melee/render/`. Begin with `static_idle`, `draw_first`, `holster`, and one attack. Verify reference space before adding the remaining combo, inspect, sprint, super sprint, hit variants, and audio.

`duration_ms` is total action-state time, `commit_ms` performs the real hit and damage query, and `chain_open_ms` allows the next combo input. Air attacks still play the complete animation; target presence only changes damage and hit feedback.

The arm model and melee animation library must share bind space. If the right hand is reversed or appears glued to the weapon, inspect channel ownership, bind pose, and root transform. Return from attacks to `static_idle` without a one-frame pose jump, and blend sprint from the melee hold pose rather than a firearm base pose.

Test idle, first equip, holster, repeated air attacks, repeated target hits, inspect, sprint, and re-equip after death. A standalone melee weapon must not display firearm ammunition or firearm HUD state.
