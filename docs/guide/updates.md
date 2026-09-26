---
title: 近期更新与升级提示
icon: clock
order: 0
category:
  - 内容包制作
---

# 近期更新与升级提示

本页汇总 2026 年 9 月 11 日以来已合入本体、会影响玩家或内容作者的变化。这里描述源码状态；GitHub 提交不等于 CurseForge 已发布新版。

## 2026-09-26 · 枪械物品 ID 与训练靶

- 普通枪械按 `creative_category` 注册独立物品 ID：`gwo:assault_rifle`、`gwo:battle_rifle`、`gwo:submachine_gun`、`gwo:shotgun`、`gwo:light_machine_gun`、`gwo:marksman_rifle`、`gwo:sniper_rifle`、`gwo:pistol`、`gwo:launcher`。
- 配有 `transformation` 的枪械使用 `gwo:transforming_gun`；形态切换仍是同一件物品。近战继续使用 `gwo:melee_weapon`。
- **旧 `gwo:gun` 已删除注册，没有自动迁移。** 更新前备份世界，在旧版本中处理背包和容器中的旧枪械。枪械内容定义 ID、`/gwo give firearm` 参数及工作台配方的 `result.id` 不随物品注册 ID 改名。详见[枪械分类](./firearms.md#武器分类)。
- 金属倒伏靶只在立起时将正面板命中计为有效命中；倒下后板面仍会挡住子弹，但不重复显示命中读数或播放靶子命中音。现在约 0.25 秒倒下、倒地约 1 秒、约 0.45 秒起身，完整周期约 1.7 秒。

## 2026-09-16—26 · 新内容与渲染修复

- 加入枪械工作台与金属倒伏靶。工作台在生存模式从背包扣除材料，按内容包 `recipes/gunsmith/*.json` 制作枪械、弹药和配件；加工完成后从输出槽领取。配方示例见[枪械工作台](#枪械工作台配方)。
- 支持内容包定义双形态枪械；形态切换与模型动画由 `transformation` 配置驱动。涉及 Fate、Freedom 等内容包时，请确保本体、动画 GLB 与配置版本配套。
- 更新多骨骼蒙皮与渲染路径，并修复首次使用增倍模式时镜内无画面、光影下部分自发光颜色异常、瞄准状态移动引起的视野缩放问题。制作瞄具时仍需分别检查无光影和 Iris 光影，以及首次开镜。
- 恢复奔跑、飞行等原版移动速度变化带来的世界视野变化；枪械模型视野单独控制。现有内容包若以旧错误视野调过瞄准位置，升级后应重新检查机瞄和倍镜。

## 枪械工作台配方

自定义配方放在内容包的 `recipes/gunsmith/*.json`。配方的 `result.type` 为 `firearm`、`ammo` 或 `attachment`，`result.id` 是相应**内容定义 ID**，不是 `gwo:assault_rifle` 等物品注册 ID。成本和耗时由配方控制。更改定义后执行 `/gwo reload`，并重新打开工作台菜单；正在加工的物品保留启动时的材料和产物快照。

完整示例和字段约束见[开发仓库的工作台说明](https://github.com/Sgr792/gwo/blob/main/docs/gunsmith-workbench.md)。修改内容包后仍需按[调试与发布检查](./debugging-release.md)在游戏里验收。
