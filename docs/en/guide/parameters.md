---
title: Content-pack parameter reference
category:
  - Content-Pack Authoring
---

This reference explains common and animation-related fields by file location. Defaults come from the **development loader supporting Lua animation API 1**, not the tuned default pack. Required fields must be supplied; “—” means no universal value or an optional reference. For specialized fields, follow the linked guide rather than inventing names.

Gameplay JSON controls damage, cadence, ammo and server decisions; render JSON controls resources, materials and presentation. With [Lua animation machines](lua-animation.md), seven animation groups move into Lua `config` without changing their data meanings. `animation_fps`, mechanical commits and resource references remain JSON.

**Keep time units separate:** `_ms` means milliseconds, `_ticks` means game ticks, `_frame` uses `animation_fps`, and `fade_in/out` use seconds. Response/damping coefficients are not durations. At normal 20 TPS one tick is 50ms; `frames / FPS × 1000` gives milliseconds.

## Weapon gameplay JSON

| Field | Type/unit | Default/limit | Purpose and adjustment effect |
|---|---|---|---|
| `id` | ID | 必填 / required | Unique content ID using your namespace. |
| `display_name` | string | 必填 / required | Display name; language files can provide translations. |
| `render` | path | — | Render JSON path relative to the pack root, not an assets resource ID. |
| `creative_category` | enum | assault_rifle / melee | Creative/refit category; allowed values are listed in the firearm guide. |
| `creative_sort / creative_hidden` | integer / bool | 0 / false | Sort order (lower first) / hide from the creative list. |
| `model_data` | integer | 0 | Item-model selector; avoid conflicts with other weapons. |
| `magazine_size` | rounds | 30; 1..1000 | Base ammunition capacity; per-round tube plus chamber capacities must equal this value. |
| `damage` | damage points | 8; 0.1..1000 | Base damage; two Minecraft damage points equal one heart, before ammo/distance/body modifiers. |
| `projectiles_per_shot` | integer | 1; 1..64 | Projectiles per successful shot, e.g. pellets; not ammunition consumed per shot. |
| `range` | blocks | 96; 1..512 | Base range parameter, further modified by ammunition, lifetime and ballistics. |
| `fire_modes` | array | 枪械必填 / required for firearms | semi, auto, burst or charge; controls trigger and firing scheduling. |
| `burst_count / burst_interval_ticks` | rounds / ticks | 3 / 2 | Burst shot count. burst_interval_ticks is parsed but not read by the current scheduler; within-burst cadence uses mechanics.fire_interval_ms. |
| `charge_min_ticks / charge_max_ticks` | ticks | 8 / 30 | Minimum charge / time to maximum charge, for charge mode. |
| `charge_damage_bonus` | damage points | 15 | Charge damage bonus parameter; does not change ordinary animation length. |
| `ammo.default` | ID | — | Default ammunition; automatically included in the exact accepted list. |
| `ammo.accepted / ammo.accepted_families` | ID arrays | [] | Accept specific ammo IDs / entire cartridge families; family is not a display name. |
| `mechanics.rpm` | rounds/min | 850; 1..3000 | Integer RPM metadata matching fire_interval_ms. |
| `mechanics.fire_interval_ms` | ms | round(60000/rpm); 1..5000 | Actual firing interval; rejected if it differs from rounded RPM conversion by over 1ms. Desert Eagle: 167/360; Staccato: 462/130. |
| `mechanics.action_commit_ms.<动作/action>` | ms | 0..60000 | Mechanical commit time for ordinary finite actions, such as updating ammo during reload; distinct from sound and animation duration. |
| `inaccuracy.stand / move / sneak / lie / aim` | spread coefficient | 5 / 5.75 / 3.5 / 2.5 / .15 | Standing/moving/crouching/prone/fully aimed spread. Larger is wider; not degrees or recoil. One stance is selected per shot. |
| `ballistics.muzzle_velocity` | blocks/s | 500; 1..4000 | Muzzle speed; higher values shorten travel time. |
| `ballistics.gravity` | blocks/s² | 9.8; 0..200 | Projectile downward acceleration; zero disables this gravity. |
| `ballistics.drag / water_drag` | coefficients | .015 / .60 | Air/water drag; larger values increase speed loss. |
| `ballistics.life_seconds` | s | 2.5; .05..60 | Maximum projectile lifetime, not animation time. |
| `ballistics.hitbox_inflation` | blocks | .12; 0..1 | Inflates entity bounds during hit detection. |
| `ballistics.headshot_multiplier / headshot_height_fraction` | multiplier / fraction | 1.5 / .25 | Headshot multiplier / head-region height fraction; these serve different purposes. |
| `ballistics.body_damage.chest / abdomen / arms / legs` | multipliers | 1 / .9 / .75 / .7 | Chest, abdomen, arm and leg damage multipliers. |
| `ballistics.damage_curve[]` | objects | [{distance:0,multiplier:1}] | Distance damage curve: strictly increasing distance and damage multiplier; optional location_multipliers define body-specific curves. |
| `ballistics.penetration.max_entity_hits` | integer | 1; 1..16 | Maximum entities hit by one projectile; one stops after the first entity. Not a block penetration switch. |
| `ballistics.penetration.speed_retention / damage_retention` | fractions | .72 / .70 | Speed/damage fraction retained after each entity penetration. |

