---
title: Getting Started
order: 1
category:
  - Content-Pack Authoring
---

## 1. Requirements

- Minecraft 1.21.1, the matching NeoForge build, and GWO.
- Blender 3.3 for models, rigs, and animation.
- [GWO arm authoring template for Blender 3.3](/gwo-wiki/downloads/gwo_arms_template_blender33.blend).
- A UTF-8 JSON editor, a PNG editor, and an OGG Vorbis encoder.
- The [GWO empty content-pack template](/gwo-wiki/downloads/gwo_empty_content_pack_template.zip), which uses the current directory format and contains no legacy compatibility content.

GWO uses `.glb` for models, `.anim.glb` for animation libraries, `.png` for textures and icons, `.ogg` for sounds, and `.json` for behavior/render definitions. Use lowercase ASCII letters, digits, and underscores in resource paths.

## 2. Pack location

Place development folders or distributable ZIP files in:

```text
.minecraft/gwo/
```

Keep a valid `pack.mcmeta` during development. GWO can generate basic metadata as a safety fallback when a folder pack is missing it, but it cannot modify a ZIP. A release ZIP must therefore contain `pack.mcmeta`, `weapons`, `bullets`, and `assets` directly at its root; do not wrap them in another directory.

## 3. Recommended layout

```text
example_pack/
├─ pack.mcmeta
├─ weapons/
│  ├─ firearms/
│  │  ├─ example_rifle.json
│  │  └─ render/example_rifle.render.json
│  └─ melee/
├─ attachments/
│  ├─ barrels/ magazines/ sights/ stocks/
│  └─ render/
├─ bullets/example_ammo.json
└─ assets/example/
   ├─ gltf/
   │  ├─ animations/example_rifle_receiver_default.anim.glb
   │  ├─ arms/arms.glb
   │  ├─ guns/example_rifle/
   │  ├─ attachments/
   │  └─ bullets/
   ├─ skins/
   ├─ textures/item/
   ├─ models/item/
   ├─ lang/zh_cn.json
   ├─ lang/en_us.json
   ├─ sounds/
   └─ sounds.json
```

Default receiver, barrel, magazine, grip, and stock models belong under `gltf/guns/<weapon_id>/`. Reusable optional parts belong under `gltf/attachments/`.

## 4. Metadata and resource IDs

```json
{
  "pack": {
    "pack_format": 48,
    "supported_formats": [34, 48],
    "description": "Example GWO Content Pack"
  }
}
```

`example:gltf/guns/example_rifle/model.glb` maps to `assets/example/gltf/guns/example_rifle/model.glb`. Paths such as the `render` field are relative to the pack root.

## 5. Recommended production order

1. Create folders and `pack.mcmeta`.
2. Export the receiver and a minimal animation library.
3. Define ammunition, weapon behavior, and render configuration.
4. Test spawn, orientation, firing, and reload.
5. Split and attach default parts.
6. Add ADS, sprint, empty-state, inspect, melee, and sound events.
7. Add optional attachments, optics, lasers, and charms.
8. Finish third person, item frames, modification UI, dropped items, and icons.
9. Validate the folder build, then create a ZIP for distribution.
