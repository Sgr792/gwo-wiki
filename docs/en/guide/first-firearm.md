---
title: Build Your First Firearm
order: 3
category:
  - Beginner Course
---

# Build Your First Firearm

This chapter is for a creator who has never made a GWO pack. Follow the checkpoints in order: first load a definition, then render a model, then verify shooting and reloading, and only then add arms, aiming, audio, attachments, and advanced states.

Do not continue when the current checkpoint fails. Adding more systems hides the original error.

## Result and names used in this tutorial

You will build a semi-automatic training rifle with one ammunition type and a minimal current-format animation machine.

| Item | Tutorial value |
|---|---|
| Pack folder | `my_first_gwo_pack` |
| Namespace | `tutorial` |
| Firearm ID | `training_rifle` |
| Ammo ID | `training_ammo` |
| Ammo family | `training_caliber` |
| Animation rate | 30 FPS |

You may rename them, but every reference must change consistently.

## Step 0: Prepare the environment

1. Install Minecraft 1.21.1, the matching NeoForge version, and GWO.
2. Install Blender 3.3.
3. Install an editor that saves valid UTF-8 JSON.
4. Download and extract the [empty content-pack template](/downloads/gwo_empty_content_pack_template.zip).
5. Download the [Blender 3.3 arm template](/downloads/gwo_arms_template_blender33.blend).
6. Rename the pack folder to `my_first_gwo_pack` and place it in `.minecraft/gwo/`.
7. Rename `assets/example/` to `assets/tutorial/`.

Checkpoint:

```text
.minecraft/gwo/my_first_gwo_pack/pack.mcmeta
.minecraft/gwo/my_first_gwo_pack/assets/tutorial/
```

The game starts without content-pack JSON errors. An empty pack adds no item.

## Step 1: Create the target paths

```text
my_first_gwo_pack/
├─ weapons/firearms/training_rifle.json
├─ weapons/firearms/render/training_rifle.render.json
├─ bullets/training_ammo.json
└─ assets/tutorial/
   ├─ gltf/guns/training_rifle/training_rifle_receiver_default.glb
   ├─ gltf/animations/training_rifle_receiver_default.anim.glb
   ├─ skins/guns/training_rifle.png
   ├─ skins/guns/training_rifle_n.png
   ├─ skins/guns/training_rifle_s.png
   └─ textures/item/guns/training_rifle.png
```

Keep the first model as one complete receiver. Separate default barrel, magazine, and stock modules only after the base weapon works.

Rules:

- Use lowercase letters, digits, and underscores in paths.
- `tutorial:gltf/...` resolves to `assets/tutorial/gltf/...`.
- Keep `model_data` and `icon_model_data` unique in your pack.
- Replace accidental names such as `Action`, `idle.001`, and `Cube.003`.

## Step 2: Build the first model

In Blender 3.3:

1. Point the muzzle along model `+X`.
2. In Object Mode, apply rotation and scale to visible mesh objects.
3. Do not casually apply Armature object transforms after animation work begins.
4. Remove unused cameras, lights, duplicate meshes, and test objects.
5. Keep mesh, skeleton, and animation bind spaces identical.

Minimum reference nodes:

```text
root
└─ tag_view
   ├─ tag_camera
   └─ tag_ads
      └─ tag_weapon
         └─ main weapon bone (for example, j_gunx)
            ├─ weapon meshes and moving mechanisms
            ├─ tag_align_gun
            ├─ tag_weapon_focus (when needed)
            └─ tag_brass
```

The indentation above is the required parent hierarchy, not merely a list of names. The main chain is `root → tag_view → tag_ads → tag_weapon → main weapon bone`. `tag_camera` is a sibling of `tag_ads` under `tag_view`; it is not a child of `tag_weapon`.

