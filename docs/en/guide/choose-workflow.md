---
title: Choose Your Workflow
category:
  - Beginner Course
---

# Choose how to build your model and animation

You do not need to learn both applications. Complete one route, then continue to shared content-pack configuration.

<div class="gwo-beginner-route">
  <a href="./blender-skinning.html"><span>01 · BLENDER</span><strong>Armature and skinning</strong><small>Detailed meshes and deforming arms, exported as GLB.</small></a>
  <a href="./blender-empty.html"><span>02 · BLENDER</span><strong>Empty rigid animation</strong><small>Move whole meshes through parent objects for mechanical parts.</small></a>
  <a href="./blockbench.html"><span>03 · BLOCKBENCH</span><strong>Bedrock entities</strong><small>Build cubes, groups, pivots, and numeric animations; export JSON.</small></a>
</div>

## Which route should I choose?

- Detailed weapons and bending fingers/arms: **Blender skinning**.
- Already using Blender and only need whole-part movement: **Blender Empty**.
- Prefer cube-style modeling and Blockbench: **Bedrock entities**.

Rigid animation moves, rotates, or scales an entire mesh without weight-based deformation. Empty animation does not replace skinned arms or guarantee better FPS.

::: warning New workflow requirements
No-Skin Empty animation and Bedrock support require the development build containing this format update. Automated tests pass; visual acceptance is pending. Earlier builds may not support them. The Blockbench route supports entity cubes and numeric keyframes, not Molang or entity controllers.
:::

## Learning order

1. Choose one route above.
2. Complete its software setup, modeling, hierarchy/anchors, UVs, animation, and export checks.
3. Read [Getting Started](./getting-started.md) to prepare the game environment.
4. [Download the Empty Template](./empty-template.md).
5. Follow [Build Your First Firearm](./first-firearm.md) for shared behavior, events, materials, and testing.
6. Complete [Debugging and Release](./debugging-release.md).

[Formats and Support Scope](./bedrock-empty.md) is a reference, not another required software route.

