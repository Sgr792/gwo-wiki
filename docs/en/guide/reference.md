---
title: Authoritative Examples
order: 9
category:
  - Content-Pack Authoring
---

## 33. Reference implementations

Copy the closest current example when creating content:

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

Paths are relative to the [official example content pack](https://github.com/Sgr792/gwo/tree/main/work/example-contentpack). Current examples and loader validation are authoritative when a field changes between releases.