## Ammo JSON: bullets/*.json

| Field | Type/unit | Default/limit | Purpose and adjustment effect |
|---|---|---|---|
| `family` | ID | 自身 ID / ammo ID | Cartridge family used by accepted_families. |
| `icon_model_data / max_stack_size / rounds_per_item` | integers | 0 / 64 / 1 | Item-model selector / stack limit / rounds represented by one item. |
| `damage_multiplier / velocity_multiplier / range_multiplier / inaccuracy_multiplier` | multipliers | 1 | Modify weapon damage, speed, range and spread respectively; smaller spread multiplier is more accurate. |
| `armor_penetration` | fraction | 0; 0..1 | Armor penetration parameter, distinct from entity hit count. |
| `ballistics.gravity_multiplier / drag_multiplier / water_drag_multiplier` | multipliers | 1 | Ammo multipliers applied to weapon ballistic parameters. |
| `ballistics.headshot_multiplier` | multiplier | 1 | Additional ammunition headshot multiplier. |
| `ballistics.max_entity_hits` | integer | 0; 0..16 | Zero inherits the gun value; positive values replace the entity hit count. |
| `ballistics.speed_retention_multiplier / damage_retention_multiplier` | multipliers | 1 | Further modify penetration speed/damage retention. |
| `tracer.count_interval` | integer | 0; -1..127 | Minus one disables ammo tracers, zero requests every shot, positive values show one in every (count_interval+1) shots; weapon tracer enable still applies. |
| `tracer.color` | color | #FFFFEBA0 | Accepts #RRGGBB or #AARRGGBB. |
| `tracer.size_multiplier / length_multiplier` | multipliers | 1 / 1 | Tracer thickness/length; does not change hits or projectile speed. |
| `models.cartridge / casing / projectile` | model objects | 可选 / optional | Unspent cartridge / spent casing / flying projectile; each holds model, material and scale. |
| `inspection_module` | string | 空 / empty | Module identifier associated with inspection resources; not an installable casing attachment. |

## Resources, material and display transforms (render JSON)

