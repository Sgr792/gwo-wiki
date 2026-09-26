---
title: Recent Updates and Upgrade Notes
icon: clock
order: 0
category:
  - Content-Pack Authoring
---

# Recent Updates and Upgrade Notes

This page covers player-facing and author-facing core changes merged since September 11, 2026. A GitHub commit does not mean a new CurseForge release is available.

## September 26, 2026 · Firearm item IDs and training targets

- Ordinary firearms now register category-specific item IDs: `gwo:assault_rifle`, `gwo:battle_rifle`, `gwo:submachine_gun`, `gwo:shotgun`, `gwo:light_machine_gun`, `gwo:marksman_rifle`, `gwo:sniper_rifle`, `gwo:pistol`, and `gwo:launcher`.
- A firearm with `transformation` uses `gwo:transforming_gun` in both forms. Melee weapons still use `gwo:melee_weapon`.
- **The old `gwo:gun` registration is gone; saved items are not migrated automatically.** Back up your world and handle older guns in inventories and containers before upgrading. Content definition IDs, `/gwo give firearm` arguments, and workbench `result.id` values do not change. See [firearm categories](./firearms.md).
- A training target scores a front-plate hit only while standing. The fallen plate still stops projectiles but no longer repeats the target reading or target hit sound. It takes about 0.25 seconds to fall, stays down about one second, and rises in about 0.45 seconds; the full cycle is about 1.7 seconds.

## September 16–26, 2026 · Content and rendering

- The gunsmith workbench and metal training target were added. In survival, the workbench consumes inventory materials and crafts firearms, ammunition, and attachments using content-pack `recipes/gunsmith/*.json`. Collect completed items from its output slot.
- Content packs can define dual-form firearms with `transformation`; pair core, animation GLB, and configuration versions when updating packs such as Fate or Freedom.
- Weighted skinning and rendering were updated. Fixes address a blank image on the first use of a magnified optic, some emissive colors under shaders, and unwanted world-FOV changes while moving in ADS. Test optics both without shaders and with Iris, including the first ADS activation.
- Vanilla movement-related world-FOV changes from sprinting and flying are restored, while the weapon-model FOV remains independent. Recheck iron-sight and magnified-optic alignment if your pack was adjusted around the previous behavior.

## Gunsmith recipes

Put custom recipes under `recipes/gunsmith/*.json` in the content pack. `result.type` is `firearm`, `ammo`, or `attachment`; `result.id` is the corresponding **content definition ID**, not a registered item ID such as `gwo:assault_rifle`. The recipe controls material costs and crafting duration. After a definition change, run `/gwo reload` and reopen the workbench; an active job keeps the material and output snapshot taken when it started.

See the [workbench format in the development repository](https://github.com/Sgr792/gwo/blob/main/docs/gunsmith-workbench.md) and [in-game validation checklist](./debugging-release.md).
