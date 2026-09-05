---
title: Independent Arm Source Templates
category:
  - Model and Animation Routes
---

# Independent arm source templates

Choose your [workflow](./choose-workflow.md), then download its template. All three are based on the same arms.

| Workflow | Editable source | Notes |
| --- | --- | --- |
| Blender Armature | [Download arms.blend](/downloads/gwo_arms_template_blender33.blend) | Original Blender 3.3 template |
| Blender Empty | [Download arms_empty.blend](/downloads/arms_empty.blend) | Blender 3.3; parented meshes without skinning |
| Blockbench Bedrock | [Download arms_blockbench.bbmodel](/downloads/arms_blockbench.bbmodel) | Editable groups and cubes; accompanying [geometry JSON](/downloads/arms_blockbench.geo.json) |

::: warning Source templates are not verified runtime integration
The new Empty and Bedrock templates have passed hierarchy, position, and UV data checks. Independent-arm loading, player skin binding, and in-game animation have not been validated. Dropping these files into a pack does not automatically enable them. This documentation update does not change the mod's arm loader.
:::

## 1. Open and choose an arm variant

Open `.blend` in Blender or `.bbmodel` in Blockbench. Each template includes left/right arms, regular-width `MALE`, slim-width `SLIM`, and outer skin `LAYER` parts.

- Regular and slim arms are alternatives; do not preview both together.
- The Empty template hides SLIM only in the viewport. Check export selection and visibility separately.
- The original source contains no embedded skin image. Import your own 64×64 player skin for preview; a missing image does not mean missing UVs.

## 2. Hierarchy and animation targets

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

## 3. Scale, UVs, and export

The Empty version preserves the original meshes and UVs. The Blockbench version reconstructs the subdivided boxes as 8 editable cubes while retaining dimensions and UV mapping.

Bedrock uses 16 model units per render unit. This conversion is already included to match the original model's size; do not multiply by 16 or scale to 0.25 again. BBMODEL editor coordinates and Bedrock export coordinates use different X-axis conventions; do not copy coordinates manually between them.

`.blend` and `.bbmodel` are editing sources, not runtime files. Follow the [Empty route](./blender-empty.md) to export GLB or the [Blockbench route](./blockbench.md) to export geometry and animation JSON. Reopen exports to check them. Independent-arm runtime integration still requires separate validation.