| Child | Required parent | Reason |
|---|---|---|
| `tag_view` | `root` | Establishes the first-person view space |
| `tag_camera` | `tag_view` | Carries camera-only animation |
| `tag_ads` | `tag_view` | Owns hip-to-ADS pose transitions |
| `tag_weapon` | `tag_ads` | Places the weapon and hands in the current aiming space |
| Main weapon bone, such as `j_gunx` | `tag_weapon` | Carries weapon meshes and weapon animation |
| `tag_align_gun`, `tag_weapon_focus`, `tag_brass` | A moving branch below the main weapon bone | These references must follow weapon animation; weapon-specific intermediate bones are allowed |

For a modular weapon, `tag_flash` normally belongs to the barrel GLB below its `tag_barrel_attach` branch. For a one-piece model, place it below the moving main-weapon branch. Never parent it directly to `root`, `tag_view`, or `tag_camera`.

`tag_view` is the first-person view reference. `tag_camera` carries camera animation and is not a replacement for `tag_view`. Put `tag_flash` at the real muzzle and `tag_brass` at the ejection port.

Export the mesh, skeleton, skin, and nodes to:

```text
assets/tutorial/gltf/guns/training_rifle/training_rifle_receiver_default.glb
```

Use glTF Binary (`.glb`), export only required objects, retain skinning, and do not include unrelated Actions or NLA strips in the model GLB.

Checkpoint:

- Reimporting the GLB preserves `+X` muzzle direction, scale, hierarchy, and node names.
- `tag_flash` and `tag_brass` are in the correct place.

## Step 3: Add textures and the item icon

Create:

```text
assets/tutorial/skins/guns/training_rifle.png
assets/tutorial/skins/guns/training_rifle_n.png
assets/tutorial/skins/guns/training_rifle_s.png
assets/tutorial/textures/item/guns/training_rifle.png
```

The first file is base color/alpha, `_n` is the tangent-space normal map, and `_s` is GWO material/specular data. The item icon needs a transparent background. Give transparent meshes stable, separate names so they can later be listed under `transparent_nodes`.

## Step 4: Export a minimal animation library

Create exactly these six Actions first:

```text
static_idle
draw
holster
fire
reload
reload_empty
```

In Blender:

1. Select the main Armature.
2. Open `Dope Sheet → Action Editor`.
3. Create and immediately name each Action.
4. Use 30 FPS for this tutorial.
5. Key only nodes the Action actually owns.
6. Remove empty Actions, `.001` duplicates, test NLA strips, and accidental static channels.
7. Make `draw` end at the `static_idle` reference and prevent `fire` from leaving root displacement behind.

Export the animation library to:

```text
assets/tutorial/gltf/animations/training_rifle_receiver_default.anim.glb
```

The model and animation GLBs must share bone names, hierarchy, and bind pose. See [Animation Authoring and Export Rules](animation.md) before adding additive or layered clips.

Checkpoint:

- All six clip names are present and unique.
- Clips may start at frame 0.
- There is no `applies to joints that are not from the same skin` warning.

## Step 5: Define ammunition

Create `bullets/training_ammo.json`:

```json
{
  "id": "tutorial:training_ammo",
  "display_name": "Training Ammunition",
  "family": "tutorial:training_caliber",
  "icon_model_data": 30001,
  "ballistics": {
    "max_entity_hits": 1
  },
  "tracer": {
    "count_interval": 0,
    "color": "#FFFFEBA0",
    "size_multiplier": 1.0,
    "length_multiplier": 1.0
  }
}
```

This first pass intentionally omits cartridge and casing models. Add them after logic works, using [Firearms, Ammunition, and Materials](firearms.md).

Run:

```text
/gwo reload
/gwo give ammo tutorial:training_ammo
```

Checkpoint: the ammo definition loads without an error and the command gives the item.

## Step 6: Define firearm gameplay

Create `weapons/firearms/training_rifle.json`:

