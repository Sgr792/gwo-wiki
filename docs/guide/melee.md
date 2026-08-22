---
title: 独立近战武器
order: 6
category:
  - 内容包制作
---

## 16. 独立近战武器

近战武器放在 `weapons/melee/`，不是 `weapons/firearms/`，也不应伪装成弹量为 0 的枪。

逻辑示例：

```json
{
  "id": "example:example_knife",
  "display_name": "示例近战武器",
  "creative_category": "melee",
  "creative_sort": 10,
  "model_data": 2100,
  "damage": 7.0,
  "melee": {
    "enabled": true,
    "damage": 7.0,
    "range": 3.0,
    "angle": 42.0,
    "knockback": 0.35,
    "combos": {
      "primary": {
        "mode": "random",
        "reset_ms": 700,
        "attacks": [
          {
            "animation": "swipe_01",
            "duration_ms": 833,
            "commit_ms": 180,
            "chain_open_ms": 390
          },
          {
            "animation": "stab_01",
            "duration_ms": 833,
            "commit_ms": 250,
            "chain_open_ms": 470
          }
        ]
      }
    }
  },
  "render": "weapons/melee/render/example_knife.render.json"
}
```

攻击动画在 `melee.combos.primary.attacks` 中明确列出；`mode: "random"` 为随机选择，改为内容支持的顺序模式时才按顺序选择。近战武器有自己的装备、收起、待机、检视、奔跑和攻击状态，不使用枪械换弹、弹药和射击 HUD。

完整参考 `karambit.json` 和 `karambit.render.json`。
