---
title: 权威参考文件
order: 9
category:
  - 内容包制作
---

## 25. 权威参考文件

制作新内容时按武器类型复制最接近的现有实现：

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

这些路径均相对于[官方示例内容包](https://github.com/Sgr792/gwo/tree/main/work/example-contentpack)根目录。字段与结构以当前版本示例和加载器校验结果为准。

## 26. 不要继续使用的旧字段

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
