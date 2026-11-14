---
title: Animation Names and Complete Inventory
order: 3.1
---

> **Lua animation API 1:** Animation configuration belongs in pack scripts under `config`. JSON animation fragments below illustrate field structure; use corresponding Lua tables and `array` values without duplicating those groups in render JSON. See [Lua animation machines](lua-animation.md) and the [parameter reference](parameters.md).

The default pack uses short clip names, preserving weapon-specific suffixes and placing `ads` last for ADS fire and reload clips. The table below describes their roles.

Use the same name for the Blender Action, exported GLB clip, controller channel, and its `clip`. Keep controller and action references aligned whenever a clip name changes.

## Naming rules

| Role | Name |
|---|---|
| Base idle | `idle` |
| Normal / first equip | `raise` / `raise_first` |
| Holster / empty holster | `drop` / `drop_empty` |
| Enter / leave ADS | `ads_up` / `ads_down` |
| ADS fire | `fire_ads` |
| ADS last round | `fire_last_ads` |
| ADS cycling | `fire_rechamber_ads` |
| ADS empty reload with compensator | `reload_empty_barcomp_ads` |
| Select semi-auto / full-auto | `selectsemi_on` / `selectsemi_off` |

Keep the `ads` prefix for ADS transitions/additive layers: `ads_up`, `ads_down`, and `ads_up_additive`. RM277 retains `down_settle` and `*_drum`; MG338 retains `bullets`; M200 retains `bullet_additive_5`; M590A1 retains `gun_butt_*_barmini`. M590A1, M200, MG338, and Staccato use `super_sprint_loop_proto`, which must be referenced by its real name in `phase_states`.

`animation_events` classifies actions; it is not a clip-alias table. For example, `fire_ads` still belongs to `fire`. Sound event IDs, attachment resource IDs, and logical states without exported clips have separate contracts and must not be blindly renamed.

## idle_active

These are the current M4 base and active-idle channels. The additive `idle_active` layer makes `arms_root` follow `tag_weapon`; renaming an Action does not create arm keyframes. Bone names and reference poses must match your own asset. Do not layer another weapon’s absolute transforms directly.

```json
{
  "animation_controller": {
    "channels": {
      "idle": {
        "clip": "idle",
        "layer": "base",
        "loop": true
      },
      "idle_active": {
        "clip": "idle_active",
        "layer": "idle_active",
        "loop": true,
        "blend": "bind_additive",
        "follow_source_bone": "tag_weapon",
        "follow_target_bones": [
          "arms_root"
        ],
        "bone_mask": [
          "tag_weapon",
          "tag_camera"
        ]
      }
    }
  }
}
```

## Naming and export checks

1. Check Blender Action and NLA references. Give each exported action a unique name.
2. Export the animation library and inspect its actual GLB clip names.
3. Align controller, action-machine, paired ADS actions, attachment overrides, and event state keys.
4. Verify normal/first equip, hip/ADS fire, every reload variant, sprint, and idle handoffs.

## Actual GLB inventory

The following 249 clip names were read from the current six animation GLBs. They are an inventory, not a mandatory list for every new weapon.

### M4 — 47

`m4`

```text
ads_down
ads_down_settle
ads_up
bullet_additive
bullet_additive_xmaglrg
drop
empty_additive
empty_additive_xmaglrg
fire
fire_ads
fire_last
fire_last_ads
fire_settle
firemode_auto_static
firemode_semi_static
idle
idle_active
inspect
inspect_empty
inspect_empty_xmaglrg
inspect_xmaglrg
melee_fatal_01
melee_hit_01
melee_hit_02
melee_hit_03
melee_miss_01
melee_miss_02
raise
raise_first
reload
reload_ads
reload_empty
reload_empty_ads
reload_empty_xmaglrg
reload_empty_xmaglrg_ads
reload_xmaglrg
reload_xmaglrg_ads
selectsemi_off
selectsemi_off_ads
selectsemi_on
selectsemi_on_ads
sprint_in
sprint_loop
sprint_out
super_sprint_in
super_sprint_loop
super_sprint_out
```

