---
title: Advanced Firing and Reloading
---

# Advanced Firing and Reloading

Start with [Animation Rules](./animation.md) and [Configuration Examples](./config-examples.md). These are partial configurations: merge them into your render definition and use timings from your own animation.

## First-shot preparation: fire_pre

`fire_pre` prepares a shot; it is not an additional bullet. Under `animation_machine.actions.fire`:

| Field | Default | Meaning |
| --- | --- | --- |
| `pre_fire_mode` | `presentation` | No preparation gate; `per_trigger` prepares once per trigger cycle; `per_shot` prepares every shot |
| `first_shot_delay_ms` | `-1` | Nonnegative milliseconds override the wait; -1 derives it from preparation duration. Range: -1 to 60000 |

MG338 uses `per_trigger` with 167 ms. Preparation precedes the actual first shot; holding the trigger does not replay full preparation for every bullet. Releasing during preparation still completes the pending shot, unless switching weapons or another invalid firing condition cancels it. Waiting does not consume ammunition.

Gated firing requires every sequence to start with `fire_pre`, followed by a step marked `shot`:

```json
{
  "type": "finite",
  "default_state": "fire",
  "pre_fire_mode": "per_trigger",
  "first_shot_delay_ms": 167,
  "sequences": [{
    "priority": 0,
    "steps": [
      {"state": "fire_pre", "marker": "enter", "phase": "enter"},
      {"state": "fire", "marker": "shot", "phase": "action"}
    ]
  }]
}
```

This minimal hip-fire example does not replace your ADS or last-round branches. Configure those separately and provide both clips and controller channels. First-shot delay is distinct from sustained cadence; `per_shot` adds preparation waits and should not be used when full automatic cadence must be retained.

## Recovery: fire_settle

`fire` supplies the shot impulse; `fire_settle` supplies recovery without another bullet, ammunition deduction, or full set of firing events. Separate recovery is optional and depends on the source animation.

- Link controller channels with `next_state`.
- If fire already contains recovery, use `clip_end_time` in seconds to select its impulse section instead of playing recovery twice.
- Match `clip_start_time`, `speed`, `fade_in`, and `fade_out` to the clips. Incoming blending transitions from the outgoing handoff pose.
- A last-round clip already ending in the correct empty pose must not be forced through ordinary recovery.
- Check ADS and last-round routes separately.
- Test sustained fire, trigger release, and empty state for correct handoff.

M4, RM277, and MG338 have different clip structures; identical names do not imply identical timings.

## Replacement magazine appearance: magazine_role

An animation may reuse `j_mag1` first for the old magazine and then for the replacement. In the event array at `animation_commands.<state>`, assign the role when the replacement appears:

```json
{"frame": 24, "type": "magazine_role", "bone": "j_mag1", "args": ["new"]}
```

Frame 24 is only an example. Use the real magazine root, which need not be named j_mag1.

| Role | Visual ammunition count |
| --- | --- |
| `new` | Expected load for this reload, limited by available reserve ammunition |
| `old` | Ammunition at the start of this reload |

Only the specified root and its descendants receive the first-person reload visual override. Their mapped `bullet_additive` is sampled for that count, including cartridges and follower; retargeted module poses use the same rule. The chamber, other magazines, HUD, and actual ammunition are not prematurely changed.

There is one active role root per reload, not a multi-magazine role map. A later role event replaces it. Completion, cancellation, or switching weapons clears the state. Configure ADS and extended-magazine variants at their own event times.

Do not move the mechanical ammunition commit merely to display a loaded replacement. Magazine role, visibility masks, and ammunition commit have separate purposes.

## Preserve ammunition pose during belt reloads

On a controller channel that must retain its count-dependent belt pose:

```jsonc
"preserve_ammo_pose": true
```

The default is false. MG338 enables it for reload and reload_empty so an empty belt does not reappear at reload start. Existing insertion timing and visibility events still determine updates. This does not replace reload commit settings and should not be enabled indiscriminately.

Test inspection, empty draw, dry fire, and the last few rounds. Do not map dry_fire to idle merely as a placeholder for a missing animation. MG338 omits its dry_fire and aim_dry_fire clip channels while retaining separate empty-click sounds.

## Ejected links without another GLB

The render definition's `link_effect` can reuse a link mesh in the receiver model. MG338 uses:

- `enabled: true` to enable the effect.
- `source_bone: "j_bulletlink_spent1"` to select the source link.
- `anchor_bone: "j_cover"` for ejection position.
- `direction_anchor_bone: "tag_brass"` for the independent direction reference.
- Velocity, front/up angles, randomization, angular speeds, lifetime, and gravity for motion.

One firing event produces one link; `shell_effect` controls the casing separately. Confirm the source represents one link rather than the whole belt. Projectiles, loaded cartridges, casings, and links are distinct objects.

## MG338 attachment parenting example

MG338's 1mW Laser Box attaches to tag_laser_attach on the receiver, not the barrel. Override the module parent in this weapon's render definition:

```jsonc
"modules": {
  "1mw_laser_box": {
    "definition": "attachments/lasers/1mw_laser_box.json",
    "parent_types": ["gun"],
    "parent_slots": []
  }
}
```

Merge this entry with existing modules. MG338 currently uses `canted_aim.rotation.x = -25`, a weapon-specific tuning value rather than a universal default.

Reload with `/gwo reload`, then test single/sustained fire, trigger release, last round, partial/empty/low-reserve reloads, ADS/canted transitions, and casing, link, and transparent-magazine appearance with and without shaders.