```json
{
  "id": "tutorial:training_rifle",
  "display_name": "Training Rifle",
  "creative_category": "assault_rifle",
  "creative_sort": 100,
  "model_data": 30000,
  "magazine_size": 30,
  "ammo": {
    "default": "tutorial:training_ammo",
    "accepted_families": ["tutorial:training_caliber"]
  },
  "damage": 8.0,
  "range": 96.0,
  "ballistics": {
    "muzzle_velocity": 500.0,
    "gravity": 9.8,
    "drag": 0.015,
    "water_drag": 0.6,
    "life_seconds": 2.5,
    "hitbox_inflation": 0.12,
    "headshot_multiplier": 1.5,
    "headshot_height_fraction": 0.25,
    "damage_curve": [
      {"distance": 0, "multiplier": 1.0},
      {"distance": 32, "multiplier": 1.0},
      {"distance": 64, "multiplier": 0.85},
      {"distance": 96, "multiplier": 0.65}
    ]
  },
  "inaccuracy": {
    "stand": 5.0,
    "move": 5.5,
    "sneak": 2.75,
    "lie": 1.5,
    "aim": 0.1
  },
  "mechanics": {
    "rpm": 600,
    "fire_interval_ms": 100,
    "action_commit_ms": {
      "reload": 1300,
      "reload_empty": 1800
    }
  },
  "fire_modes": ["semi"],
  "render": "weapons/firearms/render/training_rifle.render.json"
}
```

`60000 / rpm` must approximately equal `fire_interval_ms`. `accepted_families` matches the ammunition `family`, not its filename. Reload commits change gameplay ammo; animation and sound frames do not.

## Step 7: Add rendering and Animation Machine v2

Create `weapons/firearms/render/training_rifle.render.json` and copy the complete minimal configuration below:

```json
{
  "gltf_model": "tutorial:gltf/guns/training_rifle/training_rifle_receiver_default.glb",
  "animation_sources": [
    "tutorial:gltf/animations/training_rifle_receiver_default.anim.glb"
  ],
  "texture": "tutorial:skins/guns/training_rifle.png",
  "normal": "tutorial:skins/guns/training_rifle_n.png",
  "specular": "tutorial:skins/guns/training_rifle_s.png",
  "icon_texture": "tutorial:textures/item/guns/training_rifle.png",
  "animation_clips": {
    "static_idle": "static_idle",
    "draw": "draw",
    "holster": "holster",
    "fire": "fire",
    "reload": "reload",
    "reload_empty": "reload_empty"
  },
  "animation_events": {
    "draw": "draw",
    "holster": "holster",
    "fire": "fire",
    "reload": "reload",
    "reload_empty": "reload_empty"
  },
  "animation_machine": {
    "version": 2,
    "actions": {
      "draw": {"type": "finite", "default_state": "draw"},
      "holster": {"type": "finite", "default_state": "holster"},
      "fire": {
        "type": "finite",
        "default_state": "fire",
        "events": [
          {"type": "shot_effects", "marker": "shot", "offset_ms": 0},
          {"type": "fire_sound", "marker": "shot", "offset_ms": 0},
          {"type": "recoil", "marker": "shot", "offset_ms": 0}
        ]
      },
      "reload": {
        "type": "finite",
        "default_state": "reload",
        "variants": [
          {"state": "reload_empty", "priority": 100, "when": {"empty": "true"}},
          {"state": "reload", "priority": 0}
        ]
      }
    },
    "interrupts": []
  },
  "animation_controller": {
    "channels": {
      "draw": {"clip": "draw", "layer": "action", "loop": false, "duration_frame": 24},
      "holster": {"clip": "holster", "layer": "action", "loop": false, "duration_frame": 21},
      "fire": {"clip": "fire", "layer": "recoil", "loop": false, "duration_frame": 8},
      "reload": {"clip": "reload", "layer": "action", "loop": false, "duration_frame": 76, "lock_fire": true},
      "reload_empty": {"clip": "reload_empty", "layer": "action", "loop": false, "duration_frame": 81, "lock_fire": true}
    }
  },
  "gltf_scale": 0.075,
  "first_person": {
    "anchor_node": "tag_camera",
    "camera_node": "tag_view",
    "use_camera_transform": true,
    "translation": {"x": 0, "y": 0, "z": 0},
    "rotation": {"x": 0, "y": 0, "z": 0},
    "scale": 1
  },
  "camera": {"model_fov": 50},
  "shell_effect": {"anchor_bone": "tag_brass"}
}
```

