---
title: Firearms, Ammunition, and Materials
order: 4
category:
  - Content-Pack Authoring
---

## Ammunition

An ammunition definition owns caliber identity, damage/ballistics, inventory icon, loaded-round model, and spent-case model. A weapon references compatible ammunition IDs; magazines change capacity and animation behavior but do not replace the caliber definition.

Keep loaded rounds and spent cases under `assets/<namespace>/gltf/bullets/`, with base-color, normal, and specular textures under `skins/bullets/`. Each cartridge type may provide a different case model, so ejection follows the currently loaded ammunition.

## Firearm behavior JSON

Start from the closest official example: magazine-fed rifle, pistol, tube-fed shotgun, or bolt-action rifle. Important groups include:

- identity, class, compatible ammunition, capacity, chamber behavior;
- fire mode, rate, range, damage, projectile count, and spread;
- reload/rechamber state and event frames;
- hip/ADS recoil and Weapon Sway;
- animation interruption and action timing;
- default and optional attachment slots.

Do not copy shotgun shell-loop rules into a detachable-magazine weapon, or automatic scheduling into a bolt-action weapon.

Magazine-fed finite actions use `mechanics.action_commit_ms`. A tube-fed shotgun with `reload_system.type: "tube_per_round"` instead authors only the event frames under `reload_system.events`; runtime derives server timing from `animation_fps`, so do not add duplicate per-round `*_ms` fields.

Use `creative_category` to select both the creative-tab group and the weapon-type label shown in the modification screen. Standard values are `assault_rifle`, `battle_rifle`, `submachine_gun`, `shotgun`, `light_machine_gun`, `marksman_rifle`, `sniper_rifle`, `pistol`, `launcher`, and `melee`. `creative_sort` controls ordering within a category. Unknown values fall back to `assault_rifle`.

## Firearm render JSON

The render file binds model, animation library, arms, materials, nodes, action names, and display transforms. Typical declarations include:

```json
{
  "gltf_model": "example:gltf/guns/example_rifle/example_rifle_receiver_default.glb",
  "animation_sources": [
    "example:gltf/animations/example_rifle_receiver_default.anim.glb"
  ],
  "texture": "example:skins/guns/example_rifle.png",
  "normal": "example:skins/guns/example_rifle_n.png",
  "specular": "example:skins/guns/example_rifle_s.png"
}
```

Define transforms independently for first person, third-person pose, offhand stow, modification screen, fixed/item-frame display, and dropped items. A display transform should use the static model pose rather than an authored idle clip.

## Recoil and Weapon Sway

Hip and ADS recoil are separate parameter sets. `vertical` and `horizontal` control view recoil; `model_back` controls model-space rearward impulse; `randomness` and `recovery` shape variation and return. `auto_recovery: false` disables automatic view return for weapons that require manual correction.

Weapon Sway is a spring-like location/rotation offset around the authored pose. It must not be baked into animation clips and must be consumed consistently by the weapon, muzzle, tracers, lasers, and magnified-optic path.

## Muzzle effects and projectiles

`tag_flash` supplies the muzzle origin, while the actual projectile remains authoritative for collision and damage. Tracers are visual segments that begin at the animated muzzle and converge toward the physical trajectory. Shotguns create one physical pellet/tracer path per configured pellet, not one decorative beam for the whole shot.

Use `tracer.count_interval: 0` whenever every shot must display a tracer. Validate high-velocity ammunition at short, medium, and long range: every first-person muzzle event should still create its visual tracer even when the authoritative projectile hits or leaves view almost immediately. If only one weapon is affected, inspect that ammunition's own `tracer` configuration before changing fire rate or animation event frames.

Muzzle flash and smoke use separate resources. Verify both first and third person, with and without shaders, while moving the camera quickly. Spent cases originate at `tag_brass` and use the currently loaded ammunition's case model.

## Texture channels

- Base color: `*.png`
- Tangent-space normal: `*_n.png`
- GWO packed material/specular map: `*_s.png`
- Optional emissive mask: `*_glow.png`

Every default part should explicitly declare the shared base, normal, and specular textures when it uses them. Do not assume a detached part automatically inherits all receiver maps.

## Configuration examples

These examples use the same fields as the Chinese reference. Replace resource IDs, timings, and model-specific nodes with your own. `json` blocks are JSON objects; `jsonc` blocks are fragments to merge, not standalone pack files. Valid JSON alone does not make a complete working weapon.

### Ammunition definition (bullets/example_ammo.json)

```json
{
  "id": "example:example_ammo",
  "display_name": "Example Ammunition",
  "family": "example:example_caliber",
  "icon_model_data": 2001,
  "ballistics": {
    "max_entity_hits": 1
  },
  "tracer": {
    "count_interval": 0,
    "color": "#FFFFEBA0",
    "size_multiplier": 1.0,
    "length_multiplier": 1.0
  },
  "models": {
    "cartridge": {
      "model": "example:gltf/bullets/unspent_example_ammo.glb",
      "texture": "example:skins/bullets/example_ammo.png",
      "normal": "example:skins/bullets/example_ammo_n.png",
      "specular": "example:skins/bullets/example_ammo_s.png",
      "specular_strength": 0.55,
      "roughness_value": 0.35,
      "metallic_value": 0.85
    },
    "casing": {
      "model": "example:gltf/bullets/spent_example_ammo.glb",
      "texture": "example:skins/bullets/example_ammo.png",
      "normal": "example:skins/bullets/example_ammo_n.png",
      "specular": "example:skins/bullets/example_ammo_s.png",
      "specular_strength": 0.55,
      "roughness_value": 0.35,
      "metallic_value": 0.85
    }
  }
}
```

