---
title: GWO Content Editor
icon: desktop
---

The Windows editor opens local content packs to edit configuration, preview weapons with default attachments and animated arms, validate resources, and export packs.

## Download and updates

Get the installer or portable ZIP from [official releases](https://github.com/Sgr792/gwo-editor-releases/releases/latest). Extract the portable archive and run the editor. Portable updates support signature verification and rollback. Save your edits before upgrading.

The current public release is 0.4.0. This page also documents completed source updates through 0.4.3; check the release version before downloading.

## Workflow

1. Open a content-pack folder and select a weapon, attachment, or ammunition definition.
2. Inspect the assembled weapon in the central viewport. First-person preview supports Steve and Alex arms.
3. Use the right panel for configuration, assemblies, materials, state machines, channels, pose graphs, and events. Side panels can be resized or collapsed.
4. Adjust ammunition and aiming conditions, then play actions to inspect animated parts and cartridges.
5. Save, validate, and test in Minecraft. Protected publishing requires a valid publisher token; it is not saved in pack configuration.

## Attachment anchors

Blender bones or Empty objects define mounting positions. The editor displays anchors read-only. Advanced controls can reset existing per-weapon attachment offsets; edit the authored anchor in Blender and export again to change its position.

## Transparency editing (0.4.3)

In the material tool, choose the receiver or an installed attachment and select a mesh. Preview opacity, double-sided rendering, depth writing, and depth testing. Use the save button to write settings; changing tools or restoring the preview discards unsaved transparency changes.

Settings use original GLB node names. Attachment settings can be saved as weapon-specific overrides. Preview materials retain GWO shader behavior.

## Recent changes

| Version | Changes |
| --- | --- |
| 0.3.0 | Pose reference spaces, priorities, masks, conditions, progress weights, and animation command playback. |
| 0.3.1 | Read-only anchor inspection and existing offset reset. |
| 0.4.0 | Resource navigation, larger central preview, right tool panel, resizable and collapsible panels. |
| 0.4.1 | Fixed animated first-person receivers incorrectly culled using stale bounds. |
| 0.4.2 | Added cartridge instances driven by ammunition, chamber state, and reload roles. |
| 0.4.3 | Added live mesh transparency editing while retaining authored names and shader behavior. |

## Preview limits

The editor does not embed Minecraft. Shader packs, collisions, server behavior, scope rendering, and full procedural camera behavior still require in-game testing. Ejection uses a preview proxy; custom commands may be preserved without a preview executor.
