---
title: 动画名称规范与完整清单
order: 3.1
---

> **Lua 动画机 API 1：** 新版动画配置放在内容包 Lua 脚本的 `config` 中。下文 JSON 动画片段仍用于说明数据结构和旧包兼容；不要与 Lua 重复定义。接入、函数和动画参数见 [Lua 动画机](lua-animation.md)，其他字段作用见 [参数参考](parameters.md)。

本页对应 2026-09-10 的默认内容包迁移。采用 COD 风格短名称；每把枪保留自己的动作后缀，射击与换弹的瞄准版本统一把 `ads` 放在末尾。这是 GWO 的统一规则，不表示原始 COD 表中所有名称都完全一致。

Blender Action、导出 GLB 剪辑、控制器通道及其 `clip` 使用相同名字。默认包直接使用这些名字，不通过旧名称别名映射。模组 JAR、动画 GLB 和内容包配置需要配套更新。

## 命名规则

| 原名称 | 当前名称 |
|---|---|
| `static_idle` | `idle` |
| `draw / draw_first` | `raise / raise_first` |
| `holster / holster_empty` | `drop / drop_empty` |
| `aim_in / aim_out` | `ads_up / ads_down` |
| `aim_fire / ads_fire` | `fire_ads` |
| `ads_fire_last` | `fire_last_ads` |
| `aim_fire_rechamber` | `fire_rechamber_ads` |
| `aim_reload_empty_barcomp` | `reload_empty_barcomp_ads` |
| `switch_to_semi / switch_to_auto` | `selectsemi_on / selectsemi_off` |

`ads_up`、`ads_down`、`ads_up_additive` 是瞄准过渡或附加层，保留 `ads` 前缀。RM277 保留 `down_settle`、`*_drum`；MG338 保留 `bullets`；M200 保留 `bullet_additive_5`；M590A1 保留 `gun_butt_*_barmini`。M590A1、M200、MG338、Staccato 的超级冲刺循环为 `super_sprint_loop_proto`，须在 `phase_states` 中引用真实名称。

`animation_events` 是动作分类，不是剪辑别名。例如 `fire_ads` 仍归类为 `fire`。声音事件 ID、配件资源 ID 和未导出为剪辑的逻辑状态需要按各自配置处理，不要机械批量改名。

## idle_active

下面是当前 M4 控制器中的基础与活动待机通道。`idle_active` 使用附加层，并通过 `tag_weapon` 带动 `arms_root`；只改 Action 名称不会自动产生手臂关键帧。骨骼与基础姿态必须和自己的资产一致，不要把其他枪的绝对变换直接叠加进来。

```json
{
  "animation_controller": {
    "channels": {
      "idle": {
        "clip": "idle",
        "layer": "base",
        "loop": true
      },
      "idle_active": {
        "clip": "idle_active",
        "layer": "idle_active",
        "loop": true,
        "blend": "bind_additive",
        "follow_source_bone": "tag_weapon",
        "follow_target_bones": [
          "arms_root"
        ],
        "bone_mask": [
          "tag_weapon",
          "tag_camera"
        ]
      }
    }
  }
}
```

## 迁移 Blender 源文件

1. 在 Blender 打开对应枪械源文件，将[改名脚本](/downloads/blender-cod-animation-names.py)的 `WEAPON` 设置为下面的枪械 ID 后运行。脚本只改 Action 名称，不自动保存、不修改关键帧；遇到目标重名会停止。
2. 检查 Action 与 NLA 引用，保存源文件并重新导出动画库。
3. 同步控制器、动作机、配对瞄准动作、配件动画覆盖与事件状态键，删除默认包旧别名表。声音事件值按语义保留。
4. 验证普通/首次掏枪、腰射/瞄准开火、所有弹匣换弹、冲刺和待机交接。

[下载旧名与新名对照表（TSV）](/downloads/cod-animation-names.tsv)。对照表用于离线迁移，不是运行时映射。

## 六把枪的实际 GLB 清单

下列名称直接从当前动画 GLB 读取，共 249 个剪辑；不是必须为每把新枪全部制作的通用列表。

### M4 — 47

`m4`

