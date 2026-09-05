---
title: Attachments, Optics, and Charms
order: 5
category:
  - Content-Pack Authoring
---

## Attachments

Each attachment has behavior and render definitions. The render file binds its model and maps to an `anchor_node`; the behavior file declares compatible weapons/slots and stat modifiers. Use the real animated attachment point from the receiver rig.

Nested points must follow the installed part that owns them. For example, a pistol optic attached to `tag_reflex` on an animated barrel must resolve that node through the barrel's current animated transform.

### Visibility rules

Use explicit show/hide nodes for iron sights, laser mounts, bipods, alternate magazines, and similar conditional geometry. Verify the exact bone name and intended condition. A hidden node's descendants are hidden as well, so avoid placing unrelated parts beneath it.

### Attachment-specific animation

Alternative magazines or moving guards may select replacement actions such as `reload_xmaglrg`. Their duration and event frames belong to that animation set and must not reuse incompatible default timing.

Keep magazine families separate: `xmaglrg` is a large extended box magazine and uses `*_xmaglrg` states; `drummag` is a drum magazine and uses independent `*_drummag` states. When both exist, `animation_override` must route normal/empty, hip/ADS, inspect, empty-additive, and ammunition-additive actions to the matching family rather than changing only the model and capacity.

## Optics

A projected reticle normally declares lens and reticle nodes, texture, scale, parallax, stabilization, response, emissive/glow strength, and ADS threshold. Keep the physical glass mesh and runtime reticle separate.

Magnified optics use the single world render plus a lens stencil/mask while retaining GWO's physical lens mesh, reticle, eye relief, and in-scope laser. Verify no weapon/iron-sight ghost silhouette leaks into the scope.

Physical glass opacity belongs in the render definition's `transparent_nodes`. Only real lens nodes such as `scope_front_lens` and `scope_rear_lens` use `alpha` as glass opacity; lower values generally reduce opacity. This is a multiplier, not final pixel opacity: `1.0` leaves this factor unchanged, while texture alpha and other rendering factors still apply. `scope_stencil`, `scope_relief`, and `scope_reflection` are optical helper geometry rather than ordinary glass. Control the reflection overlay with `scope_reflection_alpha`. After changing compiled render materials, use `F3+T` or restart the client; `/gwo reload` alone does not rebuild GPU material caches.

Hybrid optics declare both modes and a programmatic transition. The magnified image must appear only when the physical magnifier reaches the configured transition point; closing follows the inverse handoff. Variable magnification should expose discrete supported levels and preserve reticle shape/scale.

### Programmatic tactical stance

Tactical stance belongs in the firearm render definition rather than an optic animation:

```jsonc
"canted_aim": {
  "enabled": true,
  "pose_node": "tag_ads",
  "pivot_node": "tag_weapon",
  "translation": {
    "x": 0.0,
    "y": 0.0,
    "z": 0.0
  },
  "rotation": {
    "x": -55.0,
    "y": 0.0,
    "z": 0.0
  },
  "response": 22.0,
  "damping": 0.62,
  "fov_multiplier": 1.0
}
```

The player holds ADS and presses V to toggle normal ADS/tactical stance for that weapon identity. Magnified and hybrid optics disable the toggle; iron sights, reflex sights, and holographic sights may use it. No laser attachment is required. A temporary first-person canted laser is scoped to one stance session: manually turning it off during that session is respected instead of being forced on again on the next frame. `pose_node` and `pivot_node` must exist in the weapon GLB. Rotation/translation define the target pose, response/damping shape the transition, and a `fov_multiplier` of `1.0` releases optic magnification. Do not bind legacy canted or NVG ADS clips to this route.

## Charms

Charms attach to `tag_cosmetic`. A physics charm needs a stable pivot, content-defined colliders, damping, and motion limits; it must not infer arbitrary weapon collision from render bounds. Dynamic avatar charms may asynchronously fetch a player's current skin and render a runtime nameplate, while their chain continues to use authored PBR textures.

