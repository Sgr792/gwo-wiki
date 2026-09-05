---
title: Animation Authoring and Export Rules
order: 3
category:
  - Content-Pack Authoring
---

## Animation library contract

This page focuses on skinned GLB authoring. See [Bedrock and Empty Animation](./bedrock-empty.md) for the new development-build workflows. GWO state names and event configuration remain shared, but Bedrock tracks are relative to the initial pose rather than GLB absolute local transforms.

Export the static weapon model separately from the animation-only `.anim.glb`. Both files must use the same skeleton names, hierarchy, bind pose, and coordinate space. Frame 0 is valid; configuration event frames must match the exported clip.

## Common action names

| Group | Common actions |
|---|---|
| Base | `static_idle`, `draw`, `draw_first`, `holster` |
| ADS | `aim_in`, `aim_out`, `aim_up_additive`, `aim_fire` |
| Fire | `fire_pre`, `fire`, `fire_last`, `fire_last_ads`, `dry_fire`, `fire_rechamber`, `aim_fire_rechamber` |
| Reload | `reload`, `reload_empty`, `aim_reload`, `aim_reload_empty` |
| Tube reload | `reload_start`, `reload_loop`, `reload_end`, `reload_empty_chamber_start`, `reload_empty_start` |
| State layers | `empty_additive`, `bullet_additive`, `shell_additive_*` |
| Inspect | `inspect`, `inspect_empty` |
| Sprint | `sprint_in`, `sprint_loop`, `sprint_out`, `super_sprint_in`, `super_sprint_loop`, `super_sprint_out` |
| Melee | `melee_hit_*`, `melee_miss_*`, `melee_fatal_*` |

Only export actions that the weapon actually uses.

### State names versus GLB clip names

The key in `animation_clips` is the GWO state; its value is the real clip inside the `.anim.glb`. They may differ:

```jsonc
"animation_clips": {
  "reload_xmaglrg": "reload_xmaglrg",
  "reload_drummag": "reload_drummag"
}
```

Declare the state key consistently in `animation_controller`, `animation_machine`, and attachment `animation_override`, then map it to an existing authored clip. The tables below describe state purposes.

`xmaglrg` and `drummag` are not synonyms. `xmaglrg` is a large extended box magazine; `drummag` is a drum magazine. Runtime mappings may technically point to differently named clips, but content that supplies both authored families must keep two independent state sets.

### `animation_events` is only for dispatchable actions

`animation_events` classifies animation states into runtime action channels such as `fire`, `reload`, `inspect`, `aim`, `sprint`, and `melee`. Explicit mappings remain part of the current format and may be retained; they are not deprecated.

Do not place `static_idle`, `bullet_additive`, `empty_additive`, `aim_additive`, `aim_up_additive`, or `shell_additive_*` in `animation_events`. They are base or additive pose layers rather than dispatchable events and belong in `animation_clips`, the controller, or the pose graph. Event values must be supported GWO logical events, not arbitrary copied clip names.

An identity clip mapping such as `"fire": "fire"` is still valid and may serve as an explicit capability declaration. Do not remove it merely because the state and clip names match.

### Base, equip, and display

| State | Purpose and distinction |
|---|---|
| `static_idle` | Stable first-person base pose. It must not contain empty, ammunition, or fire-mode state. |
| `draw` | Normal equip/re-equip action. |
| `draw_first` | Optional first successful equip for that weapon identity in the client session; previews and warm-up do not consume it. |
| `holster` / `holster_empty` | Normal/empty-state unequip actions. Use the empty variant only when the mechanism needs a distinct pose. |
| `ground_idle` | Optional dropped-item state alias; it does not participate in first-person action flow. |
| `third_person_idle` | Optional third-person display state; it does not replace `third_person_pose`. |

### ADS, fire, and cycling

| State | Purpose and distinction |
|---|---|
| `aim_in` / `aim_out` | Enter and exit normal ADS. Their shared endpoint is the ADS reference pose. |
| `aim_down_settle` | Optional residual settling after ADS exit; it does not replace `aim_out`. |
| `aim_additive` | Runtime state commonly mapped to an authored `aim_up_additive` clip. Do not duplicate the same clip under both names. |
| `aim_up_additive` | Local `tag_weapon` ADS correction, not a full pose; no hands or `tag_ads`. |
| `aim_idle` | Optional ADS hold loop only when the aim action explicitly references it; many weapons hold ADS by layering over `static_idle`. |
| `fire_pre` | Optional short sequence entry before the actual fire state; it does not own shot effects or ammunition consumption. |
| `fire` / `aim_fire` | Hip-fire and ADS-fire actions. The ADS version must not add another `tag_ads` transform. |
| `fire_last` / `fire_last_ads` | Hip/ADS last-round actions that enter the empty mechanism state. |
| `fire_settle` / `fire_last_settle` | Post-shot settling states. They do not fire again; the last-round route must retain empty state. |
| `dry_fire` / `aim_dry_fire` | Hip/ADS no-ammunition actions; no projectile, muzzle effect, or casing. |
| `fire_rechamber` / `aim_fire_rechamber` | Hip/ADS pump or bolt cycle after firing, separate from recoil/fire animation. |

