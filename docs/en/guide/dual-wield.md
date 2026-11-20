---
title: Dual-wield pistols
---

The default pack includes two dual-wield items. Equip one in the main hand to use both pistols. Craft the item at a gunsmith workbench or obtain it with a command.

| Weapon | Default rounds per side | Command |
|---|---|---|
| Dual Desert Eagle | 7 | `/gwo give firearm "gwo:desert_eagle_dual"` |
| Dual Staccato 2011 P | 15 | `/gwo give firearm "gwo:staccato_2011_p_dual"` |

With the default bindings, left-click (attack) fires the left pistol and right-click (aim) fires the right pistol. Each trigger handles its own semi-auto shots, interval and ammunition. The HUD shows the two counts separately. Reload selects an animation from both counts. The melee key (V by default) plays one strike with both hands.

## Firearm definition

Configure the pair in `weapons/firearms/<id>.json`. These three fields come from the Dual Desert Eagle. Keep the other `mechanics` entries when merging them into a weapon definition.

```json
{
  "magazine_size": 14,
  "fire_modes": ["semi"],
  "mechanics": { "dual_wield": true }
}
```

`magazine_size` is the combined capacity. Use an even number from 2 to 1000. Each side gets half. The only supported `fire_modes` value for a pair is `["semi"]`. In the render JSON, point `state_machine` to the weapon’s Lua script, for example `gwo:weapons/desert_eagle_dual`.

## Reload selection

This table applies when keeping the current ammo type. Swap `left` and `right` in the state names for the opposite case.

| Ammunition when reload is pressed | State | What moves |
|---|---|---|
| Left partial, right full | `reload_left` | Left only |
| Left empty, right full | `reload_empty_left` | Left only, with its empty reload |
| Left empty, right partial | `reload_left_empty` | Both, with an empty reload on the left |
| Both partial | `reload` | Both |
| Both empty | `reload_empty` | Both, with empty reloads |

Changing ammo type selects a two-sided reload. Set `mechanics.action_commit_ms` for each reload state so the ammo count updates at the intended point in its animation.

## Hands, empty poses and attachments

- **Fire and empty poses.** The default scripts configure separate `fire_left`, `fire_right`, `empty_left` and `empty_right` channels. Last rounds use `fire_last_left` or `fire_last_right`. Scope each `bone_mask` to its side so one pistol can stay empty while the other fires. On the Desert Eagle, the empty masks include `j_safetylock_left` and `j_safetylock_right` respectively so each safety follows its pistol’s empty pose.
- **Arm motion.** A skinned mesh follows its weighted bones. For a block arm with an independent bone, author an arm track or configure the channel’s follow source and targets. The single Staccato’s fire channel uses `follow_source_bone` and `follow_target_bones` to pass motion from `tag_weapon` to `arms_root`. For a pair, scope the target to the firing side if the opposite hand should hold its pose. Scrub the middle of the sprint loop to check each grip.
- **Melee.** Both default pairs have three `melee_miss_01` through `03` clips, three `melee_hit_01` through `03` clips and one `melee_fatal_01`. Each game clip moves both hands together. When authoring sides separately, combine the left and right actions for the same slot at export.
- **Attachments and visible rounds.** In the Desert Eagle barrel’s `states` object, the key `fixed_child.paired_visual` links the selectable right-side part to its left instance. One selection updates both. Set `ammo_slots.hand` to `left` or `right` on each magazine and give `marker_suffix` the matching `_left` or `_right` suffix so its visible rounds follow that side’s count.

For an in-game check, empty the left pistol while the right still has rounds, fire the right pistol, then reload. Repeat with the sides reversed. Check the HUD, empty-state parts, visible rounds and hands on each side. See [Animation Authoring and Export Rules](./animation.md) for sprint and jump checks.
