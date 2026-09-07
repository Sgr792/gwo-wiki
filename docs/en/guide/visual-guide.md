---
title: Visual Guide
category:
  - Beginner Course
---

# Visual Guide

These diagrams appear beside the relevant tutorial steps. They are teaching schematics, not Blender / Blockbench screenshots or game renders. Follow the route-specific text for application controls.

Open images at full size and zoom on mobile. All steps retain text instructions; color and images are not the only source of information.

| Diagram and tutorial | What to check | Full size |
|---|---|---|
| [How the three routes meet](./choose-workflow.md) | Choose a tool without learning both applications. | [Open image](/images/guide/en/workflow.svg) |
| [First-person parent hierarchy](./models.md) | Understand the camera and ADS branches. | [Open image](/images/guide/en/hierarchy.svg) |
| [Weights, parents, and pivots](./blender-empty.md) | Identify what drives the mesh. | [Open image](/images/guide/en/rigid-pivot.svg) |
| [Default-part anchors](./attachments-optics.md) | Check anchors and part reference spaces. | [Open image](/images/guide/en/anchors.svg) |
| [Animation track ownership](./animation.md) | Remove unrelated constant tracks too. | [Open image](/images/guide/en/animation-tracks.svg) |
| [Texture-to-material mapping](./firearms.md) | Separate base color, normals, specular, and emission. | [Open image](/images/guide/en/materials.svg) |
| [Export and reimport checks](./blockbench.md) | Distinguish source projects from runtime files. | [Open image](/images/guide/en/export-check.svg) |
| [Resource IDs and real paths](./first-firearm.md) | Trace missing resources to their files. | [Open image](/images/guide/en/resource-path.svg) |

<figure class="gwo-guide-figure">
  <a href="/images/guide/en/workflow.svg" target="_blank" rel="noopener" aria-label="Open workflow diagram">
    <img src="/images/guide/en/workflow.svg" alt="Choose one authoring route" width="960" height="610" loading="lazy" decoding="async" />
  </a>
  <figcaption>Choose one route; complete the model and animation before shared configuration.</figcaption>
</figure>

## Use the diagrams as checkpoints

1. Use the route for your application: [Blender skinning](./blender-skinning.md)、[Blender Empty](./blender-empty.md) or [Blockbench](./blockbench.md)。
2. Compare hierarchy and anchors, then move each parent to check its children.
3. Use the aim-track example for ADS clips, then the ownership table for other actions. Do not apply the ADS exclusions to every animation.
4. Reimport the exported files; check nodes, poses, and timing before in-game acceptance.