### Magazine reload, inspect, and selector

| State | Purpose and distinction |
|---|---|
| `reload` / `reload_empty` | Tactical reload with a chambered round versus an empty reload that includes chambering/bolt release. |
| `aim_reload` / `aim_reload_empty` | ADS-space equivalents; they are not scaled copies of hip reloads. |
| `reload_xmaglrg` / `reload_empty_xmaglrg` | Normal/empty large extended box-magazine branches; they do not represent a drum. |
| `aim_reload_xmaglrg` / `aim_reload_empty_xmaglrg` | ADS-space large extended box-magazine branches with independent timing and events. |
| `reload_drummag` / `reload_empty_drummag` | Normal/empty drum-magazine branches with drum-specific grip and clearance. |
| `aim_reload_drummag` / `aim_reload_empty_drummag` | ADS-space drum-magazine branches with their own commit, sound, and visibility timeline. |
| `inspect` / `inspect_empty` | Non-empty/empty inspection using real ammunition and mechanism state. |
| `inspect_xmaglrg` / `inspect_empty_xmaglrg` | Large extended box-magazine inspection branches. |
| `inspect_drummag` / `inspect_empty_drummag` | Drum-magazine inspection branches; do not share the xmag state/sound timeline. |
| `switch_fire_mode` | Generic selector action shared by destination modes. |
| `switch_to_auto` / `switch_to_semi` | Destination-specific selector actions. |
| `aim_switch_fire_mode` / `aim_switch_to_auto` / `aim_switch_to_semi` | ADS-space selector equivalents. |
| `select_fire_empty` / `aim_select_fire_empty` | Empty-state hip/ADS selector branches, only when empty mechanics change the motion. |
| `firemode_auto_static` / `firemode_semi_static` | Persistent selector-bone state layers, not one-shot switching actions. |

### Tube-fed reload

| State | Purpose and distinction |
|---|---|
| `reload_start` | Enter the non-empty per-round route and commit its first shell at `start_commit_frame`; later shells use the loop. |
| `reload_loop` | Repeated action that commits exactly one shell per loop. |
| `reload_end` | Stop inserting and return to the held pose; it must not unconditionally rechamber. |
| `reload_empty_chamber_start` | Empty route that loads the first shell directly into the chamber. |
| `reload_empty_start` | Load the next tube shell after the empty route chambered its first shell; it uses `empty_start_commit_frame` before the repeated loop. |
| `reload_empty_chamber_end` | Optional handoff from direct chamber loading to tube-loop posture; it must not commit the same shell again. |
| `aim_reload_start/loop/end` | ADS-space equivalents of the non-empty three-stage route. |
| `aim_reload_empty_chamber_start` / `aim_reload_empty_start` / `aim_reload_empty_chamber_end` | ADS-space equivalents of the empty chamber route; pair each state explicitly. |

### Persistent layers, sprint, and melee

| State | Purpose and distinction |
|---|---|
| `empty_additive` / `empty_additive_xmaglrg` / `empty_additive_drummag` | Default, large-box, and drum persistent empty-mechanism layers, not full held poses. |
| `bullet_additive` / `bullet_additive_xmaglrg` / `bullet_additive_drummag` | Default, large-box, and drum ammunition/follower/`j_ammo_*` layers. |
| `shell_additive_*` | Tube-shell/follower pose selected by configuration; the suffix alone does not make runtime infer capacity. |
| `sprint_in/loop/out` | Normal sprint enter, repeating loop, and exit. Only `loop` repeats. |
| `super_sprint_in/loop/out` | Super-sprint three-stage route with its own endpoints and stronger authored posture. |
| `melee_miss_*` | Firearm-melee air/miss set. Number suffixes must be continuous. |
| `melee_hit_*` | Firearm-melee non-fatal hit set. |
| `melee_fatal_*` | Firearm-melee fatal-result set, not merely a heavier random variation. |
| `swipe_*` / `stab_*` | Independent-melee authored attacks. Name does not define damage; `melee.combos` owns order/random mode, commit, and chain windows. |

