---
title: Blender · Empty Route
category:
  - Model and Animation Routes
---

# Blender: Empty rigid animation

[Choose another workflow](./choose-workflow.md)

Use this for whole-part movement, rotation, and scale, not deforming arms or cloth. It requires the new format-support development build; visual acceptance is pending.

## 1. Software and project

Create a Blender project with a receiver and one moving part. Save it separately. No Armature is required.

## 2. Model and coordinates

Keep the muzzle along `+X`. Establish units and transforms before animation. Mesh origins, Empty origins, and parenting are different things; moving origins repeatedly does not repair incorrect parenting.

**Checkpoint:** Static assembly is correct, with no unintended armature dependency or skinning modifier.

## 3. Empty hierarchy and anchors

Create Empty objects and parent meshes to them. A complete first-person reference chain is:

```text
root (Empty)
└─ tag_view (Empty)
   ├─ tag_camera (Empty)
   └─ tag_ads (Empty)
      └─ tag_weapon (Empty)
         └─ weapon_body (Empty)
            ├─ receiver (Mesh)
            └─ bolt (Empty)
               └─ bolt_mesh (Mesh)
```

The bolt Empty's origin defines its movement reference. Its mesh follows the Empty. See [Model Rules](./models.md) for other anchor roles.

Check parent-inverse transforms when parenting. Do not also bake a parent's movement into the child mesh.

**Checkpoint:** Moving the Empty moves its children; resetting it restores the assembly.

## 4. UVs and materials

Author UVs on the Mesh, not the Empty. Use the same [material configuration](./firearms.md) for base color, normal, and specular maps.

## 5. Rigid animation

Keyframe location, rotation, or scale on the moving Empty. Mesh object animation also works, but organizing mechanism motion on Empty parents is easier to maintain.

- Use unique node names.
- Start with a simple movement before draw/fire/reload.
- Include only the relevant tracks; follow the state/channel responsibilities in [Animation Rules](./animation.md).
- Bake constraints and drivers to ordinary transform keys.

**Checkpoint:** Parts remain rigid and do not move twice because of parent/child keys.

## 6. Export and verify

Include the complete Empty hierarchy and meshes in the GLB export, with animation enabled. Exporting only meshes loses their drivers.

Embed clips in the model GLB or use a separate animation library. Separate files must share node names, hierarchy, and initial transforms.

Reimport into an empty project and verify Empty nodes, clips, and mesh movement. This new route is for pure no-Skin rigid models, not expanded mixed-rig compatibility.

**Checkpoint:** Reimport reproduces the animation. Continue through [format configuration](./bedrock-empty.md), [Getting Started](./getting-started.md), and [shared configuration](./first-firearm.md).

