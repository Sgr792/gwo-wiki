---
title: Blockbench · Bedrock Route
category:
  - Model and Animation Routes
---

# Blockbench: Bedrock entity models and animation

[Choose another workflow](./choose-workflow.md)

Need a starting arm project? Download the [Blockbench arm source template](./arm-templates.md).

Create cubes, groups, UVs, and animation in Blockbench. Blender is not required.

::: warning Before starting
Use a development build containing the format update; visual acceptance is pending. Choose a Bedrock entity project, not a Java block/item project. A saved `.bbmodel` alone is not a runtime asset. Numeric keys are supported; Molang, entity controllers, and `poly_mesh` are not.
:::

## 1. Create a project

Create a Bedrock entity project in Blockbench, set its identifier and texture dimensions, and save the editable `.bbmodel`.

Export exactly one `minecraft:geometry` entry per file.

**Checkpoint:** The project uses the Bedrock entity format.

## 2. Cube modeling

Begin with a few cubes for the body and magazine. Orient the finished weapon to GWO's model-space muzzle `+X` convention.

Bedrock positions are converted at 16 model units per render unit. Do not apply that conversion a second time to animation tracks.

**Checkpoint:** Dimensions, positions, and overall direction are correct.

## 3. Groups, pivots, and anchors

Groups become bone nodes on export. Put each mechanism's cubes in its group and place the group pivot at its rotation/movement reference.

Use the `root → tag_view → tag_ads → tag_weapon` first-person chain. `tag_camera` and `tag_ads` are siblings. Node responsibilities in [Model Rules](./models.md) apply here without creating a Blender Armature.

Use named groups or supported locators as anchors, on the intended moving branch rather than the camera branch.

**Checkpoint:** Rotating a group moves only its branch and keeps its pivot in the intended location.

## 4. UVs and textures

Assign cube UVs and create/import a PNG base color. Box and per-face UV are supported. Omitted per-face entries are not rendered.

Use a directional test texture to check orientation. Bind additional textures through [shared material configuration](./firearms.md); do not use per-face `material_instance`.

**Checkpoint:** Texture directions match and no faces are unintentionally missing.

## 5. Numeric animation

Create named clips in the animation workspace and key group position, rotation, and scale.

Start with idle and one simple action before adding draw/fire/reload. Set the intended duration and loop behavior:

- Author position/rotation relative to the initial pose.
- Use numeric constants or keyframes, not Molang expressions.
- Linear, Catmull-Rom, and numeric pre/post values are supported.
- GWO configuration controls event frames, reload commits, and audio, not Bedrock entity sound/particle events.

**Checkpoint:** Each action plays correctly, with static poses, loops, and one-shot actions distinguished.

## 6. Export and verify

Export:

```text
example.geo.json
example.animation.json
example.png
```

The `.bbmodel` is an editable project, not the loaded asset. Geometry and animation must use matching group names. Keep full animation names from the JSON.

Reopen the exported geometry and animation to verify hierarchy, pivots, UVs, and clips. Check that transform values are numeric.

**Checkpoint:** Exports reproduce the model and animation. Continue to [Getting Started](./getting-started.md), [format configuration](./bedrock-empty.md), and [shared configuration](./first-firearm.md).

GLB filenames in the shared tutorial are examples. Substitute your `.geo.json` and `.animation.json` paths; no GLB conversion is required.