### RM277 — 48

`rm277`

```text
ads_down
ads_up
bullet_additive
bullet_additive_drum
down_settle
drop
fire
fire_ads
fire_last
fire_last_ads
fire_pre
fire_settle
firemode_auto_static
firemode_semi_static
idle
idle_active
inspect
inspect_drum
inspect_empty
inspect_empty_drum
melee_fatal_01
melee_fatal_02
melee_hit_01
melee_hit_02
melee_hit_03
melee_miss_01
melee_miss_02
melee_miss_03
raise
raise_first
reload
reload_ads
reload_drum
reload_drum_ads
reload_empty
reload_empty_ads
reload_empty_drum
reload_empty_drum_ads
selectsemi_off
selectsemi_off_ads
selectsemi_on
selectsemi_on_ads
sprint_in
sprint_loop
sprint_out
super_sprint_in
super_sprint_loop
super_sprint_out
```

### M590A1 — 45

`m590a1`

```text
ads_down
ads_up
ads_up_additive
drop
fire
fire_ads
fire_last
fire_last_ads
fire_rechamber
fire_rechamber_ads
gun_butt_fatal_01_barmini
gun_butt_fatal_02_barmini
gun_butt_hit_01_barmini
gun_butt_hit_02_barmini
gun_butt_hit_03_barmini
gun_butt_miss_01_barmini
gun_butt_miss_02_barmini
gun_butt_miss_03_barmini
idle
idle_active
idle_empty_additive
inspect
inspect_empty
raise
raise_first
reload_empty_chamber_end
reload_empty_chamber_end_ads
reload_empty_chamber_start
reload_empty_chamber_start_ads
reload_empty_start
reload_empty_start_ads
reload_end
reload_end_ads
reload_loop
reload_loop_ads
reload_start
reload_start_ads
shell_additive_3
shell_additive_8
sprint_in
sprint_loop
sprint_out
super_sprint_in
super_sprint_loop_proto
super_sprint_out
```

### CheyTac M200 — 36

`cheytac_m200`

```text
ads_down
ads_down_settle
ads_up
ads_up_additive
bullet_additive_5
drop
fire
fire_ads
fire_last
fire_last_ads
fire_rechamber
fire_rechamber_ads
idle
idle_active
inspect
inspect_empty
melee_fatal_01
melee_fatal_02
melee_hit_01
melee_hit_02
melee_hit_03
melee_miss_01
melee_miss_02
melee_miss_03
raise
raise_first
reload
reload_ads
reload_empty
reload_empty_ads
sprint_in
sprint_loop
sprint_out
super_sprint_in
super_sprint_loop_proto
super_sprint_out
```

### MG338 — 34

`mg338`

```text
ads_down
ads_down_settle
ads_up
bullets
drop
fire
fire_ads
fire_last
fire_last_ads
fire_pre
fire_settle
idle
idle_active
idle_empty_additive
inspect
inspect_empty
melee_fatal_01
melee_fatal_02
melee_hit_01
melee_hit_02
melee_hit_03
melee_miss_01
melee_miss_02
melee_miss_03
raise
raise_first
reload
reload_empty
sprint_in
sprint_loop
sprint_out
super_sprint_in
super_sprint_loop_proto
super_sprint_out
```

### Staccato 2011 P — 39

`staccato_2011_p`

```text
ads_down
ads_down_settle
ads_up
ads_up_additive
bullet_additive
drop
drop_empty
empty_additive
fire
fire_ads
fire_last
fire_last_ads
idle
idle_active
inspect
inspect_barcomp
inspect_empty
melee_fatal
melee_hit_01
melee_hit_02
melee_hit_03
melee_miss_01
melee_miss_02
melee_miss_03
raise
raise_first
raise_first_barcomp
reload
reload_ads
reload_empty
reload_empty_ads
reload_empty_barcomp
reload_empty_barcomp_ads
sprint_in
sprint_loop
sprint_out
super_sprint_in
super_sprint_loop_proto
super_sprint_out
```