| Field | Type/unit | Default/limit | Purpose and adjustment effect |
|---|---|---|---|
| `gltf_model / animation_sources` | ID / ID array | — / [] | Receiver model / animation libraries; example:foo resolves to assets/example/foo. |
| `texture / normal / specular / roughness / metallic / emissive` | resource IDs | 可选 / optional | Base color, normal, specular, roughness, metallic and emission textures; Iris channel interpretation also depends on the shader pack. |
| `specular_strength / roughness_value / metallic_value / emissive_strength` | numbers | 枪/gun: .35 / .55 / 0 / 0 | Material strength or fallback scalar; lower roughness is smoother. Ammo defaults are .35/.45/.8/0 and differ from guns. |
| `icon_texture / hud.weapon_icon` | IDs | — | Item icon / weapon HUD icon. |
| `coordinate_system / model_forward_axis` | enums | blender_gun / x | Resource coordinate convention / forward axis; blender_gun requires +X, blender requires a horizontal axis. |
| `gltf_scale / gltf_translation / gltf_rotation` | number / XYZ / XYZ | 1 / [0,0,0] / [0,0,0] | Global model conversion and transform; rotation uses degrees. Fix model units with gltf_scale. |
| `first_person / ground / fixed / modify_screen / sprinting` | transform objects | 按场景 / scene-specific | Base transforms for first person, dropped items, frames, refit UI and procedural sprint. |
| `TRANSFORM.translation / rotation / scale` | XYZ / degrees / multiplier | 通常/usually 0 / 0 / 1 | Move/rotate/scale in the scene reference space; XYZ accepts an array or x/y/z object. |
| `TRANSFORM.anchor_node / camera_node / use_camera_transform` | names / bool | 按场景 / scene-specific | Anchor/camera nodes and whether to use the camera transform; names must exist in the model. |
| `modify_screen.camera / modify_screen.ammo` | objects | 见专页 / see guide | Refit camera presets and cartridge preview offsets; see the configuration examples page. |
| `first_person_arms / arms.enabled / arms.model` | bool / bool / ID | false / true / — | Independent first-person arm use / arm enable / arm model resource. |
| `arms.left_holder_bone / right_holder_bone` | bone names | LEFT_ARM / RIGHT_ARM | Left/right arm holder reference bones. |
| `arms.poses.<状态/state>` | object | — | Per-state holders, action-follow bones and blend_ticks; blend_ticks uses ticks, not seconds. |
| `camera.enabled / model_fov` | bool / degrees | true / 70 | Camera settings enable / first-person model field of view. |
| `camera.aim_fov_multiplier / aim_sensitivity_multiplier / aim_transition_speed` | multipliers / response | 1 / .72 / 2 | Aimed FOV, mouse sensitivity and transition response; response is not a fixed duration. |
| `camera.camera_position_scale / camera_position_max` | numbers | 0 / 16 | Animation-camera translation scale / bound; zero scale removes that translation contribution. |
| `offhand_stowed.enabled / translation / rotation / model_roll / scale` | bool / XYZ / degrees / degrees / multiplier | true / [0,.38,.16] / [0,0,50] / 0 / 1 | Offhand stowed visibility and pose; model_roll separately controls model roll. |
| `offhand_stowed.max_render_distance / cast_shadow` | blocks / bool | 48 / true | Stowed render distance / shadow casting. |
| `third_person_pose.enabled / raise_speed / lower_speed / shoot_hold_ticks / sprint_lower_weight` | bool / responses / ticks / fraction | false / .22 / .16 / 60 / 1 | Third-person raising/lowering, post-shot hold and sprint-lowering weight. |
| `third_person_pose.right_arm / left_arm / gun` | objects | — | Arm lowered/raised rotations and gun lowered/raised display transforms. |
| `aim_reference.enabled / align_node / focus_node` | bool / node names | true / tag_align_gun / tag_weapon_focus | Aim-reference nodes; affects alignment, not damage. |
| `canted_aim.enabled / pose_node / pivot_node / translation / rotation` | bool / names / XYZ / degrees | false / tag_ads / tag_ads / [0,0,0] / [-42,0,0] | Canted aim enable, reference/pivot and offsets. |
| `canted_aim.response / damping / fov_multiplier` | numbers | 18 / 1 / 1 | Canted aim spring response, damping and FOV multiplier. |

## Recoil and mouse sway

| Field | Type/unit | Default/limit | Purpose and adjustment effect |
|---|---|---|---|
| `recoil.enabled / auto_recovery` | bools | true / true | Procedural recoil / automatic recovery; independent of GLB firing animation. |
| `recoil.blend_start / blend_end / blend_curve` | fractions / enum | .15 / .95 / smoothstep | Hip-to-ADS profile blending interval/curve; end must exceed start, linear is also supported. |
| `recoil.recovery_delay_ms / recovery_duration_ms` | ms | 按射速推导 / 0 | Recovery delay after firing / optional duration; zero duration uses spring recovery. |
| `recoil.hip / recoil.ads` | objects | 各自基础配置 / distinct base profiles | Hip and aimed profiles; the following fields apply to both. |
| `<recoil profile>.vertical / horizontal / model_back / randomness` | multipliers | 1 | Vertical recoil / horizontal randomness / model backward motion / randomness multipliers, not direct distance or angle. |
| `<recoil profile>.recovery` | multiplier | 1; .1..4 | Recovery strength; changes spring stiffness, damping and camera response together. |
| `<recoil profile>.model_pitch_degrees / sustained_vertical_fraction` | degrees / fraction | 0 / .35 | Additional model pitch / sustained vertical contribution fraction. |
| `weapon_sway.enabled / hip / ads` | bool / objects | true | Mouse-driven weapon sway enable and hip/ADS profiles. |
| `<sway profile>.input_gain / deadzone / max_angle` | gain / degrees / degrees | hip:9/.18/5.5; ads:4/.06/1.2 | Input gain / dead zone / maximum angle; maximum must be at least the dead zone. |
| `<sway profile>.stiffness / damping / edge_damping` | spring coefficients | hip:64/15/8; ads:80/18/10 | Centering stiffness / damping / extra edge damping; higher does not always mean smoother. |
| `<sway profile>.location_gain / roll_gain` | multipliers | hip:.09/.45; ads:.06/.35 | Translation and roll response accompanying sway. |

