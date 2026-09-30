---
title: Lua animation machines and parameters
category:
  - Content-Pack Authoring
---

## Version and responsibilities

This page describes **Lua animation API 1**, integrated on 2026-09-30. Use a build containing this interface: the version label 2.12.87 alone does not distinguish older JARs. Legacy JSON machines remain readable; the migrated default and sci-fi packs use Lua.

Lua selects states, branches, timelines, interrupts, sprint-phase clips and ammo sampling. Java evaluates GLB bones, skins/renders models and executes existing mechanical rules. Damage, firing intervals, ammunition and real reload commits remain gameplay JSON/server concerns. Animation duration does not automatically set firing cadence.

## Files in one pack

```text
weapons/firearms/example_rifle.json
weapons/firearms/render/example_rifle.render.json
assets/example/scripts/default_machine.lua
assets/example/scripts/weapons/example_rifle.lua
assets/example/gltf/animations/example_rifle_receiver_default.anim.glb
```

Merge this fragment into the render JSON, retaining model/material/anchor fields:

```json
{"state_machine":"example:weapons/example_rifle","animation_fps":30}
```

Download the [default policy](/downloads/examples/default_machine.lua) as default_machine.lua and the [weapon example](/downloads/examples/example_machine.lua) as weapons/example_rifle.lua. require("example:default_machine") reads only this pack. Rename namespace, directories and references together; both folders and standard ZIPs work. Do not append .lua to state_machine or require IDs.

The download contains teaching timings and no models, sounds or animation assets. Supply all referenced clips, mechanical commits, sound and masks before testing in game.

## Data moved into Lua config

| Group | Purpose |
|---|---|
| animation_machine | Actions, branches, sequences, events and interrupt declarations |
| animation_controller | Clip channels, timing, masks and reference spaces |
| pose_graph | Base/overlay composition, conditions and weights |
| animation_events | Classify dispatchable states into supported logical events |
| paired_aim_actions | Same-time hip/ADS clip pairs |
| animation_clips | Legacy clip aliases; new default content uses actual short names |
| animation_commands | Timed sound, magazine-role and presentation commands |

Remove those seven groups from render JSON when Lua supplies them. Keep animation_fps, fire_animation, reload_system, reload_phases, resources and mechanics in their existing JSON locations. Damage/mechanics in Lua config are rejected.

Use array { ... } for arrays, especially array {} for an empty array. A minimal interface outline is:

```lua
local default = require("example:default_machine")
local config = {
    animation_machine = {version = 2, actions = {}, interrupts = array {}},
    animation_controller = {channels = {}}
}
local machine = default.new(config)
return machine
```

Use the download for a complete teaching starting point.

## Actions, variants, sequences and interrupts

These fields live under config.animation_machine. Lua API 1 and data version 2 are distinct version numbers.

| Field | Meaning/unit/constraint |
|---|---|
| version | Current data structure: 2 |
| actions.ACTION.type | finite, continuous or per_round, matching the registered logical action |
| default_state | Default state for a finite action, using a declared real channel |
| phase_states | Continuous actions need enter/loop/exit; sprint may add super_enter/super_loop/super_exit |
| state_phases | Map concrete states to enter/action/exit/loop |
| variants[] | State selection rules containing state, when, priority and transition |
| when | String conditions: true/false strings, * for nonempty, ! for missing/empty, !value, alternatives separated by &#124;, numeric comparisons such as >=2 |
| priority | Default zero; higher first, then more specific conditions, then declaration order |
| transition | Seconds, not milliseconds; declared range 0..1 |
| sequences[] | Condition/priority selects steps, laid out using their clip durations |
| steps[].state / marker / phase | State, event marker and enter/action/exit/loop; marker is not a bone |
| events[].type | Supported shot_effects, fire_sound and recoil; not arbitrary damage/Java commands |
| events[].marker / offset_ms / when | Event at marker start plus 0..60000 milliseconds, subject to conditions |
| interrupts[].active / incoming | Active/new action matching expressions referencing declared actions |
| interrupts[].decision | allow, interrupt, reject, queue or pause_resume; a declared default continues normal policy, but a custom hook must return an explicit decision |
| interrupts[].phases / min_progress / max_progress | Restrict phase and normalized 0..1 progress |
| interrupts[].priority / transition / reason | Rule order, transition seconds and required diagnostic reason |

Action IDs and clips can differ: aim plays ads_up. IDs must be registered GWO actions; arbitrary new keys do not introduce new gameplay.

## Channel parameters

Path: config.animation_controller.channels.STATE.