```text
ads_down
ads_down_settle
ads_up
bullet_additive
bullet_additive_xmaglrg
drop
empty_additive
empty_additive_xmaglrg
fire
fire_ads
fire_last
fire_last_ads
fire_settle
firemode_auto_static
firemode_semi_static
idle
idle_active
inspect
inspect_empty
inspect_empty_xmaglrg
inspect_xmaglrg
melee_fatal_01
melee_hit_01
melee_hit_02
melee_hit_03
melee_miss_01
melee_miss_02
raise
raise_first
reload
reload_ads
reload_empty
reload_empty_ads
reload_empty_xmaglrg
reload_empty_xmaglrg_ads
reload_xmaglrg
reload_xmaglrg_ads
selectsemi_off
selectsemi_off_ads
selectsemi_on
selectsemi_on_ads
sprint_in
sprint_loop
sprint_out
super_sprint_in
super_sprint_loop
super_sprint_out
```

### RM277 — 48

`rm277`

```text
ads_down
ads_up
bullet_additive
bullet_additive_drum
down_settle
drop
fire
fire_ads
fire_last
fire_last_ads
fire_pre
fire_settle
firemode_auto_static
firemode_semi_static
idle
idle_active
inspect
inspect_drum
inspect_empty
inspect_empty_drum
melee_fatal_01
melee_fatal_02
melee_hit_01
melee_hit_02
melee_hit_03
melee_miss_01
melee_miss_02
melee_miss_03
raise
raise_first
reload
reload_ads
reload_drum
reload_drum_ads
reload_empty
reload_empty_ads
reload_empty_drum
reload_empty_drum_ads
selectsemi_off
selectsemi_off_ads
selectsemi_on
selectsemi_on_ads
sprint_in
sprint_loop
sprint_out
super_sprint_in
super_sprint_loop
super_sprint_out
```

### M590A1 — 45

`m590a1`

```text
ads_down
ads_up
ads_up_additive
drop
fire
fire_ads
fire_last
fire_last_ads
fire_rechamber
fire_rechamber_ads
gun_butt_fatal_01_barmini
gun_butt_fatal_02_barmini
gun_butt_hit_01_barmini
gun_butt_hit_02_barmini
gun_butt_hit_03_barmini
gun_butt_miss_01_barmini
gun_butt_miss_02_barmini
gun_butt_miss_03_barmini
idle
idle_active
idle_empty_additive
inspect
inspect_empty
raise
raise_first
reload_empty_chamber_end
reload_empty_chamber_end_ads
reload_empty_chamber_start
reload_empty_chamber_start_ads
reload_empty_start
reload_empty_start_ads
reload_end
reload_end_ads
reload_loop
reload_loop_ads
reload_start
reload_start_ads
shell_additive_3
shell_additive_8
sprint_in
sprint_loop
sprint_out
super_sprint_in
super_sprint_loop_proto
super_sprint_out
```

### CheyTac M200 — 36

`cheytac_m200`

```text
ads_down
ads_down_settle
ads_up
ads_up_additive
bullet_additive_5
drop
fire
fire_ads
fire_last
fire_last_ads
fire_rechamber
fire_rechamber_ads
idle
idle_active
inspect
inspect_empty
melee_fatal_01
melee_fatal_02
melee_hit_01
melee_hit_02
melee_hit_03
melee_miss_01
melee_miss_02
melee_miss_03
raise
raise_first
reload
reload_ads
reload_empty
reload_empty_ads
sprint_in
sprint_loop
sprint_out
super_sprint_in
super_sprint_loop_proto
super_sprint_out
```

### MG338 — 34

`mg338`

```text
ads_down
ads_down_settle
ads_up
bullets
drop
fire
fire_ads
fire_last
fire_last_ads
fire_pre
fire_settle
idle
idle_active
idle_empty_additive
inspect
inspect_empty
melee_fatal_01
melee_fatal_02
melee_hit_01
melee_hit_02
melee_hit_03
melee_miss_01
melee_miss_02
melee_miss_03
raise
raise_first
reload
reload_empty
sprint_in
sprint_loop
sprint_out
super_sprint_in
super_sprint_loop_proto
super_sprint_out
```

### Staccato 2011 P — 39

`staccato_2011_p`

```text
ads_down
ads_down_settle
ads_up
ads_up_additive
bullet_additive
drop
drop_empty
empty_additive
fire
fire_ads
fire_last
fire_last_ads
idle
idle_active
inspect
inspect_barcomp
inspect_empty
melee_fatal
melee_hit_01
melee_hit_02
melee_hit_03
melee_miss_01
melee_miss_02
melee_miss_03
raise
raise_first
raise_first_barcomp
reload
reload_ads
reload_empty
reload_empty_ads
reload_empty_barcomp
reload_empty_barcomp_ads
sprint_in
sprint_loop
sprint_out
super_sprint_in
super_sprint_loop_proto
super_sprint_out
```
