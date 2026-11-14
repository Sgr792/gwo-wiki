---
title: Animation Flicker, Snaps, and Incorrect Hiding
category:
  - Content-Pack Authoring
---

A flash during inspection, attacks, or sprinting can come from interpolation, action handoff, parent/child scale, visibility rules, or materials. Identify the affected mesh and clip time before changing protection settings.

## Identify the cause

| Symptom | Check | Correction |
|---|---|---|
| Geometry explodes only between keys | Local and global parent/child scales at intermediate times | Repair the source binding/bake and export again |
| Normally sized geometry loses faces at a particular location | Skinned model-space coordinates against `hide_position_distance` | Calibrate the range for that model |
| Translation jumps to a later key early | Per-node T/R/S timestamp arrays and actual loader sampling | Align timestamp arrays in an export copy |
| An action snaps to another pose at its end | Endpoints, idle reference, additive encoding, layer handoff | Fix the boundary or pose configuration |
| A mesh disappears only with a shader pack | Transparency, depth, materials, and render route | Investigate that render path rather than assuming animation distance |

## Model-space visibility range

Place `animation_visibility` in the weapon **render JSON**. It is not one of the seven animation groups owned by Lua `config`. Merge this example into the existing object without removing bone rules:

```jsonc
"animation_visibility": {
  "hide_position_distance": 32
}
```

| Field | Loader default | Meaning |
|---|---:|---|
| `enabled` | `true` | Enables the associated animation visibility rules |
| `hide_position_distance` | `16` | CPU triangle filtering: discard a triangle when any skinned vertex exceeds this absolute model-space coordinate on any axis; not player distance or a spherical radius |
| `max_triangle_edge` | `2.5` | Minimum edge-length gate for abnormal stretching |
| `max_edge_stretch` | `8` | Stretch comparison against the original edge; not overall model size |
| `hide_bone_move_distance` | `12` | Used by bone hiding rules, separate from the vertex-distance test |
| `first_person_only_bones` | `[]` | Bones visible only in first person, such as inspection props |

Setting the distance to `0` disables only this distance filter. It is not a general fix. Keep independent stretch protection, and do not hide source animation defects with `enabled: false`. CPU checks do not establish that every GPU or shader path uses the same filter.

## Calibrate from actual animation

1. Load the final GLB with the released JAR. Include inspection props, attacks, sprinting, and every draw variant.
2. Sample between keys and at action boundaries, including blends with idle. Decode additive `idle_active` against its correct reference.
3. Measure `M = max(abs(x), abs(y), abs(z))` after skinning. Per-bone bounds can provide a conservative upper bound; also verify the previously failing triangle samples.
4. Leave measured headroom. Recalibrate after replacing the model rather than copying one value to every weapon.

The 2026-11-14 Delta Force melee adjustment used `ceil((M × 1.25 + 4) / 4) × 4` as a tuning rule, **not a loader default**. Chainsaw uses 48, both Dark Star forms 40, Reborn 36, ShadowKiller 28, and the other entries addressed in that pass 32. Greedy already had a separate fix; H5Z01 blade trails use special rules and must be evaluated separately.

## Parent scale and TRS timestamps

A parent scale of `0.0001` combined with a child scale near `10000` may cancel at keys but produce enormous geometry during independent interpolation. Check Segment Scale Compensate, Blender scale inheritance, and constraint baking. Reconstruct child tracks from the source only after confirming how the prop is meant to hide; do not reset every child's scale to one.

For the current export workflow, use the union of each node's translation, rotation, and scale timestamps. Resample T/S linearly and quaternion R with SLERP; densify curves first when needed to preserve source motion. Apply this to an export copy and retain the source curves. Compare intermediate samples through the actual game loader: a successful Blender reimport alone is insufficient.

## Verification limits

The configuration regression covered 18 weapon entries, 272 clips, and 1,088 peak/half-weight blend poses. All 119 previously positive hiding samples were cleared. These are loader and CPU geometry results, not GPU, shader, hand-contact, or sound acceptance.

Restart Minecraft and test with shaders on and off, in first person, third person, and display contexts. Record any remaining clip/time-specific defect. See [animation authoring](animation.md) and [debugging and release](debugging-release.md).
