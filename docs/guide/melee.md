---
title: 独立近战武器
order: 6
category:
  - 内容包制作
---

> **Lua 动画机 API 1：** 动画配置放在内容包 Lua 脚本的 `config` 中。下文 JSON 动画片段用于说明字段结构；在 Lua 中使用对应 table 和 `array` 写法，不要在 render JSON 中重复定义。接入、函数和动画参数见 [Lua 动画机](lua-animation.md)，其他字段作用见 [参数参考](parameters.md)。

## 独立近战武器

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

### 零基础制作顺序

独立近战不要从枪械 JSON 删除弹药字段后硬改。按以下顺序制作：

1. 在 `weapons/melee/` 创建逻辑文件。
2. 在 `weapons/melee/render/` 创建渲染文件。
3. 先只提供 `idle`、`raise_first`、`drop` 和一个攻击动作。
4. 确认拿出、收起、待机与攻击的手臂参考空间正确。
5. 在 `melee.combos.primary.attacks` 中加入第二、第三个攻击。
6. 分别设置每段的 `duration_ms`、`commit_ms` 和 `chain_open_ms`。
7. 最后再加检视、奔跑、超级奔跑、命中分支和声音。

三个时序字段不要混淆：

| 字段 | 作用 |
|---|---|
| `duration_ms` | 这一段动作占用状态的总时间 |
| `commit_ms` | 真正进行近战判定和伤害提交的时间 |
| `chain_open_ms` | 允许下一次输入衔接下一段攻击的时间 |

`commit_ms` 不是“必须打到实体才播放的动画帧”。对空气攻击也会正常播放完整攻击动作；命中与否只决定伤害、命中反馈和可选命中分支。`chain_open_ms` 太晚会让武器必须等动作几乎结束才能再次攻击，太早则可能出现动作未完成就连续提交伤害。

### 动画与手臂验收

- 武器模型和手臂动画库必须共享参考空间。
- 如果右手看起来黏死在刀上或方向反了，检查右手通道所有权、绑定姿态和武器根变换。
- `idle`、`raise_first`、`drop` 和 `inspect` 的右手都应来自实际动画，不应复用枪械的持枪手臂层。
- 攻击结束回到 `idle` 时，不应出现一帧姿态跳变。
- 奔跑动画必须按近战武器自己的基础持有姿态混合，不能直接套枪械的反向叠加结果。

### 声音验收

近战至少检查首次拿出、收起、检视动作点、挥空、命中实体以及需要的致死/重击强调层。动作声使用 `animation_commands` 对齐动画帧，空间命中声在实际命中结果发生时播放。不要把挥舞声、命中声和击杀强调声全部烘进一个 OGG 后又在逻辑中重复触发。

### 最小验收

```text
/gwo reload
/gwo give melee "example:example_knife"
```

依次测试待机、第一次拿出、收起、连续对空气攻击、连续命中目标、检视、奔跑和死亡后重新拿出。只有这些状态都不回到枪械 HUD、没有弹药显示且手臂不跳变，才算真正独立的近战武器。

## 合成工程与导出检查

当前三角洲近战合成使用 Blender 3.3、60 FPS（fps_base=1）。原生 30 FPS 轨道转换到 60 FPS 时，帧号乘 2 并保留秒时长，不能只改场景 FPS。源模型缩放与方块手臂截面是不同设置；当前合成手臂局部缩放采用 `(1, 0.5, 0.5)`，仍需逐把校准握持，不能对已适配资产重复应用。

正式导出只保留选定骨架/网格和正式动作；不要把多个预览场景一起导出。独立手臂与武器共享骨名、绑定和逆绑定矩阵，独立手臂资源不重复存储整套动作。`idle_active` 作为增量使用时只编码一次，保留完整源动作供编辑。

检视道具、链条、铃铛等附属节点须检查中间帧与隐藏状态。出现闪烁时按[动画排错](animation-visibility.md)区分父子缩放、采样和距离过滤；不能通过增大阈值掩盖巨大几何。
