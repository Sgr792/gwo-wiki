---
title: Arm Authoring Templates
category:
  - Model and Animation Routes
---

# Arm authoring templates

Choose your [workflow](./choose-workflow.md), then download its template. All three are based on the same arms.

| Workflow | Editable source | Notes |
| --- | --- | --- |
| Blender Armature | [Download arms.blend](/downloads/gwo_arms_template_blender33.blend) | Original Blender 3.3 template |
| Blender Empty | [Download arms_empty.blend](/downloads/arms_empty.blend) | Blender 3.3; parented meshes without skinning |
| Blockbench Bedrock | [Download arms_blockbench.bbmodel](/downloads/arms_blockbench.bbmodel) | Editable groups and cubes; accompanying [geometry JSON](/downloads/arms_blockbench.geo.json) |

::: warning Use a build containing the arm integration
Revision `ad17487` adds independent-arm child selection and pose transforms for Empty GLB and Bedrock geometry. Automated tests cover both sides, regular/slim selection, outer layers, and relative child transforms. General gameplay regression passed, but dedicated visual acceptance of the two new templates is still pending. Copying editing sources into a pack does not enable them.
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

Open `.blend` in Blender or `.bbmodel` in Blockbench. Each template includes left/right arms, regular-width `MALE`, slim-width `SLIM`, and outer skin `LAYER` parts.

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

Animate Empty transforms in Blender or group transforms in Blockbench. These move whole arm parts without skinned elbow or finger deformation. No idle, fire, or reload animations are supplied.

## Scale, UVs, and export

The Empty version preserves the original meshes and UVs. The Blockbench version reconstructs the subdivided boxes as 8 editable cubes while retaining dimensions and UV mapping.

Bedrock uses 16 model units per render unit. This conversion is already included to match the original model's size; do not multiply by 16 or scale to 0.25 again. BBMODEL editor coordinates and Bedrock export coordinates use different X-axis conventions; do not copy coordinates manually between them.

`.blend` and `.bbmodel` are editing sources, not runtime files. Follow the [Empty route](./blender-empty.md) to export GLB or the [Blockbench route](./blockbench.md) to export geometry and animation JSON. Reopen exports to check them.

## Enable in a content pack

These are fragments of the weapon configuration. Choose one `arms.model`; do not add duplicate `arms` objects.

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

For Bedrock, place geometry at `assets/example/models/arms/arms_blockbench.geo.json`:

```json
{
  "arms": {
    "enabled": true,
    "model": "example:models/arms/arms_blockbench.geo.json",
    "left_holder_bone": "LEFT_ARM",
    "right_holder_bone": "RIGHT_ARM"
  }
}
```

Replace `example` with your namespace. Actions still belong to the weapon animation library; `arms.model` selects geometry only. Preserve the eight MALE/SLIM/LAYER part nodes, the arm holders, and their reference space. Child meshes may have custom names but must remain under the correct part.

Reload the pack and check both player-skin widths, both arms, outer layers, grip, reload, inspection, and shaders. Verify there are no duplicate, displaced, or missing arms before publishing.
