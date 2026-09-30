---
title: Gunsmith Workbench
icon: hammer
category:
  - Content-Pack Authoring
---

# Gunsmith Workbench

The gunsmith workbench crafts content-pack firearms, ammunition, and attachments in survival mode. GWO provides its block, model, and animation; content packs supply recipes under `recipes/gunsmith/*.json`.

## In-game use

Find the workbench in the Other creative tab, or craft it with three iron ingots on the top row, iron ingot / crafting table / iron ingot in the middle, and three logs on the bottom. Placement requires a two-wide, one-deep, two-high space. Right-click it, select a recipe, and start crafting. Survival consumes inventory materials; creative mode does not. Collect the result from the output slot before starting another job. Closing the menu or logging out does not cancel a job; progress pauses while the chunk is unloaded.

## Author a content-pack recipe

Create `recipes/gunsmith/craft_example_rifle.json`:

```json
{
  "id": "example:craft_example_rifle",
  "category": "firearm",
  "ingredients": [
    { "item": "minecraft:iron_ingot", "count": 16 },
    { "item": "minecraft:copper_ingot", "count": 6 },
    { "tag": "minecraft:planks", "count": 4 }
  ],
  "result": {
    "type": "firearm",
    "id": "example:example_rifle",
    "count": 1
  },
  "craft_time_ticks": 100
}
```

- `id` uniquely identifies the recipe. `result.id` is a **content definition ID**, not a registered item ID such as `gwo:assault_rifle`. The referenced firearm definition must be loaded.
- `category` and `result.type` are `firearm`, `ammo`, or `attachment` and must agree. Omitted `category` defaults to `result.type`.
- `ingredients` contains 1–8 entries. Each entry has exactly one `item`, `tag`, `ammo`, or `attachment` selector, with `count` from 1 to 512.
- Firearms and attachments produce one item; ammunition produces 1–64, within its stack limit. A crafted firearm includes its default parts but starts with an empty magazine and chamber.
- `craft_time_ticks` ranges from 1 to 32000; 20 ticks are about one second. Ammunition batches multiply cost, output, and duration.

Duplicate recipe IDs disable every recipe with that ID. Each JSON file is limited to 8192 characters, and all enabled packs together may define at most 512 recipes. After editing, run `/gwo reload` or `/reload` and reopen the workbench; an active job keeps the materials and output captured when it began.

If a recipe is missing, verify that its `result.id` definition loaded, then inspect the invalid-recipe log entry. See the [core workbench reference](https://github.com/Sgr792/gwo/blob/main/docs/gunsmith-workbench.md) for the complete server-side rules.


For field purpose, units, defaults and adjustment effects, see the [parameter reference](parameters.md). For animation control/blending, see [Lua animation machines](lua-animation.md).
