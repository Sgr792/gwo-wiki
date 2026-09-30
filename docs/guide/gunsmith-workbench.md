---
title: 枪械工作台
icon: hammer
category:
  - 内容包制作
---

# 枪械工作台

枪械工作台用于在生存模式制作内容包定义的枪械、弹药和配件。方块、模型及动画属于 GWO 本体；可制作的物品和成本由内容包的 `recipes/gunsmith/*.json` 决定。

## 游戏内使用

在创造栏“其他”取得工作台，或在原版工作台用第一排三个铁锭、第二排“铁锭／工作台／铁锭”、第三排三个原木合成。放置需要两格宽、一格深、两格高的空间。右键打开菜单，选择配方后开始制作；生存模式从背包扣除材料，创造模式免材料。完成后从输出槽领取；输出未取走前不能开始下一次加工。关闭界面或退出游戏不会取消已开始的加工，区块卸载时进度暂停。

## 编写内容包配方

创建 `recipes/gunsmith/craft_example_rifle.json`：

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

- `id` 是唯一配方 ID；`result.id` 是枪械、弹药或配件的**内容定义 ID**，不是 `gwo:assault_rifle` 等注册物品 ID。枪械定义必须已加载。
- `category` 与 `result.type` 使用 `firearm`、`ammo` 或 `attachment`，两者须一致；省略 `category` 时取 `result.type`。
- `ingredients` 填 1～8 项，每项只能用 `item`、`tag`、`ammo`、`attachment` 中的一种选择器，`count` 为 1～512。
- 枪械和配件单次产量只能是 1；弹药可为 1～64，不能超过该弹药的堆叠上限。枪械产物带默认配件，但弹匣和弹膛为空。
- `craft_time_ticks` 为 1～32000，20 tick 约为 1 秒。弹药可以选择批数，成本、产出和时间同比增加。

重复配方 ID 会使同 ID 的配方全部失效。单份 JSON 不超过 8192 字符，所有内容包合计最多 512 条配方。修改后运行 `/gwo reload` 或 `/reload`，重新打开工作台检查列表；已经开始的加工仍按启动时的材料和产物快照完成。

调试时先确认 `result.id` 对应的内容包已加载，再检查日志中的无效配方原因。完整字段与服务端规则见[本体工作台说明](https://github.com/Sgr792/gwo/blob/main/docs/gunsmith-workbench.md)。


字段的作用、单位、默认值和调参影响可查 [内容包参数参考](parameters.md)。动画控制与混合见 [Lua 动画机](lua-animation.md)。