| Field | Default | Purpose |
|---|---|---|
| clip / layer | state name / action | Real clip and execution layer, e.g. base/action/recoil/aim/sprint |
| duration_frame / duration | 0 / 0 | Total frames/seconds; frames take precedence and use JSON animation_fps; zero may use actual clip duration |
| speed | 1 | Playback multiplier; synchronize events/commits when changing it |
| fade_in / fade_out | 0 / 0 | Seconds; fades cannot fix incorrect coordinates or duplicate overlays |
| loop / keep_last_frame | false / false | Loop / hold last frame |
| bone_mask | empty array | Bone ownership restriction; avoid covering arms and replacement magazines with ammo layers |
| lock_fire | false | Firing lock during action; not a replacement for mechanical cooldown |
| sample_frame / sample_time | 0 / 0 | Static sampling frame/second, frames first; not mechanical commit timing |
| state_conditions | empty object | Weapon conditions controlling channel activation |
| suppress_aim_additive / suppress_empty_additive | false / false | Suppress corresponding overlays while playing |
| clip_start_time / clip_end_time | 0 / -1 | Clip subsection in seconds; minus one leaves the end unrestricted |
| next_state | empty string | Follow-up state, e.g. fire_settle; does not fire another shot |
| blend | empty string | Optional explicit reference space; otherwise uses layer settings |
| follow_source_bone / follow_target_bones | empty / empty array | Carry source motion into target bones, e.g. weapon to arms_root; match the rig |
| preserve_ammo_pose | false | Preserve current visual ammo pose until the visual reload update |
| recoil_arm_mode | auto | Arm treatment for recoil; use an existing matching setup, not invented enum names |

## Pose graph and presentation commands

| Field | Purpose |
|---|---|
| pose_graph.base_clip / default_blend | Base clip/reference space, idle/override by default |
| layer_profiles / layers.LAYER.profile | Shared layer template; local fields override its entries |
| layers.LAYER.channel / channels | Channel or channel set; channel defaults to layer name |
| enabled / priority | Layer participation/composition order; defaults true/0 |
| bone_mask / exclude_bone_mask | Included/excluded bones; establish ownership before tuning weights |
| conditions | Weapon-state conditions |
| action_progress_weight | Four progress/weight values on a 0..1000 progress scale; default [0,0,1000,1000], not milliseconds |
| weight_curve | smoothstep or linear weight interpolation |
| blend=override | Blend layer pose into current result |
| blend=additive | Delta relative to current base reference |
| blend=bind_additive | Delta relative to bind pose |
| blend=delta_additive | Tracks already contain deltas; do not use for full absolute actions |
| blend=clip_start_additive | Delta relative to clip-start reference |
| paired_aim_actions | Pair real hip/ADS clips at the same time; aiming changes do not restart reload |
| animation_commands.STATE[] | frame or time plus type/args/bone/sound etc.; frame uses animation_fps, time uses seconds |
| sound command | Plays the configured sound-event ID |
| magazine_role command | Changes visual magazine role, e.g. old/new; use implemented roles |
| mask_mag_ammo command | Updates visual magazine ammo masking; does not replace server ammo commits |

Do not add idle/offset again to an already baked sprint clip. Missing tracks and explicit constant tracks have different meanings; Lua cannot repair incorrectly exported GLBs.

## Override a weapon hook

Place this before return machine, with fire_last_ads present in your assets/channels:

```lua
local original = machine.select
function machine.select(action, fallback, ctx)
    if action == "fire" and ctx.aiming == "true"
        and tonumber(ctx.ammo) == 1 then
        return {state = "fire_last_ads", transition = 0}
    end
    return original(action, fallback, ctx)
end
```

| Hook | Input | Return |
|---|---|---|
| select(action, fallback, ctx) | Action, fallback state, state table | {state, transition} |
| plan(action, selected, ctx, duration) | Action, state, context, function returning clip milliseconds | {duration_ms, steps, events} |
| interrupt(ctx) | Active/new-action context | {decision, transition, priority, reason} |
| phase(action, phase, fallback) | Action, phase, fallback | State string |
| sample(kind, ammo, capacity, length, fps) | magazine/per_round, rounds, capacity, clip seconds, FPS | Sampling seconds |

select/plan context values are strings: ammo, capacity, empty, last_round, aiming, charged, chamber_loaded, cycle_required, per_round, fire_mode, requested_state; plan adds selected_state. Actual-item select also supplies moving, crouching, airborne, sprinting, super_sprinting, pose and module extensions. Use tonumber; the string "false" is not Lua false.

interrupt context has active/incoming, active_state/incoming_state, active_group/incoming_group, active_family/incoming_family, incoming_finite, phase, progress, melee_enabled and chain_open_progress. Progress is numeric 0..1 and incoming_finite is boolean. plan steps contain {state,marker,phase,time_ms,duration_ms}; events contain {type,time_ms}. Times are nonnegative integers, step durations positive, all ordered and inside the timeline; at most 128 of each.

Default magazine sampling is length × clamp(capacity-ammo,0,capacity)/capacity. Per-round sampling uses zero while nonempty and the last frame minus one frame when empty. Sampling changes only the pose; slots/chamber classification and masks must also be correct.

## Reloading, migration and limits

Use the build's content reload entry point or restart the client. File edits are not automatically distributed to server players. To migrate JSON, move the seven groups into Lua tables, use array helpers, remove duplicate render fields and add state_machine. Retain assets and non-animation parameters. [JSON examples](config-examples.md) still explain data but must not be merged alongside duplicate Lua config.

Each weapon definition shares one VM. Derive decisions from input; do not store a player's/item's mutable state in module globals. There is no per-instance storage API. Limits: one million instructions per load/call, 64 imports, one million characters per source and config depth 48. No filesystem/network/Java/system/debug interfaces are exposed. These limits catch common mistakes, not all malicious resource consumption. Errors identify script/function; test loading and gameplay before release.

Loader/data tests pass, but visual behavior and frame rate still need in-game validation. Lua migration alone is not a performance guarantee.
