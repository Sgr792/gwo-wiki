---
title: GLB and Empty Animation
category:
  - Models and animation
---

# GLB and Empty Animation

Gun content packs use GLB/glTF models and GLB animation libraries, supporting both skinned bones and Blender Empty rigid animation.

The built-in target and workbench use separate internal readers; their JSON assets are not a gun-pack format.

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
6. Use a no-Skin hierarchy for rigid animation and the skeletal skinning workflow for deforming meshes.

## In-game acceptance

Before publishing, check idle/draw/fire/reload/inspect, child meshes and moving locators, texture orientation, transparent nodes, normal rendering and Iris, and existing skinned GLB weapons.