Not every weapon needs every state. A correctly named but unreferenced clip is not played automatically.

## Channel ownership

- Animate a node in the layer that owns it; avoid duplicate channels for the same target across independent armatures.
- Missing additive channels must remain absent. Do not bake every static bone into every clip.
- `tag_camera` contains camera motion only. `tag_view` is the view reference and should not duplicate camera shake.
- `static_idle` is the stable base pose. Finite actions should return or blend cleanly into the state that follows them.
- ADS correction must not be baked again into fire/reload clips when the runtime already applies the ADS layer.
- Preserve authored hand motion. Do not create a second procedural hand-follow transform for the same node.

## Action-specific rules

### Draw and holster

`draw`/`draw_first` start from the intended off-screen pose and end exactly at the base pose. `holster` starts at the base pose and ends off-screen. Do not insert an idle frame after the holster endpoint.

`draw_first` is optional and is consumed only when that weapon identity successfully begins its first authored equip in the client session. Preview, modification-screen, and warm-up rendering do not consume it. Later equips use `draw`; world leave, player death, or a client runtime reset clears the first-draw record. Provide both actions when the weapon needs a distinct normal equip animation.

### ADS

`aim_in` and `aim_out` own the transition. An additive ADS action must contain only its correction channels and must use a stable reference pose. Do not duplicate the same correction on `tag_ads`, `tag_weapon`, and the hands.

Programmatic tactical stance is configured with `canted_aim`; it does not require `canted_aim_in` or `canted_aim_out` clips. Do not layer legacy canted or NVG ADS animations on top of the runtime transform.

### Fire and reload

Keep authored weapon and hand channels in the same reference space. `fire_last` must hand directly to the empty state. Magazine/shell visibility events must match the frame at which the model leaves or enters the hand/weapon.

`fire_pre` is optional. Use it only as an explicit short entry step in `animation_machine.actions.fire.sequences` before the selected fire action; do not add a dummy clip to weapons that have no authored pre-fire motion.

### Tube-fed reload and rechamber

Use start → repeated loop → end. Commit one shell at its configured loop event. A chamber-start action may commit the first round separately. Pump/bolt actions begin only after their configured delay and must preserve hand ownership through their final frame.

For `tube_per_round`, authored frames are the only mechanical timing source. Do not duplicate them as `insert_commit_ms`, `start_commit_ms`, `empty_chamber_start_commit_ms`, `empty_start_commit_ms`, `rechamber_eject_ms`, or `rechamber_commit_ms`. Runtime converts each frame through the weapon-level `animation_fps` so a dedicated server can keep a real-time mechanical clock without requiring authors to maintain two values.

```jsonc
"reload_system": {
  "type": "tube_per_round",
  "tube_capacity": 7,
  "chamber_capacity": 1,
  "rechamber_delay_ms": 350,
  "frame_lengths": {
    "start": 27,
    "insert": 22,
    "end": 19,
    "end_rechamber": 19,
    "empty_chamber_start": 53,
    "empty_start": 27,
    "empty_chamber_end": 16,
    "rechamber": 21
  },
  "events": {
    "insert_sound_frame": 19,
    "insert_commit_frame": 19,
    "start_commit_frame": 24,
    "empty_chamber_start_commit_frame": 50,
    "empty_start_commit_frame": 24,
    "rechamber_eject_frame": 2,
    "rechamber_commit_frame": 19
  }
}
```

`start_commit_frame`, `insert_commit_frame`, `empty_chamber_start_commit_frame`, and `empty_start_commit_frame` map respectively to the start, repeated insert, empty chamber-start, and empty-start clips (including their paired `aim_` states). `rechamber_eject_frame` ejects the casing and `rechamber_commit_frame` chambers the next shell in `fire_rechamber` / `aim_fire_rechamber`. `insert_sound_frame` is an authoring reference; dispatch the actual sound through the render definition's `animation_commands`.

`frame_lengths` records the total frames of each phase and supplies fallback phase duration when a GLB clip duration is unavailable. Keep it synchronized with the exported clips. Shell/follower visibility and `shell_additive_*` are visual state only; they do not replace the mechanical commit frame or authoritative HUD ammunition.

### Sprint

Enter, loop, and exit endpoints must match. Composite sprint clips must be baked on every required frame after all source layers are combined; do not leave source IK layers unresolved.

## Arms, camera, and multi-armature export

