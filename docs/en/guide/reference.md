---
title: Authoritative Examples
order: 9
category:
  - Content-Pack Authoring
---

## 33. Reference implementations

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

Paths are relative to the current default content pack. The public Wiki provides an asset-free empty template so the guide does not depend on a removed or version-mismatched example link. Current Wiki rules and loader validation are authoritative.

## 34. Legacy fields not to use

The following names are ignored or explicitly removed legacy syntax. Do not add them to new packs; retain current fields and explicitly authored defaults.

| Legacy field | Current form |
|---|---|
| `hud_icon_texture` | `hud.weapon_icon` |
| `camera.recoil_pitch`, `camera.recoil_yaw`, `camera.recoil_recovery`, `recoil.handRotPivot`, `recoil_animation` | Current `recoil` block |
| `arms.arm_poses` | Current `arms`, animation controller, and `pose_graph` |
| Module `default_enabled`, `built_in`, `incompatible_with` | `default_installed`, `embedded`, `conflicts_with` |
| Sight `reticle_attach_node`, `lense_hide_node` | `reticle_node`, `lens_hide_node` |
| Flat `reticle_preview.u/v/width/height` | `reticle_preview.crop.u/v/width/height` |
| Top-level `rpm`, `shot_cooldown_*`, `automatic_interval_*` | `mechanics.rpm` and `mechanics.fire_interval_ms` |
| `animation_state_rules`, `animation_interrupt_rules` | `animation_machine` |
| `melee.impact_frame`, `melee.impact_time` | Timing fields in `melee.combos.*.attacks[]` |
| `sight.hybrid` | `sight.optic` |

Do not classify explicit current defaults or valid identity animation mappings as legacy. Remove only obsolete names or formats that the loader explicitly rejects.