## Attachments and ammunition slots

| Field | Type/unit | Default/limit | Purpose and adjustment effect |
|---|---|---|---|
| `modules` | map | {} | Available weapon attachments; values may reference attachment JSON whose render is merged by the loader. |
| `type / slot / anchor_node` | strings | 按类型 / type-dependent | Attachment type, occupied slot and mounting node; mounting is distinct from laser/muzzle emission. |
| `default_installed / embedded / exclusive_slot` | bools | true / false / true | Installed initially / embedded part / exclusive slot; explicitly use false for optional attachments. |
| `depends_on / conflicts_with / parent_slots / parent_types` | arrays | [] | Dependencies, conflicts and allowed parent slots/types; not file paths. |
| `properties.set / add / multiply` | numeric maps | {} | Replace/add/multiply recognized numeric properties such as capacity; does not create arbitrary gameplay logic. |
| `states.translation / rotation / scale` | XYZ / degrees / multiplier | [0,0,0] / [0,0,0] / 1 | Attachment local transform after mounting. |
| `event_actions` | command map | {} | Attachment presentation commands; frames use weapon animation_fps. |
| `ammo_slots` | object | 见实际骨架 / match rig | Classifies magazine, chamber and replacement-magazine rounds; keep their roots and masks separate. |
| `ammo_slots.fill_order` | enum | 按骨架 / rig-dependent | Ascending/descending slot fill order; Desert Eagle uses ascending, but other rigs may differ. |
| `ammo_slots.chamber_nodes / magazine_in_gun_nodes / expected_slots` | names / integer | 按骨架 / rig-dependent | Chamber nodes, magazine-in-gun node classification and expected slot count; verify actual names. |
| `gun_bone_visibility.when_slot_empty / when_slot_occupied` | rule maps | {} | Show/hide bones for empty/occupied attachment slots, e.g. hide iron sights after fitting an optic. |
| `transparent_nodes.<节点/node>.alpha / depth_write / depth_test / double_sided` | number / bools | .3 / false / true / true | Opacity, depth writing/testing and double-sided rendering for the specified separate node. |
| `transparent_nodes.<节点/node>.texture / emissive / emissive_strength` | IDs / number | — / — / 1 | Separate material and emission strength for a transparent node. |

## Effects, sound and melee