## Configuration examples

These examples use the same fields as the Chinese reference. Replace resource IDs, timings, and model-specific nodes with your own. `json` blocks are JSON objects; `jsonc` blocks are fragments to merge, not standalone pack files. Valid JSON alone does not make a complete working weapon.

### Magazine behavior definition

```json
{
  "id": "example:example_extended_mag",
  "type": "magazine",
  "slot": "magazine",
  "display_name": "Example Extended Magazine",
  "display_name_en": "Example Extended Magazine",
  "default_installed": false,
  "parent_types": ["gun"],
  "properties": {
    "set": {
      "capacity": 60
    }
  },
  "render": "attachments/render/magazines/example_extended_mag.render.json"
}
```

### Nested laser behavior definition

```json
{
  "id": "example:red_laser",
  "type": "laser",
  "slot": "laser",
  "default_installed": false,
  "parent_types": ["barrel"],
  "parent_slots": ["barrel"],
  "laser": {"color": "#ff0000"},
  "render": "attachments/render/lasers/red_laser.render.json"
}
```

### Nested laser render definition

```json
{
  "model": "example:gltf/attachments/red_laser.glb",
  "texture": "example:skins/attachments/red_laser.png",
  "normal": "example:skins/attachments/red_laser_n.png",
  "specular": "example:skins/attachments/red_laser_s.png",
  "icon_texture": "example:textures/item/attachments/red_laser.png",
  "anchor_node": "tag_laser_attach"
}
```

### Weapon bone visibility (merge into render definition)

```jsonc
"gun_bone_visibility": {
  "when_slot_empty": {
    "sight": {
      "show": ["tag_sight_on"],
      "hide": ["tag_sight_off"]
    }
  },
  "when_slot_occupied": {
    "sight": {
      "show": ["tag_sight_off"],
      "hide": ["tag_sight_on"]
    }
  }
}
```

### Reflex behavior sight settings

```jsonc
"sight": {
  "enabled": true,
  "type": "reflex",
  "scope_rate": 1.0
}
```

### Reflex render sight settings

```jsonc
"sight": {
  "reticle_node": "tag_reticle_attach",
  "reticle_plane_node": "tag_lense",
  "rear_lens_node": "rear_lens",
  "lens_node": "lens_glass_ads",
  "projected_reticle": true,
  "reticle_texture": "example:textures/sights/red_dot.png",
  "reticle_emissive_strength": 1.5,
  "reticle_scale": 1.0,
  "reticle_virtual_depth": 1.0
}
```

### Magnified behavior sight settings

```jsonc
"sight": {
  "enabled": true,
  "type": "scope",
  "scope_rate": 4.0,
  "ads_z_compensation": 1.0
}
```

## Integration checklist

Every selectable attachment must be listed in the weapon's `modules`. Default parts also need `default_installed: true`. Properties use supported `set`, `add`, and `multiply` keys; a plausible name is not proof that a stat exists.

The installation anchor and the laser's internal `tag_laser` emitter are different. Use the actual animated parent anchor, not a guessed similar name.

For attachment-specific animations, check clip mappings, controller channels, event categories, ADS pairs, timed commands, reload phases, and mechanical commits. Keep xmaglrg and drummag as separate families where the weapon has both.

For a full fixed scope and a physics charm starting configuration, use [Configuration Examples](./config-examples.md). Hybrid optics must declare separate mode nodes, reticles, and magnification; a global FOV change is not a complete hybrid implementation. Variable optics should share one model, not duplicate a model for every magnification.

An avatar charm's head and nameplate must not receive the chain material. Its configured player name/UUID and geometry names must be your own; do not depend on a particular supporter example from another pack.

For independent teaching configurations without default-pack assets, see [Configuration Examples](./config-examples.md). Existing valid fields and explicit defaults should be preserved when merging examples.