### Firearm gameplay definition (weapons/firearms/example_rifle.json)

```json
{
  "id": "example:example_rifle",
  "display_name": "Example Rifle",
  "creative_category": "assault_rifle",
  "creative_sort": 100,
  "model_data": 2000,
  "magazine_size": 30,
  "ammo": {
    "default": "example:example_ammo",
    "accepted_families": ["example:example_caliber"]
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
      "reload_empty": 1800,
      "aim_reload": 1300,
      "aim_reload_empty": 1800,
      "melee": 233
    }
  },
  "fire_modes": ["auto", "semi"],
  "render": "weapons/firearms/render/example_rifle.render.json"
}
```

### Render-definition starting structure (not a complete animation machine)

```json
{
  "gltf_model": "example:gltf/guns/example_rifle/example_rifle_receiver_default.glb",
  "animation_sources": [
    "example:gltf/animations/example_rifle_receiver_default.anim.glb"
  ],
  "texture": "example:skins/guns/example_rifle.png",
  "normal": "example:skins/guns/example_rifle_n.png",
  "specular": "example:skins/guns/example_rifle_s.png",
  "icon_texture": "example:textures/item/guns/example_rifle.png",
  "modules": {
    "example_rifle_barrel_default": "attachments/barrels/example_rifle_barrel_default.json",
    "example_rifle_mag_default": "attachments/magazines/example_rifle_mag_default.json"
  },
  "animation_clips": {
    "static_idle": "static_idle",
    "draw": "draw",
    "holster": "holster",
    "fire": "fire",
    "reload": "reload",
    "reload_empty": "reload_empty"
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
  "first_person_arms": true,
  "arms": {
    "model": "example:gltf/arms/arms.glb"
  },
  "shell_effect": {
    "anchor_bone": "tag_brass"
  }
}
```

### Weapon sway and recoil (merge into render definition)

```jsonc
"weapon_sway": {
  "enabled": true,
  "hip": {
    "input_gain": 9.0,
    "deadzone": 0.18,
    "max_angle": 5.5,
    "stiffness": 64.0,
    "damping": 15.0,
    "edge_damping": 8.0,
    "location_gain": 0.09,
    "roll_gain": 0.45
  },
  "ads": {
    "input_gain": 4.0,
    "deadzone": 0.06,
    "max_angle": 1.2,
    "stiffness": 80.0,
    "damping": 18.0,
    "edge_damping": 10.0,
    "location_gain": 0.06,
    "roll_gain": 0.35
  }
},
"recoil": {
  "enabled": true,
  "blend_start": 0.15,
  "blend_end": 0.95,
  "blend_curve": "smoothstep",
  "hip": {
    "vertical": 1.0,
    "horizontal": 1.0,
    "model_back": 5.0,
    "randomness": 1.0,
    "recovery": 0.8
  },
  "ads": {
    "vertical": 1.0,
    "horizontal": 1.0,
    "model_back": 7.0,
    "randomness": 1.0,
    "recovery": 0.8
  }
}
```

### Muzzle/tracer options (merge into render definition)

```jsonc
"bullet_tracer": {
  "enabled": true,
  "size_multiplier": 1.0,
  "length_multiplier": 1.0
},
"shell_effect": {
  "anchor_bone": "tag_brass"
}
```

### Material paths (merge into render definition)

```jsonc
"texture": "example:skins/guns/example_rifle.png",
"normal": "example:skins/guns/example_rifle_n.png",
"specular": "example:skins/guns/example_rifle_s.png",
"emissive": "example:skins/guns/example_rifle_glow.png",
"emissive_strength": 1.0
```

### Transparent nodes (merge into render definition)

```jsonc
"transparent_nodes": {
  "lens_glass": {
    "alpha": 0.8,
    "depth_write": false,
    "depth_test": true,
    "double_sided": true
  }
}
```

## Field meanings and checks

- `family` is the ammunition family accepted by the weapon, not its filename.
- `models.cartridge` is the loaded/unfired cartridge; `models.casing` is the spent case.
- `magazine_size` is configured magazine capacity. Reload commit time, not a sound frame, changes ammunition.
- Keep `60000 / mechanics.rpm` consistent with `mechanics.fire_interval_ms`.
- `inaccuracy` controls direction spread; view recoil and authored fire animation are separate.
- `j_ammo_01`, `j_ammo_02`, etc. locate visible rounds. Ammo/follower animations belong to their dedicated state layers.
- The render structure above references default modules. Provide those files and an animation machine; for the beginner one-piece weapon use [First Firearm](./first-firearm.md).

| Transform field | Display context |
| --- | --- |
| `first_person` | First-person base transform |
| `offhand_stowed` | Weapon stowed on the body from offhand |
| `third_person_pose` | Third-person arms and weapon |
| `ground` | Dropped weapon |
| `fixed` | Item frame |
| `modify_screen` | Modification preview |
| `gltf_scale` | Overall model-to-game scale |

Scene-specific scales do not replace correct model units. Static displays should not depend on a moving first-person idle animation.

Material details: base color includes alpha; normals are tangent-space. The non-shaderpack path reads the specular red channel as a highlight mask, while Iris PBR interpretation depends on the shaderpack. Separate `roughness` and `metallic` textures can be used, with `roughness_value` and `metallic_value` as scalar settings when maps are absent. Emissive RGB supplies color, alpha supplies its mask, and `emissive_strength` controls strength. Transparent glass must be a separately named mesh.


For independent teaching configurations without default-pack assets, see [Configuration Examples](./config-examples.md). Existing valid fields and explicit defaults should be preserved when merging examples.
