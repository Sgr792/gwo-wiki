---
title: Authoritative Examples
order: 9
category:
  - Content-Pack Authoring
---

## Reference implementations

Start from the [empty template](empty-template.md). The table names typical files in the current default content pack. If you have a matching version of that pack, use it for comparison, but do not copy its namespace and IDs unchanged.

| Type | Behavior file | Render file |
|---|---|---|
| Assault rifle / detachable-mag long gun | `weapons/firearms/m4.json` | `weapons/firearms/render/m4.render.json` |
| Pistol | `weapons/firearms/staccato_2011_p.json` | `weapons/firearms/render/staccato_2011_p.render.json` |
| Tube-fed shotgun | `weapons/firearms/m590a1.json` | `weapons/firearms/render/m590a1.render.json` |
| Bolt-action rifle | `weapons/firearms/cheytac_m200.json` | `weapons/firearms/render/cheytac_m200.render.json` |
| Standalone melee | `weapons/melee/karambit.json` | `weapons/melee/render/karambit.render.json` |
| Magnified optic | `attachments/sights/sz_bullseye_optic.json` | `attachments/render/sights/sz_bullseye_optic.render.json` |
| Laser | `attachments/lasers/1mw_laser_box.json` | `attachments/render/lasers/1mw_laser_box.render.json` |
| Large box magazine (`xmaglrg`) | `attachments/magazines/m4_xmaglrg.json` | `attachments/render/magazines/m4_xmaglrg.render.json` |
| Drum magazine (`drummag`, model/module definition) | `attachments/magazines/rm277_drummag.json` | `attachments/render/magazines/rm277_drummag.render.json` |
| Ammunition | `bullets/5_56x45.json` | Same file contains model/material declarations |

Paths are relative to the current default content pack. The public Wiki provides an asset-free empty template; use the parameter reference and loader validation to check fields and structure.

## Configuration and field reference

For independent teaching configurations without default-pack assets, see [Configuration Examples](./config-examples.md). Existing valid fields and explicit defaults should be preserved when merging examples.

For field purpose, units, defaults and adjustment effects, see the [parameter reference](parameters.md). For animation control/blending, see [Lua animation machines](lua-animation.md).
