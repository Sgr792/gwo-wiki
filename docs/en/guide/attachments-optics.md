---
title: Attachments, Optics, and Charms
order: 5
category:
  - Content-Pack Authoring
---

## 22. Attachments

Each attachment has behavior and render definitions. The render file binds its model and maps to an `anchor_node`; the behavior file declares compatible weapons/slots and stat modifiers. Use the real animated attachment point from the receiver rig.

Nested points must follow the installed part that owns them. For example, a pistol optic attached to `tag_reflex` on an animated barrel must resolve that node through the barrel's current animated transform.

### Visibility rules

Use explicit show/hide nodes for iron sights, laser mounts, bipods, alternate magazines, and similar conditional geometry. Verify the exact bone name and intended condition. A hidden node's descendants are hidden as well, so avoid placing unrelated parts beneath it.

### Attachment-specific animation

Alternative magazines or moving guards may select replacement actions such as `reload_xmaglrg`. Their duration and event frames belong to that animation set and must not reuse incompatible default timing.

## 23. Optics

A projected reticle normally declares lens and reticle nodes, texture, scale, parallax, stabilization, response, emissive/glow strength, and ADS threshold. Keep the physical glass mesh and runtime reticle separate.

Magnified optics use the single world render plus a lens stencil/mask while retaining GWO's physical lens mesh, reticle, eye relief, and in-scope laser. Verify no weapon/iron-sight ghost silhouette leaks into the scope.

Hybrid optics declare both modes and a programmatic transition. The magnified image must appear only when the physical magnifier reaches the configured transition point; closing follows the inverse handoff. Variable magnification should expose discrete supported levels and preserve reticle shape/scale.

## 24. Charms

Charms attach to `tag_cosmetic`. A physics charm needs a stable pivot, content-defined colliders, damping, and motion limits; it must not infer arbitrary weapon collision from render bounds. Dynamic avatar charms may asynchronously fetch a player's current skin and render a runtime nameplate, while their chain continues to use authored PBR textures.
