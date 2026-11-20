---
title: 双持手枪
---

默认包提供两件独立的双持武器。把其中一件放在主手即可同时使用两把枪。可以在枪匠台制作，也可以通过命令取得。

| 武器 | 默认每侧弹量 | 取得命令 |
|---|---|---|
| 沙漠之鹰 双持 | 7 发 | `/gwo give firearm "gwo:desert_eagle_dual"` |
| Staccato 2011 P 双持 | 15 发 | `/gwo give firearm "gwo:staccato_2011_p_dual"` |

按默认键位，鼠标左键（攻击）发射左枪，鼠标右键（瞄准键）发射右枪。两侧独立点射、计时和扣弹，HUD 分侧显示余弹。按换弹键时，游戏按照两侧弹量选择动作。按近战键（默认 V）会让两手一起完成一次挥击。

## 枪械定义

在 `weapons/firearms/<id>.json` 中配置双持。下例是默认沙鹰双持的三个字段，合入已有枪械定义时保留 `mechanics` 的其他设置。

```json
{
  "magazine_size": 14,
  "fire_modes": ["semi"],
  "mechanics": { "dual_wield": true }
}
```

`magazine_size` 是两侧总容量，须为 2 至 1000 的偶数，左右各取一半。双持的 `fire_modes` 只填 `semi`。在对应的 render JSON 中，用 `state_machine` 指向这把武器的 Lua，例如 `gwo:weapons/desert_eagle_dual`。

## 换弹状态怎么选

以下是使用当前弹种时的选择规则。左右两侧互换时，把名称中的 `left` 与 `right` 互换。

| 按下换弹键时的弹量 | 播放状态 | 动作范围 |
|---|---|---|
| 左侧有余弹但未满，右侧满 | `reload_left` | 只换左侧 |
| 左侧空，右侧满 | `reload_empty_left` | 只换左侧，播放空仓动作 |
| 左侧空，右侧有余弹但未满 | `reload_left_empty` | 两侧都换，左侧播放空仓动作 |
| 两侧均有余弹且未满 | `reload` | 两侧都换 |
| 两侧均空 | `reload_empty` | 两侧都换，均走空仓动作 |

切换弹种时会选择双侧换弹。为各个换弹状态分别填写 `mechanics.action_commit_ms`，让弹量更新与该段动作对齐。

## 手部、空仓与配件

- **开火与空仓。** 双持 Lua 为左右枪分别配置 `fire_left`、`fire_right` 和 `empty_left`、`empty_right`。末发使用 `fire_last_left` 或 `fire_last_right`。按侧设置 `bone_mask`，让一侧空仓时，另一侧仍能开火。沙鹰的空仓层分别包含 `j_safetylock_left` 和 `j_safetylock_right`，两侧保险件才能跟各自的空仓姿势走。
- **手臂跟随。** 蒙皮跟随有权重的骨骼。方块手有独立骨骼时，在相应一侧制作手部轨道，或在通道里明确配置跟随来源和目标。单持 Staccato 的开火通道用 `follow_source_bone` 和 `follow_target_bones` 把 `tag_weapon` 的运动传给 `arms_root`。双持若要另一手维持握姿，跟随目标应限于开火侧。在奔跑循环的中段分别检查两手与握把的位置。
- **近战。** 默认两款双持各有三段 `melee_miss_01` 至 `03`、三段 `melee_hit_01` 至 `03` 和一段 `melee_fatal_01`。每个游戏剪辑同时包含两侧动作。制作时可分侧编辑，导出时把同一槽位的左右动作组合成一段。
- **配件与余弹。** 沙鹰的默认枪管在 `states` 对象中使用键名 `fixed_child.paired_visual` 关联右侧部件与左侧实例，同一次选择会更新两侧。弹匣分别设置 `ammo_slots.hand` 为 `left`、`right`，并给 `marker_suffix` 填写对应的 `_left`、`_right`，让可见弹药读取正确一侧。

检查成品时，让左枪先打空，保持右枪有弹，再打右枪、换弹；随后交换左右重复一次。确认 HUD、空仓部件、弹匣内可见弹药和手部姿势都与该侧一致。普通跑、超级跑及起跳的验证见[动画制作与导出规范](./animation.md)。