| Field | Type/unit | Default/limit | Purpose and adjustment effect |
|---|---|---|---|
| `sound_events.fire / fire_ads / fire_auto / fire_auto_ads / fire_last / fire_last_ads / fire_interrupt / dry_fire / dry_fire_ads` | sound IDs | — | Sound-event IDs for firing cases; reference sounds.json events rather than OGG file paths. |
| `sound_events.remote_overrides` | ID map | {} | Maps local sound events to remote-player alternatives. |
| `bullet_tracer.enabled / size_multiplier / length_multiplier / color` | bool / numbers / color | true / 1 / 1 / — | Weapon tracer enable/appearance; ammunition has its own tracer settings. |
| `shell_effect.enabled / eject_on_fire / anchor_bone` | bools / bone | true / true / — | Casing enable, automatic ejection on fire and ejection bone; bolt/pump ejection must match mechanical timing. |
| `shell_effect.life_seconds / gravity / velocity` | s / acceleration / XYZ | .5 / 18 / [6,0,0] | Casing lifetime, gravity and velocity settings, separate from projectile ballistics. |
| `shell_effect.front / up / up_random_deg / front_random_deg` | degrees | 15 / 25 / 20 / 5 | Base ejection direction angles and random deviations. |
| `shell_effect.shell_velocity / velocity_random` | speed / fraction | 6 / .2 | Casing speed and random variation. |
| `shell_effect.rotate_pitch_random_offset / rotate_yaw_random_offset` | degrees | 10 / 90 | Initial pitch/yaw randomness. |
| `shell_effect.rotate_pitch_speed / rotate_yaw_speed` | degrees/s | 360 / 3600 | Casing rotation speed. |
| `shell_effect.rotate_pitch_speed_random / rotate_yaw_speed_random` | fractions | .8 / .25 | Random variation of rotation speed. |
| `link_effect.source_bone / anchor_bone / direction_anchor_bone / translation` | bones / XYZ | — | Belt-link source, ejection/direction anchors and offset; other motion fields follow shell_effect; a renderable source model is required. |
| `muzzle_flash.enabled / muzzle_smoke.enabled` | bools | true / true | Independent flame/smoke switches. |
| `muzzle_flash.scale / flame_scale / flame_alpha / flame_particles / flame_speed` | numbers | 2 / 1 / .9 / 4 / .075 | Overall/flame scale, opacity, particle count and speed; more particles increase rendering work. |
| `muzzle_flash.flame_front_texture / flame_side_texture / flame_columns / flame_rows / flame_frames / flame_fps / flame_duration_ms` | IDs / integers / FPS / ms | — / — / 4 / 2 / 8 / 160 / 50 | Front/side flame atlases, grid, frames, speed and lifetime; frame count should fit the atlas. |
| `muzzle_flash.layers[]` | objects | [] | Custom flame layers: name/type/texture, atlas grid/frames/fps, start/duration in ms, width/length/offset, planes, random_roll/frame_blend/random_frame, chance/alpha/lod_tier/color control identity, sequence, timing, geometry, randomness and LOD. |
| `muzzle_flash.light.intensity / radius / duration_ms` | number / blocks / ms | 2.5 / 4.5 / 100 | Muzzle light intensity, radius and duration. |
| `muzzle_flash.lod.full_distance / medium_distance / max_distance` | blocks | 12 / 32 / 64 | Distance detail thresholds and maximum render distance; values must be nondecreasing. |
| `muzzle_smoke.smoke_particles / smoke_speed / spread / smoke_scale / smoke_alpha` | numbers | 3 / .028 / .018 / 1 / 1 | Smoke count, speed, spread, size and opacity. |
| `muzzle_smoke.smoke_puff_* / smoke_sustained_*` | sequence settings | 见说明 / see notes | Single-shot/sustained smoke texture, columns, rows, frames, fps and duration_ms; sustained_shots is the shot threshold. |
| `muzzle_smoke.smoke_density_per_shot / smoke_max_density / smoke_sustained_shots / smoke_render_scale / smoke_max_particles_first_person / smoke_drag / smoke_buoyancy` | numbers | .28 / 1 / 3 / 3.5 / 8 / 2.8 / .16 | Density added per shot, density cap, sustained threshold, scale, first-person particle cap, drag and buoyancy. |
| `melee.enabled / damage / range / angle / knockback` | bool / damage / blocks / degrees / number | false / 2 / 2 / 30 / .5 | Melee enable, base damage, reach, attack angle and knockback. |
| `melee.duration / chain_open` | s | 1.3 / duration | Generic duration and combo opening time; opening is between impact and action end. |
| `melee.combos.primary / heavy / sprint` | combo objects | 独立近战需 primary / melee requires primary | Primary/heavy/sprint attack groups. |
| `COMBO.mode / reset_ms / attacks[]` | enum / ms / array | ordered / 700 / 必填-required | Ordered or random attack selection, reset timeout and per-attack timing. |
| `ATTACK.animation / duration_ms / commit_ms / chain_open_ms` | name / ms | 必填-required / 650 / 190 / duration_ms | Clip, duration, impact commit and combo opening; commit <= chain_open <= duration. |
| `ATTACK.damage_multiplier / range_multiplier / angle_multiplier / knockback_multiplier` | multipliers | 1 | Per-attack multipliers on base melee parameters. |

## Animation, reload and specialized guides

Field-by-field animation channels, pose layers, branches, sequences, events and interrupts are described in [Lua animation machines](lua-animation.md). For per-round `reload_system.clips/events/frame_lengths`, see [animation](animation.md); for recovery and magazine commands, see [firing and reload](firing-reload.md).

Optics, optical nodes and laser zeroing: [attachments and optics](attachments-optics.md). Refit camera/ammo preview and charm physics: [configuration examples](config-examples.md). Recipes: [gunsmith workbench](gunsmith-workbench.md).

### Adjustment order

1. Correct model units and anchors before display transforms.
2. Set mechanical cadence/commit times before animation durations, sound frames and fades.
3. For ammo errors check chamber, installed/replacement magazine, fill order, sampling and masks together.
4. Validate base color before ordinary/Iris PBR rendering; match channel interpretation to the shader pack.
5. Do not slow firing to conceal animation interrupts; a legal new shot can restart before previous recovery ends.
