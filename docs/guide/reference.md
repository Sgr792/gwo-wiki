---
title: 权威参考文件
order: 9
category:
  - 内容包制作
---

## 权威参考文件

先用[空内容包模板](empty-template.md)建立自己的包。下表列出当前默认内容包中各类典型实现的文件名；如果你拥有与当前模组版本匹配的默认内容包，可以按类型对照，但不要把默认内容包的命名空间和资源 ID 原样复制进自己的项目。

| 类型 | 逻辑文件 | 渲染文件 |
|---|---|---|
| 突击步枪/弹匣式长枪 | `weapons/firearms/m4.json` | `weapons/firearms/render/m4.render.json` |
| 手枪 | `weapons/firearms/staccato_2011_p.json` | `weapons/firearms/render/staccato_2011_p.render.json` |
| 管式霰弹枪 | `weapons/firearms/m590a1.json` | `weapons/firearms/render/m590a1.render.json` |
| 栓动狙击枪 | `weapons/firearms/cheytac_m200.json` | `weapons/firearms/render/cheytac_m200.render.json` |
| 独立近战 | `weapons/melee/karambit.json` | `weapons/melee/render/karambit.render.json` |
| 增倍镜 | `attachments/sights/sz_bullseye_optic.json` | `attachments/render/sights/sz_bullseye_optic.render.json` |
| 激光器 | `attachments/lasers/1mw_laser_box.json` | `attachments/render/lasers/1mw_laser_box.render.json` |
| 大型箱式扩容弹匣（xmaglrg） | `attachments/magazines/m4_xmaglrg.json` | `attachments/render/magazines/m4_xmaglrg.render.json` |
| 鼓式弹匣（drummag，模型与配件定义） | `attachments/magazines/rm277_drummag.json` | `attachments/render/magazines/rm277_drummag.render.json` |
| 弹药 | `bullets/5_56x45.json` | 同一文件包含模型材质定义 |

这些路径相对于当前默认内容包根目录。公开 Wiki 只提供不含武器资源的空模板，避免教程依赖已移除或版本不匹配的示例链接。字段与结构以当前 Wiki 和加载器校验结果为准。

## 不要继续使用的旧字段

以下名称属于已经忽略或明确移除的旧格式。新内容包不要写入；当前字段和默认值则应保留。

| 旧字段 | 当前写法 |
|---|---|
| `hud_icon_texture` | `hud.weapon_icon` |
| `camera.recoil_pitch`、`camera.recoil_yaw`、`camera.recoil_recovery`、`recoil.handRotPivot`、`recoil_animation` | 当前 `recoil` 配置 |
| `arms.arm_poses` | 当前 `arms`、动画控制器与 `pose_graph` |
| 模块的 `default_enabled`、`built_in`、`incompatible_with` | `default_installed`、`embedded`、`conflicts_with` |
| 瞄具的 `reticle_attach_node`、`lense_hide_node` | `reticle_node`、`lens_hide_node` |
| 直接写在 `reticle_preview` 下的 `u/v/width/height` | `reticle_preview.crop.u/v/width/height` |
| 顶层 `rpm`、`shot_cooldown_*`、`automatic_interval_*` | `mechanics.rpm` 与 `mechanics.fire_interval_ms` |
| `animation_state_rules`、`animation_interrupt_rules` | `animation_machine` |
| `melee.impact_frame`、`melee.impact_time` | `melee.combos.*.attacks[]` 的时序字段 |
| `sight.hybrid` | `sight.optic` |

不要把“显式写出的当前默认值”或名称相同的有效动画映射误判为废弃字段。只有上表旧名称以及加载器明确拒绝的格式才应清理。

无需持有默认包的教学配置见[配置示例与接入步骤](./config-examples.md)。合并示例时保留现有有效字段和显式默认值，不要整段覆盖自己的配置。
