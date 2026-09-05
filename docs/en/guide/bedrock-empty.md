---
title: Formats and Support Scope
category:
  - Content-Pack Authoring
---

::: warning Build and validation status
Requires a development build containing this format-support update. Earlier releases do not necessarily support it. Automated tests pass; in-game visual acceptance is still pending.
:::

## Choose a model workflow

This page is a format/configuration reference. For authoring steps, [choose a workflow](./choose-workflow.md) and follow its separate Blender or Blockbench route.

GWO now routes three workflows through its existing configuration, animation states, and rendering infrastructure:

- Existing GLB Armature/Skin models.
- Rigid GLB models animated through Blender Empty parents and child meshes.
- Blockbench Bedrock entity cube geometry and numeric animation JSON.

No offline compilation or conversion tool is required. The fragments below belong inside an existing GWO weapon definition; they are not complete definitions.

## Bedrock files and configuration

Place files in your own namespace:

```text
assets/example/models/example.geo.json
assets/example/animations/example.animation.json
assets/example/textures/example.png
```

```jsonc
{
  "gltf_model": "example:models/example.geo.json",
  "texture": "example:textures/example.png",
  "animation_sources": ["example:animations/example.animation.json"],
  "animation_clips": {
    "static_idle": "animation.example.idle",
    "draw": "animation.example.draw",
    "fire": "animation.example.fire"
  }
}
```

The existing `gltf_model` field also accepts `.geo.json`. Include the file extension. Values in `animation_clips` must match the full names in the animation JSON; GWO does not strip the `animation.` prefix.

Normal maps, emission, specular materials, transparent nodes, and attachment anchors still use GWO configuration. Configure firing, ammunition commits, and sound events in GWO; Bedrock entity events are not imported.

### Implemented scope

- One `minecraft:geometry` entry containing entity cubes, bone hierarchy, pivots, and bind rotations.
- Cube origin, size, pivot, rotation, and inflate. Cubes on the same bone share a mesh.
- Box UV, per-face UV, negative `uv_size`, and mirror. Omitted per-face UV entries are not drawn.
- Named locators with offset and rotation for anchors.
- Numeric position, rotation, and scale constants/keyframes; linear and Catmull-Rom interpolation; pre/post values.
- Looping, non-looping, `hold_on_last_frame`, and zero-duration static poses.
- Positions use 16 model units per render unit. Rotations use degrees and animation is resolved relative to the model's initial pose.

This is not a Bedrock entity engine. Molang, entity animation controllers, and entity particle/sound events do not run. `poly_mesh`, per-face `material_instance`, `relative_to`, `ignore_inherited_scale`, and runtime animation-time expressions are not supported. Unsupported transform fields produce errors rather than silently displaying a different pose. Bake expressions into numeric keyframes before export.

Keep exactly one geometry entry per file.

## Blender Empty rigid animation

A simple rigid hierarchy can look like this:

```text
root (Empty)
└─ tag_weapon (Empty)
   ├─ receiver (Mesh)
   └─ bolt (Empty)
      └─ bolt_mesh (Mesh)
```

This illustrates parenting only, not a complete first-person rig. Follow the `root → tag_view → tag_ads → tag_weapon` chain from [Model Rules](./models.md) for a complete weapon.

Animate location, rotation, or scale on Empty or Mesh objects. Children inherit the transforms; no Armature, vertex groups, or weights are needed. Rigid meshes do not deform. Keep using skinned bones for deforming arms or cloth.

```jsonc
{
  "gltf_model": "example:models/example.glb",
  "texture": "example:textures/example.png",
  "animation_sources": ["example:animations/example.anim.glb"]
}
```

Animations may also be embedded in the model GLB, in which case no separate `animation_sources` entry is needed.

### Export checklist

1. Include the complete Empty hierarchy, not just the meshes.
2. Enable animation export and verify that all required Action/NLA clips are present.
3. Separate model and animation GLBs must share node names, hierarchy, and initial transforms.
4. Use unique animated node names. Do not bake the same parent transform into a mesh twice.
5. Bake constraints, drivers, and authoring-tool effects into transform keyframes.
6. This update adds the pure rigid, no-Skin path; it does not expand existing multi-Armature or mixed-rig export compatibility.

## In-game acceptance

Automated tests cover a real no-Skin GLB import, Empty tracks, parent transforms, Bedrock cubes/locators, UVs, and animation sampling. Passing tests and a build does not establish visual acceptance.

Before publishing, check idle/draw/fire/reload/inspect, child meshes and moving locators, texture orientation, transparent nodes, normal rendering and Iris, and existing skinned GLB weapons.

Fields follow the [official Mojang geometry schemas](https://mojang.github.io/bedrock-samples/Schemas.html). The list above describes GWO's implemented subset, not the entire Bedrock format.
