---
title: Reloading, Debugging, Performance, and Release
order: 8
category:
  - Content-Pack Authoring
---

## Reload and test workflow

Use `/gwo reload` to rescan external firearm and ammunition definitions. It does not rebuild uploaded GPU model or material caches. Use resource reload (`F3+T`) for models, textures, sounds, animations, `transparent_nodes`, and other render-material changes. Restart the game whenever a loader, renderer, cache, or binary resource remains resident.

Test with folder packs first. ZIP only after the folder build passes. The ZIP root must directly contain `pack.mcmeta` and content folders.

## Performance rules

- Remove hidden/internal faces and unused nodes before export.
- Share materials and texture atlases where practical.
- Avoid unnecessary armatures, bones, static animation channels, transparent layers, and draw calls.
- Keep particle counts, shell lifetime, tracers, laser glow, and charm physics bounded.
- Measure first person, third person, modification UI, item frames, shaders, and multiplayer separately.

## Troubleshooting

| Symptom | First checks |
|---|---|
| Missing or misplaced attachment | Anchor spelling, shared reference space, animated owner |
| Black/purple model | Resource ID, file path, base texture |
| Wrong PBR or emissive result | Normal/specular/glow declarations and shader path |
| Hands drift during an action | Duplicate ownership, wrong bind pose, unwanted additive channels |
| One-frame snap after an action | Endpoint mismatch, stale finite-action owner, incorrect handoff |
| Animation clip missing | Exported action name, multi-armature merge, skin ownership |
| Sound doubled or delayed | Duplicate event/composite layer, stale frame timing |
| Scope/laser differs with shaders | Transparent pass, stencil, depth, and reference-space route |

## Release checklist

- Pack metadata and namespace paths validate.
- Every referenced JSON, GLB, PNG, and OGG exists.
- All default and optional parts mount correctly.
- Fire, reload, empty state, ADS, sprint, inspect, melee, interruption, and weapon switching work.
- Event frames match current animation lengths.
- First person, third person, offhand stow, fixed display, dropped item, HUD, and modification screen are correct.
- Materials work with and without shaders.
- No diagnostic output, temporary assets, duplicate actions, or unused fallbacks remain.
- Folder and ZIP builds both load in a clean instance.

## Complete release checklist

### Files and loading

- [ ] Correct pack metadata at the root.
- [ ] Valid JSON, unique content IDs, and existing referenced resources.
- [ ] Only one enabled folder/ZIP copy.
- [ ] Definition reload completes without errors.

### Gameplay

- [ ] Semi, automatic, and burst modes work as configured.
- [ ] Single-player and LAN firing cadence agree.
- [ ] Loaded/reserve ammunition and selected cartridge stay synchronized.
- [ ] Normal/empty reload and interruption behave correctly.
- [ ] Tube loading and chamber cycles commit exactly once.
- [ ] Bolt-action chamber recovery survives weapon switching.
- [ ] Survival and creative inventory rules are correct.

### Animation and models

- [ ] Idle, draw, holster, ADS, fire, reload, inspect, and sprint.
- [ ] Correct aiming variants and arm grips throughout.
- [ ] No first/last-frame flashes; frame-zero events work.
- [ ] Durations, sound frames, and commits agree.
- [ ] Default parts and replacement modules use real animated anchors.
- [ ] Modification preview, third person, stow, dropped, and item-frame placement.
- [ ] Iron-sight visibility follows optic installation.
- [ ] Laser/charm motion, collisions, loaded rounds, and follower states.

### Rendering, sound, and UI

- [ ] Base material, emission, and transparency without shaders.
- [ ] Iris materials, physical glass, and in-scope world image.
- [ ] Reflex, magnified, hybrid, and variable optics individually.
- [ ] Sway works with regular and magnified optics.
- [ ] Muzzle effects, tracers, laser, and ejection use correct anchors.
- [ ] Fire audio does not duplicate or cut off unexpectedly.
- [ ] Reload/inspection/mechanism/melee/dry-fire events match frames.
- [ ] Test sound-physics integration where applicable.
- [ ] Item/HUD icons, names, classifications, and modification cards.
- [ ] UI text remains readable and in front of models at different resolutions.

Command IDs are quoted for the current string argument parser:

```text
/gwo reload
/gwo give firearm "example:example_rifle"
/gwo give melee "example:example_knife"
/gwo give ammo "example:example_ammo"
```

For the current command parser, keep the resource ID in double quotes, including namespaces. Type the command itself, not the Markdown backticks.
