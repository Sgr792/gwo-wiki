---
title: Blender Model Rules
order: 2
category:
  - Content-Pack Authoring
---

## 6. Coordinates and bind pose

The muzzle points along model-space `+X`. Apply mesh rotation and scale, but do not casually apply armature object transforms before export. Receiver, default parts, animation library, and independent arms must share bone names, hierarchy, bind pose, and reference space.

## 7. Core nodes and attachment points

| Node | Purpose |
|---|---|
| `root` | Weapon root |
| `tag_weapon` | Primary first-person weapon/hand reference |
| `tag_view` | First-person view reference |
| `tag_camera` | Camera animation only |
| `tag_ads` | ADS alignment and transition |
| `tag_align_gun`, `tag_weapon_focus` | Alignment/focus references |
| `tag_flash` | Muzzle flash and tracer origin |
| `tag_brass` | Ejected-case origin |
| `tag_cosmetic` | Charm anchor |
| `tag_barrel_attach`, `tag_mag_attach`, `tag_stock_attach` | Default/optional part anchors |
| `tag_pistolgrip_attach`, `tag_trigger_attach`, `tag_guard_attach` | Grip, trigger, and guard/pump anchors |
| `tag_laser_attach` | Laser-device model anchor |
| `tag_laser` | Laser beam origin inside the device |
| `tag_hybrid` | Hybrid-optic anchor |

Never substitute `tag_camera` for `tag_view`.

## 8. Default parts

```json
{
  "model": "example:gltf/guns/example_rifle/example_rifle_barrel_default.glb",
  "texture": "example:skins/guns/example_rifle.png",
  "normal": "example:skins/guns/example_rifle_n.png",
  "specular": "example:skins/guns/example_rifle_s.png",
  "icon_texture": "example:textures/item/attachments/example_rifle_barrel_default.png",
  "anchor_node": "tag_barrel_attach"
}
```

For reversed, offset, incorrectly scaled, or non-animated parts, check the shared reference space, exact anchor spelling, node ownership in the animated rig, extra root transforms, and multi-armature export ownership.

## 9. Empty nodes and arm template

Blender Empty nodes may drive simple rigid child meshes. Complex first-person blending, masks, and hand-follow behavior are most reliable with bones. Download the [Blender 3.3 arm template](/gwo-wiki/downloads/gwo_arms_template_blender33.blend); if you change its skeleton, update the weapon animation library and independent arm model together.
