---
title: Standalone Melee Weapons
order: 6
category:
  - Content-Pack Authoring
---

## Independent melee state

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

### Beginner order and timing

Do not convert a firearm by only deleting ammunition fields. Create gameplay under `weapons/melee/` and rendering under `weapons/melee/render/`. Begin with `static_idle`, `draw_first`, `holster`, and one attack. Verify reference space before adding the remaining combo, inspect, sprint, super sprint, hit variants, and audio.

`duration_ms` is total action-state time, `commit_ms` performs the real hit and damage query, and `chain_open_ms` allows the next combo input. Air attacks still play the complete animation; target presence only changes damage and hit feedback.

The arm model and melee animation library must share bind space. If the right hand is reversed or appears glued to the weapon, inspect channel ownership, bind pose, and root transform. Return from attacks to `static_idle` without a one-frame pose jump, and blend sprint from the melee hold pose rather than a firearm base pose.

Test idle, first equip, holster, repeated air attacks, repeated target hits, inspect, sprint, and re-equip after death. A standalone melee weapon must not display firearm ammunition or firearm HUD state.

## Configuration examples

These examples use the same fields as the Chinese reference. Replace resource IDs, timings, and model-specific nodes with your own. `json` blocks are JSON objects; `jsonc` blocks are fragments to merge, not standalone pack files. Valid JSON alone does not make a complete working weapon.

### Melee gameplay definition

```json
{
  "id": "example:example_knife",
  "display_name": "Example Knife",
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

## First implementation and acceptance

1. Create files under `weapons/melee/` and `weapons/melee/render/`.
2. Start with idle, draw/first-draw as configured, holster, and one attack.
3. Verify arm reference space before adding more combo attacks.
4. `duration_ms` is the segment's occupied time, `commit_ms` submits the melee hit test, and `chain_open_ms` opens chaining input. A miss still plays the attack.
5. Add inspection, sprint, hit branches, and sound only after the basic attack is stable.

Do not reuse firearm ammo/reload HUD behavior. Verify the right hand in idle, drawing, holstering, inspection, and attacking; it should use the authored motion rather than an inappropriate firearm arm layer. Sprint must use this weapon's own holding reference.

Test draw, holster, inspection, swing, spatial hit, and optional fatal emphasis independently. Do not bake swing, impact, and kill layers into one file and then trigger them again.

```text
/gwo reload
/gwo give melee "example:example_knife"
```

Test repeated misses, repeated hits, inspection, sprint, and respawn. Confirm there is no firearm ammunition HUD and no arm handoff jump.