Replace every `duration_frame` with the real clip length. Do not use display translation to repair a backwards model, and do not use global scale to repair one attachment.

## Step 8: First in-game acceptance pass

Restart the game for the first complex GLB load, then run:

```text
/gwo reload
/gwo give firearm tutorial:training_rifle
/gwo give ammo tutorial:training_ammo
```

Verify in order:

1. The weapon appears in inventory.
2. Equip plays `draw`.
3. Idle does not drift.
4. Fire consumes ammunition and plays `fire`.
5. Tactical reload commits at `action_commit_ms.reload`.
6. Empty reload selects `reload_empty`.
7. Holstering plays `holster`.
8. Muzzle effects originate at `tag_flash`.
9. Logs contain no missing clip, missing node, cross-skin, or JSON error.

Common diagnosis:

| Symptom | Check first |
|---|---|
| No creative item | definition path, `id`, `render`, reload log |
| Purple/black item | missing texture or item icon |
| Reversed weapon | Blender `+X` muzzle direction |
| Wrong size | model units, applied mesh scale, `gltf_scale` |
| No animation | source path, clip name, clip map, state reference |
| Reload animates but ammo does not change | `mechanics.action_commit_ms` |
| Wrong muzzle/casing origin | `tag_flash` / `tag_brass` transform |
| Changes appear ignored | duplicate IDs, folder plus ZIP, cache requiring restart |

## Step 9: Add arms

Export the arm template to `assets/tutorial/gltf/arms/arms.glb` and add:

```jsonc
"first_person_arms": true,
"arms": {
  "model": "tutorial:gltf/arms/arms.glb",
  "poses": {
    "draw": {"blend_ticks": 5},
    "holster": {"blend_ticks": 5},
    "fire": {"blend_ticks": 2},
    "reload": {"blend_ticks": 6},
    "reload_empty": {"blend_ticks": 6}
  }
}
```

The arm model and animation library must share skeleton names and bind pose. A mismatch should be fixed in authoring space, not hidden with a weapon-specific hardcoded arm offset.

## Step 10: Add aiming, audio, and modules separately

Add one system per test cycle:

1. Add `aim_in`, `aim_out`, and `aim_fire`, then configure aim actions, channels, `tag_ads`, and paired actions.
2. Register OGG Vorbis events in `sounds.json`; use weapon `sound_events` for firing and `animation_commands` for timed mechanical sounds.
3. Separate one default part at a time. Each part needs its definition, render file, slot, `default_installed`, real `anchor_node`, module reference, and matching reference space.
4. Add `draw_first`, last-round, dry-fire, inspect, sprint, fire-mode, melee, ammo-state, effects, Weapon Sway, and display transforms only after the previous pass is stable.

Weapon-specific branches:

| Type | Rule |
|---|---|
| `xmaglrg` | keep separate `*_xmaglrg` states and commits |
| `drummag` | keep separate `*_drummag` states; it is not xmaglrg |
| tube shotgun | use `reload_system.type: tube_per_round`; author event frames only |
| bolt-action rifle | add `fire_rechamber` and `aim_fire_rechamber` cycle recovery |
| standalone melee | use `weapons/melee/` and its own combo machine |

## Final release checkpoint

Complete [Debugging, Acceptance, and Release](debugging-release.md), then verify a clean game restart—not only hot reload. Do not ship duplicate packs, absolute local paths, source `.blend` files, diagnostics, caches, backups, or obsolete compatibility data. A release ZIP must expose `pack.mcmeta`, `weapons`, `attachments`, `bullets`, and `assets` at its root.

Recommended reading order:

1. [Empty Template](empty-template.md)
2. This page
3. [Model Rules](models.md)
4. [Animation Rules](animation.md)
5. [Firearms and Ammo](firearms.md)
6. [Attachments and Optics](attachments-optics.md)
7. [Audio and UI](audio-ui.md)
8. [Debugging and Release](debugging-release.md)
