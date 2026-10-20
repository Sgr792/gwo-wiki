---
title: Arm Authoring Templates
category:
  - Model and Animation Routes
---

# Arm authoring templates

Choose your [workflow](./choose-workflow.md), then download its template. Both are based on the same arms.

| Workflow | Editable source | Notes |
| --- | --- | --- |
| Blender Armature | [Download arms.blend](/downloads/gwo_arms_template_blender33.blend) | Original Blender 3.3 template |
| Blender Empty | [Download arms_empty.blend](/downloads/arms_empty.blend) | Blender 3.3; parented meshes without skinning |

::: warning Use a build containing the arm integration
For Empty independent arms, use a version with the corresponding arm support. Export the template to a runtime format and configure `arms.model`; copying editing sources into a pack does not enable custom arms.
:::


## How GWO currently uses arms

GWO already uses an independent **shared arm mesh**. It loads `gwo:gltf/arms/arms.glb` by default, chooses regular/slim arms and outer layers, and uses the player's skin.

During authoring, put the arms beside the gun and animate them together to check grip, reload, and inspection. At runtime the gun animation supplies arm poses, while the shared model supplies visible arm geometry. **The mesh is independent; the authored motion remains coordinated with the weapon.** Do not make a second set of arm animations.

| Exported information | Purpose |
| --- | --- |
| Weapon mesh and mechanism nodes | Visible weapon and moving parts |
| Required arm reference nodes and animation tracks | Drive runtime arms |
| Authoring preview arm mesh | Not needed in every weapon model when using shared arms |
| Custom `arms.model` | Optional replacement requiring matching names and reference space |

Do not delete arm animation tracks when removing preview geometry. Do not render both the embedded preview arms and runtime arms.

The original Armature arms remain the default. Rigid arms reuse the shared player-skin binding path. Child geometry is assigned through its actual parent hierarchy and retains its relative translation, rotation, and scale; selection does not guess from mesh filenames.

## Open and choose an arm variant

Open the `.blend` template in Blender. It includes left/right holders, regular-width MALE, slim-width SLIM, and outer LAYER parts.

- Regular and slim arms are alternatives; do not preview both together.
- The Empty template hides SLIM only in the viewport. Check export selection and visibility separately.
- The original source contains no embedded skin image. Import your own 64×64 player skin for preview; a missing image does not mean missing UVs.

## Hierarchy and animation targets

```text
arms_root
├─ RIGHT_ARM
│  └─ INNER_R
│     ├─ R_MALE / R_MALE_LAYER
│     └─ R_SLIM / R_SLIM_LAYER
└─ LEFT_ARM
   └─ INNER_L
      ├─ L_MALE / L_MALE_LAYER
      └─ L_SLIM / L_SLIM_LAYER
```

Slashes denote separate sibling nodes. Empty part nodes have `_mesh` children. Preserve names and parent relationships; do not parent the arms directly to the weapon mesh.

Animate Empty transforms in Blender. These move whole arm parts without skinned elbow or finger deformation. No idle, fire, or reload animations are supplied.

## Scale, UVs, and export

The Empty template preserves the original mesh and UVs.


`.blend` is an editing source. Export GLB following the [Empty route](./blender-empty.md), then reimport to check it.

## Enable in a content pack

These are fragments of the weapon configuration. Set `arms.model`; do not add duplicate `arms` objects.

For Empty, export to `assets/example/gltf/arms/arms_empty.glb`:

```json
{
  "arms": {
    "enabled": true,
    "model": "example:gltf/arms/arms_empty.glb",
    "left_holder_bone": "LEFT_ARM",
    "right_holder_bone": "RIGHT_ARM"
  }
}
```

Replace `example` with your namespace. Actions still belong to the weapon animation library; `arms.model` selects geometry only. Preserve the eight MALE/SLIM/LAYER part nodes, the arm holders, and their reference space. Child meshes may have custom names but must remain under the correct part.

Reload the pack and check both player-skin widths, both arms, outer layers, grip, reload, inspection, and shaders. Verify there are no duplicate, displaced, or missing arms before publishing.