- The independent arms and weapon file must share their bind reference.
- Export only intentional `LEFT_ARM`, `RIGHT_ARM`, and required child-bone channels.
- Do not bake static arm channels into actions that do not animate arms.
- In multi-armature files, each bone needs one unambiguous owner. Map duplicate one-bone shell or attachment rigs explicitly instead of guessing.
- Validate that actions from receiver, barrel, magazine, pump, bolt, and other rigs merge into one named clip rather than becoming duplicate clips.

## Export checklist

- No unexpected `.001` actions or duplicate names.
- No scale keys unless scaling is intentional; normal transform scale remains `1`.
- Quaternion rotations stay normalized.
- No accidental `tag_camera`, `tag_ads`, arm, ammo, or attachment channels.
- First and final poses match the intended neighboring state.
- Clip frame counts and JSON events are synchronized.
- Test draw, holster, ADS, fire, reload, empty state, inspect, sprint, interruption, and rapid weapon switching in game.

::: warning
An animation that looks correct in Blender can still be invalid when two rigs own the same target or when a runtime additive layer repeats an authored transform. Fix ownership and reference space instead of hiding the symptom with a per-animation offset.
:::

## First-draw eligibility and transform timing

`draw_first` requires available ammunition and a configured controller channel, in addition to an unused weapon identity. An empty firearm does not select it even on the first equip; independent melee is exempt from firearm ammunition requirements. The animation machine still resolves the final state. Merely exporting a clip with that name is insufficient.

Normalize object transforms before binding and animating. Do not independently apply Armature transforms in an already bound/animated project; update affected models, bind poses, and animations together and recheck them.

Start with the [self-contained configuration examples](./config-examples.md) for variants, sequences, markers, interrupts, and pose layers. Matching default-pack files are optional supplementary references, not required downloads.

## Channel ownership details

| State family | Intended tracks | Exclude |
| --- | --- | --- |
| `firemode_*_static` | Selector only, such as `j_firesel` | Arms, weapon root, ADS, camera, ammunition and magazine |
| `fire*`, `aim_fire*`, `dry_fire*` | Authored recoil/mechanisms/arms | `tag_ads`; omit static camera tracks when there is no camera motion |
| `reload*`, `aim_reload*`, `inspect*`, `draw*`, `holster*`, melee attacks | Required weapon, arms, mechanisms, camera | `tag_ads` and bulk-baked unrelated bones |
| `sprint_*`, `super_sprint_*` | Required weapon, arms, camera | ADS, ammo/selector state, unrelated attachments |

These are the documented ownership convention, not a claim that every exporter forbids such tracks. If changing masks or pose layers, update authored tracks consistently rather than applying the table blindly.

### Detailed authoring checkpoints

- Base idle must not bake changing ammunition, selector, or empty mechanism state. Keep the first/last pose continuous.
- Draw ends at idle; holster begins at the corresponding held pose. Empty and normal variants must retain the correct mechanism state.
- Aim transitions own `tag_ads`; aim additive owns its configured weapon node. Do not repeat ADS displacement in aim-fire or aim-reload.
- Fire settle restores pose without producing another shot. Last-shot settle must retain the empty-state result. Ejection occurs when the mechanism reaches its authored ejection point.
- Reload's removal, insertion, commit, bolt, and completion are different phases. Track the two magazines' visibility independently. Commit controls ammunition, not merely sound.
- Each tube insert commits one round. Direct chamber loading must not trigger a duplicate chamber cycle later. Shell/follower tracks stay in their own state layer.
- Rechamber must preserve pump/bolt, hand, and ejection relationships. Equal final curve values do not prove equal reference space.
- Inspection reads actual ammunition state. Actions hand back without leaving an unintended last-frame layer.
- Sprint enter ends at loop start; loop endpoints and exit are continuous. Do not mix a weapon's unrelated reference pose into its running clips.
- Preserve necessary arm tracks when omitting authoring preview meshes. The supplied arms are rigid cube-style parts, not a detailed finger rig; see [Arm Templates](./arm-templates.md).
- Camera motion belongs on its own node and should enter/exit smoothly. Do not bake the same runtime sway/recoil/bob into every clip.
- Static anchors need no redundant keys; moving anchors must follow their intended mechanism. Keep cartridge and magazine nodes distinct.
- Multiple Armatures require one clear owner per target and unified clip name/time. Exporter-specific ownership must be checked rather than guessed.
- Sample constrained motion into numeric keys; keep quaternion rotations normalized. Scale keys are intentional only when the model needs them.
- After editing timing, synchronize controller duration, mechanical commits, reload phases, and timed commands. At 30 FPS, milliseconds = frames / 30 × 1000. Tube timing derives from `animation_fps`.
