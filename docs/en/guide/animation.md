---
title: Animation Authoring and Export Rules
order: 3
category:
  - Content-Pack Authoring
---

## 10. Animation library contract

Export the static weapon model separately from the animation-only `.anim.glb`. Both files must use the same skeleton names, hierarchy, bind pose, and coordinate space. Frame 0 is valid; configuration event frames must match the exported clip.

## 11. Common action names

| Group | Common actions |
|---|---|
| Base | `static_idle`, `draw`, `draw_first`, `holster` |
| ADS | `aim_in`, `aim_out`, `aim_up_additive`, `aim_fire` |
| Fire | `fire`, `fire_last`, `fire_last_ads`, `dry_fire`, `fire_rechamber`, `aim_fire_rechamber` |
| Reload | `reload`, `reload_empty`, `aim_reload`, `aim_reload_empty` |
| Tube reload | `reload_start`, `reload_loop`, `reload_end`, `reload_empty_chamber_start`, `reload_empty_start` |
| State layers | `empty_additive`, `bullet_additive`, `shell_additive_*` |
| Inspect | `inspect`, `inspect_empty` |
| Sprint | `sprint_in`, `sprint_loop`, `sprint_out`, `super_sprint_in`, `super_sprint_loop`, `super_sprint_out` |
| Melee | `melee_hit_*`, `melee_miss_*`, `melee_fatal_*` |

Only export actions that the weapon actually uses.

## 12. Channel ownership

- Animate a node in the layer that owns it; avoid duplicate channels for the same target across independent armatures.
- Missing additive channels must remain absent. Do not bake every static bone into every clip.
- `tag_camera` contains camera motion only. `tag_view` is the view reference and should not duplicate camera shake.
- `static_idle` is the stable base pose. Finite actions should return or blend cleanly into the state that follows them.
- ADS correction must not be baked again into fire/reload clips when the runtime already applies the ADS layer.
- Preserve authored hand motion. Do not create a second procedural hand-follow transform for the same node.

## 13. Action-specific rules

### Draw and holster

`draw`/`draw_first` start from the intended off-screen pose and end exactly at the base pose. `holster` starts at the base pose and ends off-screen. Do not insert an idle frame after the holster endpoint.

### ADS

`aim_in` and `aim_out` own the transition. An additive ADS action must contain only its correction channels and must use a stable reference pose. Do not duplicate the same correction on `tag_ads`, `tag_weapon`, and the hands.

### Fire and reload

Keep authored weapon and hand channels in the same reference space. `fire_last` must hand directly to the empty state. Magazine/shell visibility events must match the frame at which the model leaves or enters the hand/weapon.

### Tube-fed reload and rechamber

Use start → repeated loop → end. Commit one shell at its configured loop event. A chamber-start action may commit the first round separately. Pump/bolt actions begin only after their configured delay and must preserve hand ownership through their final frame.

### Sprint

Enter, loop, and exit endpoints must match. Composite sprint clips must be baked on every required frame after all source layers are combined; do not leave source IK layers unresolved.

## 14. Arms, camera, and multi-armature export

- The independent arms and weapon file must share their bind reference.
- Export only intentional `LEFT_ARM`, `RIGHT_ARM`, and required child-bone channels.
- Do not bake static arm channels into actions that do not animate arms.
- In multi-armature files, each bone needs one unambiguous owner. Map duplicate one-bone shell or attachment rigs explicitly instead of guessing.
- Validate that actions from receiver, barrel, magazine, pump, bolt, and other rigs merge into one named clip rather than becoming duplicate clips.

## 15. Export checklist

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
