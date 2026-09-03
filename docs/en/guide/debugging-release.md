---
title: Reloading, Debugging, Performance, and Release
order: 8
category:
  - Content-Pack Authoring
---

## 29. Reload and test workflow

Use `/gwo reload` to rescan external firearm and ammunition definitions. It does not rebuild uploaded GPU model or material caches. Use resource reload (`F3+T`) for models, textures, sounds, animations, `transparent_nodes`, and other render-material changes. Restart the game whenever a loader, renderer, cache, or binary resource remains resident.

Test with folder packs first. ZIP only after the folder build passes. The ZIP root must directly contain `pack.mcmeta` and content folders.

## 30. Performance rules

- Remove hidden/internal faces and unused nodes before export.
- Share materials and texture atlases where practical.
- Avoid unnecessary armatures, bones, static animation channels, transparent layers, and draw calls.
- Keep particle counts, shell lifetime, tracers, laser glow, and charm physics bounded.
- Measure first person, third person, modification UI, item frames, shaders, and multiplayer separately.

## 31. Troubleshooting

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

## 32. Release checklist

- Pack metadata and namespace paths validate.
- Every referenced JSON, GLB, PNG, and OGG exists.
- All default and optional parts mount correctly.
- Fire, reload, empty state, ADS, sprint, inspect, melee, interruption, and weapon switching work.
- Event frames match current animation lengths.
- First person, third person, offhand stow, fixed display, dropped item, HUD, and modification screen are correct.
- Materials work with and without shaders.
- No diagnostic output, temporary assets, duplicate actions, or unused fallbacks remain.
- Folder and ZIP builds both load in a clean instance.
