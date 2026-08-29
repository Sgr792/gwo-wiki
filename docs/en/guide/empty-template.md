---
title: Download and Use the Empty Template
order: 2
category:
  - Beginner Course
---

# Download and Use the Empty Template

This page creates a correctly structured GWO content pack. The template contains no weapon, model, animation, texture, sound, or legacy compatibility fields.

## 1. Download

[Download the GWO empty content-pack template](/gwo-wiki/downloads/gwo_empty_content_pack_template.zip)

You can also download the [Blender 3.3 first-person arm template](/gwo-wiki/downloads/gwo_arms_template_blender33.blend).

Extract the ZIP before editing it. Use a normal folder while developing so files can be changed and reloaded easily.

## 2. Install the folder

Copy the extracted `gwo_empty_content_pack` folder to:

```text
.minecraft/gwo/
```

The final path must be:

```text
.minecraft/gwo/gwo_empty_content_pack/pack.mcmeta
```

It must not contain another duplicated folder level. The empty template adds no items when the game starts; that is expected.

## 3. Choose a namespace

The template uses `example`. Choose a namespace containing lowercase English letters, digits, and underscores only, such as `my_studio`.

Rename:

```text
assets/example/
```

to:

```text
assets/my_studio/
```

Every resource ID must then use the same prefix:

```jsonc
"id": "my_studio:training_rifle"
```

Do not use spaces, uppercase letters, parentheses, or hyphens in resource paths.

## 4. Directory purpose

| Directory | Contents |
|---|---|
| `weapons/firearms/` | firearm gameplay JSON |
| `weapons/firearms/render/` | firearm rendering and animation JSON |
| `weapons/melee/` | standalone melee gameplay JSON |
| `weapons/melee/render/` | standalone melee rendering JSON |
| `bullets/` | ammunition definitions |
| `attachments/<type>/` | attachment definitions |
| `attachments/render/<type>/` | attachment rendering files |
| `assets/<namespace>/gltf/guns/` | default gun models |
| `assets/<namespace>/gltf/animations/` | `.anim.glb` libraries |
| `assets/<namespace>/gltf/arms/` | first-person arms |
| `assets/<namespace>/gltf/attachments/` | shared attachments |
| `assets/<namespace>/gltf/bullets/` | cartridges, casings, and projectiles |
| `assets/<namespace>/skins/` | base color, normal, material, and emissive maps |
| `assets/<namespace>/textures/item/` | inventory icons |
| `assets/<namespace>/textures/gui/hud/` | HUD icons |
| `assets/<namespace>/sounds/` | OGG audio |
| `assets/<namespace>/sounds.json` | sound registry |
| `assets/<namespace>/lang/` | localization files |

`.gitkeep` files only preserve empty directories in Git and ZIP archives. Delete them after adding real assets if desired.

## 5. Edit pack metadata

Open `pack.mcmeta` and change only the description to begin:

```json
{
  "pack": {
    "pack_format": 48,
    "supported_formats": [34, 48],
    "description": "My Studio Weapon Pack"
  }
}
```

Do not remove the outer `pack` object or leave a trailing comma after the last JSON property.

## 6. Validate the empty pack

Start the game and inspect `logs/latest.log`:

1. GWO scans `.minecraft/gwo/`.
2. There is no `Failed to read weapon definition` message.
3. There is no `Failed to read ammunition definitions` message.
4. There are no JSON or resource-path errors.
5. No new item appears, because this template intentionally contains no content.

## 7. Package for release

During development, keep the pack as a folder. For release, archive the files inside the pack. Opening the ZIP must immediately show:

```text
pack.mcmeta
weapons/
attachments/
bullets/
assets/
```

The template targets Minecraft 1.21.1 and the current GWO format. It does not use the removed `guns/` directory or obsolete compatibility fields.

Next: [Build Your First Firearm](first-firearm.md).
