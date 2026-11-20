---
title: 动画名称规范与完整清单
order: 3.1
---

> **Lua 动画机 API 1：** 动画配置放在内容包 Lua 脚本的 `config` 中。下文 JSON 动画片段用于说明字段结构；在 Lua 中使用对应 table 和 `array` 写法，不要在 render JSON 中重复定义。接入、函数和动画参数见 [Lua 动画机](lua-animation.md)，其他字段作用见 [参数参考](parameters.md)。

默认内容包采用短名称；每把枪保留自己的动作后缀，射击与换弹的瞄准版本统一把 `ads` 放在末尾。下表说明各名称的用途。

控制器通道的 `clip` 填 GLB 中实际的剪辑名。默认 M4 和 RM277 的 `firemode_semi_static`、`firemode_auto_static` 是快慢机姿势状态，分别在 `selectsemi_on`、`selectsemi_off` 剪辑中采样指定帧。制作时导出这两段选择器剪辑，再让状态引用对应帧。

## 命名规则

| 用途 | 名称 |
|---|---|
| 基础待机 | `idle` |
| 普通／首次掏出 | `raise` / `raise_first` |
| 收起／空仓收起 | `drop` / `drop_empty` |
| 进入／退出瞄准 | `ads_up` / `ads_down` |
| 瞄准射击 | `fire_ads` |
| 瞄准最后一发 | `fire_last_ads` |
| 瞄准拉栓 | `fire_rechamber_ads` |
| 带补偿器的瞄准空仓换弹 | `reload_empty_barcomp_ads` |
| 切到半自动／全自动 | `selectsemi_on` / `selectsemi_off` |

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

## 命名与导出检查

1. 检查 Blender Action 与 NLA 引用，每个需要导出的动作使用唯一名称。
2. 导出动画库后，核对 GLB 中的实际剪辑名。
3. 对齐控制器、动作机、配对瞄准动作、配件动画覆盖与事件状态键。
4. 验证普通／首次掏枪、腰射／瞄准开火、所有换弹变体、冲刺和待机交接。

## 默认包 17 把枪的 GLB 清单

默认包的 17 把枪在各自的动画库中合计有 654 段剪辑，按枪分别计数。两款双持各有 48 段，名称相同，在此合并列出。展开枪械条目即可查看控制器能引用的剪辑名。

### M4 — 45

`m4`

<details>
<summary>展开剪辑名</summary>

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

</details>

### RM277 — 46

`rm277`

<details>
<summary>展开剪辑名</summary>

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

</details>

### M590A1 — 45

`m590a1`

<details>
<summary>展开剪辑名</summary>

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

</details>

### CheyTac M200 — 36

`cheytac_m200`

<details>
<summary>展开剪辑名</summary>

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

</details>

### MG338 — 34

`mg338`

<details>
<summary>展开剪辑名</summary>

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

</details>

### Staccato 2011 P — 39

`staccato_2011_p`

<details>
<summary>展开剪辑名</summary>

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

</details>

### Staccato 2011 P 双持与沙漠之鹰双持 — 各 48 段

`staccato_2011_p_dual` 和 `desert_eagle_dual` 各自在本枪骨架上使用下面这些剪辑名。`reload_empty_left` 与 `reload_left_empty` 的选用条件见[双持手枪](./dual-wield.md)。

<details>
<summary>展开剪辑名</summary>

```text
drop
drop_left
drop_right
empty_left
empty_right
fire_last_left
fire_last_right
fire_left
fire_right
idle
idle_active
idle_left
idle_right
inspect
inspect_empty
inspect_empty_left
inspect_empty_right
inspect_left
inspect_left_empty
inspect_right
inspect_right_empty
melee_fatal_01
melee_hit_01
melee_hit_02
melee_hit_03
melee_miss_01
melee_miss_02
melee_miss_03
raise
raise_first
raise_first_left
raise_first_right
raise_left
raise_right
reload
reload_empty
reload_empty_left
reload_empty_right
reload_left
reload_left_empty
reload_right
reload_right_empty
sprint_in
sprint_loop
sprint_out
super_sprint_in
super_sprint_loop
super_sprint_out
```

</details>

### AK-103 — 40

`ak103`

<details>
<summary>展开剪辑名</summary>

```text
ads_down
ads_down_settle
ads_up
ads_up_additive
bullet_additive_30
drop
empty_additive
fire
fire_ads
fire_last
fire_last_ads
fire_settle
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

</details>

### AUG A3 — 39

`aug_a3`

<details>
<summary>展开剪辑名</summary>

```text
ads_down
ads_down_settle
ads_up
bullet_additive
drop
empty_additive
fire
fire_ads
fire_last
fire_last_ads
fire_settle
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

</details>

### 弩 — 27

`crossbow`

<details>
<summary>展开剪辑名</summary>

```text
ads_down
ads_down_settle
ads_up
drop
empty_additive
fire
fire_ads
fire_ads_scope
idle
idle_active
inspect
inspect_empty
melee_fatal_01
melee_hit_01
melee_hit_02
melee_miss_01
melee_miss_02
raise
raise_first
reload
reload_ads
sprint_in
sprint_loop
sprint_out
super_sprint_in
super_sprint_loop
super_sprint_out
```

</details>

### 沙漠之鹰 — 33

`desert_eagle`

<details>
<summary>展开剪辑名</summary>

```text
ads_down
ads_down_settle
ads_up
bullet_additive
drop
empty_additive
fire
fire_ads
fire_last
fire_last_ads
idle
idle_active
inspect
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
reload
reload_ads
reload_empty
reload_empty_ads
sprint_in
sprint_loop
sprint_out
super_sprint_in
super_sprint_loop
super_sprint_out
```

</details>

### GM6 Lynx — 33

`gm6_lynx`

<details>
<summary>展开剪辑名</summary>

```text
ads_down
ads_down_settle
ads_up
bullet_additive
drop
fire
fire_ads
fire_last
fire_last_ads
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
super_sprint_loop
super_sprint_out
```

</details>

### Milkor MGL — 30

`milkor_mgl`

<details>
<summary>展开剪辑名</summary>

```text
ads_down
ads_down_settle
ads_up
drop
fire
fire_ads
fire_last
fire_last_ads
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
reload_empty
sprint_in
sprint_loop
sprint_out
super_sprint_in
super_sprint_loop
super_sprint_out
```

</details>

### MP7 — 39

`mp7`

<details>
<summary>展开剪辑名</summary>

```text
ads_down
ads_down_settle
ads_up
ads_up_additive
bullet_additive_40
drop
empty_additive
fire
fire_ads
fire_last_ads
fire_settle
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

</details>

### Superi 46 — 38

`superi_46`

<details>
<summary>展开剪辑名</summary>

```text
ads_down
ads_down_settle
ads_up
bullet_additive_30rnd
drop
empty_additive
fire
fire_ads
fire_last
fire_last_ads
fire_settle
idle
idle_active
inspect
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

</details>

### Vepr-12 — 34

`vepr_12`

<details>
<summary>展开剪辑名</summary>

```text
ads_down
ads_down_settle
ads_up
bullet_additive
drop
empty_additive
fire
fire_ads
fire_last
fire_last_ads
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
super_sprint_loop
super_sprint_out
```

</details>
