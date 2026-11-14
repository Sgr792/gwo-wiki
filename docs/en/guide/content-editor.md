---
title: GWO Content Editor
icon: desktop
---

The Windows editor opens local content packs to edit configuration, preview weapons with default attachments and animated arms, validate resources, and export packs.

## Download and updates

Get the installer or portable ZIP from [official releases](https://github.com/Sgr792/gwo-editor-releases/releases/latest). Extract the portable archive and run the editor. Portable updates support signature verification and rollback. Save your edits before upgrading.

Check the Release page and the installed editor’s documentation for its available features.

## Workflow

1. Open a content-pack folder and select a weapon, attachment, or ammunition definition.
2. Inspect the assembled weapon in the central viewport. First-person preview supports Steve and Alex arms.
3. Use the right panel for configuration, assemblies, materials, state machines, channels, pose graphs, and events. Side panels can be resized or collapsed.
4. Adjust ammunition and aiming conditions, then play actions to inspect animated parts and cartridges.
5. Save, validate, and test in Minecraft. Protected publishing requires a valid publisher token; it is not saved in pack configuration.

## Attachment anchors

Blender bones or Empty objects define mounting positions. The editor displays anchors read-only. Advanced controls can reset existing per-weapon attachment offsets; edit the authored anchor in Blender and export again to change its position.

## Transparency editing

In the material tool, choose the receiver or an installed attachment and select a mesh. Preview opacity, double-sided rendering, depth writing, and depth testing. Use the save button to write settings; changing tools or restoring the preview discards unsaved transparency changes.

Settings use original GLB node names. Attachment settings can be saved as weapon-specific overrides. Preview materials retain GWO shader behavior.

## Preview limits

The editor does not embed Minecraft. Shader packs, collisions, server behavior, scope rendering, and full procedural camera behavior still require in-game testing. Ejection uses a preview proxy; custom commands may be preserved without a preview executor.
