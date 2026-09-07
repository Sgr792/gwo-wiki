---
title: Blender · Empty Route
category:
  - Model and Animation Routes
---

# Blender: Empty rigid animation

[Choose another workflow](./choose-workflow.md)

For rigid cube-style arms, download the [arm source templates](./arm-templates.md) and read the runtime limitations first.

Use this for whole-part movement, rotation, and scale, not weight-deformed arms or cloth. Whole cube-style arm parts can be rigid authoring objects. It requires the new format-support development build; visual acceptance is pending.

## Software and project

Create a Blender project with a receiver and one moving part. Save it separately. No Armature is required.

## Model and coordinates

Keep the muzzle along `+X`. Establish units and transforms before animation. Mesh origins, Empty origins, and parenting are different things; moving origins repeatedly does not repair incorrect parenting.

**Checkpoint:** Static assembly is correct, with no unintended armature dependency or skinning modifier.

## Empty hierarchy and anchors

<figure class="gwo-guide-figure">
  <a href="/images/guide/en/hierarchy.svg" target="_blank" rel="noopener" aria-label="Open full-size diagram: First-person hierarchy: parent to child">
    <img src="/images/guide/en/hierarchy.svg" alt="First-person hierarchy: parent to child" width="960" height="630" loading="lazy" decoding="async" />
  </a>
  <figcaption>Check the hierarchy: the camera and ADS nodes are siblings. Schematic; open the image for full size.</figcaption>
</figure>

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

## UVs and materials

Author UVs on the Mesh, not the Empty. Use the same [material configuration](./firearms.md) for base color, normal, and specular maps.

## Rigid animation

<figure class="gwo-guide-figure">
  <a href="/images/guide/en/rigid-pivot.svg" target="_blank" rel="noopener" aria-label="Open full-size diagram: What moves the mesh? Where is the pivot?">
    <img src="/images/guide/en/rigid-pivot.svg" alt="What moves the mesh? Where is the pivot?" width="960" height="600" loading="lazy" decoding="async" />
  </a>
  <figcaption>Test the pivot by rotating the parent Empty; do not bake the same motion twice. Schematic; open the image for full size.</figcaption>
</figure>

Keyframe location, rotation, or scale on the moving Empty. Mesh object animation also works, but organizing mechanism motion on Empty parents is easier to maintain.

- Use unique node names.
- Start with a simple movement before draw/fire/reload.
- Include only the relevant tracks; follow the state/channel responsibilities in [Animation Rules](./animation.md).
- Bake constraints and drivers to ordinary transform keys.

**Checkpoint:** Parts remain rigid and do not move twice because of parent/child keys.

## Export and verify

<figure class="gwo-guide-figure">
  <a href="/images/guide/en/export-check.svg" target="_blank" rel="noopener" aria-label="Open full-size diagram: Export succeeded does not mean export is correct">
    <img src="/images/guide/en/export-check.svg" alt="Export succeeded does not mean export is correct" width="960" height="640" loading="lazy" decoding="async" />
  </a>
  <figcaption>Reimport and inspect; a successful export does not guarantee correct hierarchy or animation. Schematic; open the image for full size.</figcaption>
</figure>

Include the complete Empty hierarchy and meshes in the GLB export, with animation enabled. Exporting only meshes loses their drivers.

Embed clips in the model GLB or use a separate animation library. Separate files must share node names, hierarchy, and initial transforms.

Reimport into an empty project and verify Empty nodes, clips, and mesh movement. This new route is for pure no-Skin rigid models, not expanded mixed-rig compatibility.

**Checkpoint:** Reimport reproduces the animation. Continue through [format configuration](./bedrock-empty.md), [Getting Started](./getting-started.md), and [shared configuration](./first-firearm.md).

Implementation baseline: `b6d52ab` (2026-09-05); see [version and acceptance status](./bedrock-empty.md). This marker does not imply the feature is present in every build labeled 2.12.87.
