---
title: 内容包参数作用参考
category:
  - 内容包制作
---

本页按文件位置解释常用及动画相关参数。表中的默认值来自 **Lua 动画机 API 1 对应的开发版加载器**，不是默认内容包的调校值。必填字段需自己提供；“—”表示无统一值或可选引用。字段未列出时不要猜拼写，继续查对应专题。

逻辑 JSON 控制伤害、射速、弹药与服务端判定；render JSON 控制资源、材质与显示。采用 [Lua 动画机](lua-animation.md) 后，七组动画配置移入 Lua `config`，其内部字段意义不变。`animation_fps`、机械提交、资源引用仍留在 JSON。

**时间单位不要混用：** `_ms` 是毫秒，`_ticks` 是游戏 tick，`_frame` 按 `animation_fps` 换算，`fade_in/out` 是秒。响应/阻尼系数不是时长。正常 20TPS 时 1 tick=50ms，`帧 / FPS × 1000` 得到毫秒。

## 枪械逻辑 JSON

| 参数 | 类型/单位 | 默认/限制 | 作用及调整影响 |
|---|---|---|---|
| `id` | ID | 必填 / required | 内容 ID；使用自己的命名空间，在包内唯一。 |
| `display_name` | string | 必填 / required | 显示名；语言文件可提供翻译。 |
| `render` | path | — | 相对包根目录的渲染 JSON 路径；不是 assets 资源 ID。 |
| `creative_category` | enum | assault_rifle / melee | 创造栏与改装界面分类；取值见枪械教程。 |
| `creative_sort / creative_hidden` | integer / bool | 0 / false | 排序（小值在前）/是否隐藏创造栏条目。 |
| `model_data` | integer | 0 | 物品模型选择编号；不要与包中其他武器重复。 |
| `magazine_size` | rounds | 30; 1..1000 | 基础弹量容量；逐发装填要求 tube_capacity + chamber_capacity 等于此值。 |
| `damage` | damage points | 8; 0.1..1000 | 基础伤害；Minecraft 2 伤害点为 1 颗心，后续还受弹药、距离与命中部位修正。 |
| `projectiles_per_shot` | integer | 1; 1..64 | 每次成功射击生成的弹丸数，例如霰弹；不是一次扣多发弹药。 |
| `range` | blocks | 96; 1..512 | 基础有效射程参数；弹药可乘倍率，还受弹丸寿命与弹道约束。 |
| `fire_modes` | array | 枪械必填 / required for firearms | semi、auto、burst、charge；决定输入与射击调度方式。 |
| `burst_count / burst_interval_ticks` | rounds / ticks | 3 / 2 | 点射轮数。burst_interval_ticks 当前仅解析保留，未被新调度器读取；实际轮内间隔由 mechanics.fire_interval_ms 控制，勿靠此字段调射速。 |
| `charge_min_ticks / charge_max_ticks` | ticks | 8 / 30 | 蓄力最短/达到最大蓄力的时间，仅蓄力模式相关。 |
| `charge_damage_bonus` | damage points | 15 | 蓄力伤害增量参数；不改变普通射击动画长度。 |
| `ammo.default` | ID | — | 默认弹种，并自动加入精确接受列表。 |
| `ammo.accepted / ammo.accepted_families` | ID arrays | [] | 接受特定弹种/接受整个口径族；family 不是显示名称。 |
| `mechanics.rpm` | rounds/min | 850; 1..3000 | 整数射速元数据，与 fire_interval_ms 对应。 |
| `mechanics.fire_interval_ms` | ms | round(60000/rpm); 1..5000 | 真正开火间隔；与 rpm 换算差超过 1ms 会被拒绝。沙鹰 167/360，Staccato 462/130。 |
| `mechanics.action_commit_ms.<动作/action>` | ms | 0..60000 | 普通有限动作的机械提交时刻，例如换弹真正更新弹量；不等于声音帧或动画总长。 |
| `inaccuracy.stand / move / sneak / lie / aim` | spread coefficient | 5 / 5.75 / 3.5 / 2.5 / .15 | 站立、移动、蹲伏、趴伏、完全瞄准散布。值越大越散；不是角度或后坐力，每发选一个姿态而非五项相乘。 |
| `ballistics.muzzle_velocity` | blocks/s | 500; 1..4000 | 枪口初速；提高会缩短飞行时间。 |
| `ballistics.gravity` | blocks/s² | 9.8; 0..200 | 弹丸下坠加速度；0 表示不施加此下坠。 |
| `ballistics.drag / water_drag` | coefficients | .015 / .60 | 空气/水中阻力；越大速度损失越明显。 |
| `ballistics.life_seconds` | s | 2.5; .05..60 | 弹丸最长存活时间；不是枪械动画时间。 |
| `ballistics.hitbox_inflation` | blocks | .12; 0..1 | 命中检测扩大实体包围盒的尺寸。 |
| `ballistics.headshot_multiplier / headshot_height_fraction` | multiplier / fraction | 1.5 / .25 | 爆头倍率/头部判定高度比例；头部比例不要当作伤害倍率。 |
| `ballistics.body_damage.chest / abdomen / arms / legs` | multipliers | 1 / .9 / .75 / .7 | 胸、腹、手臂、腿部命中倍率。 |
| `ballistics.damage_curve[]` | objects | [{distance:0,multiplier:1}] | 距离伤害曲线；distance 严格递增，multiplier 为倍率，可用 location_multipliers 设置部位曲线。 |
| `ballistics.penetration.max_entity_hits` | integer | 1; 1..16 | 单颗弹丸最多命中实体数量，1 不继续穿透实体；不是方块穿透开关。 |
| `ballistics.penetration.speed_retention / damage_retention` | fractions | .72 / .70 | 每次实体穿透后保留的速度/伤害比例。 |

## 弹药 JSON：bullets/*.json

| 参数 | 类型/单位 | 默认/限制 | 作用及调整影响 |
|---|---|---|---|
| `family` | ID | 自身 ID / ammo ID | 口径族，供 accepted_families 匹配。 |
| `icon_model_data / max_stack_size / rounds_per_item` | integers | 0 / 64 / 1 | 物品模型编号/堆叠上限/每件物品代表的弹药数。 |
| `damage_multiplier / velocity_multiplier / range_multiplier / inaccuracy_multiplier` | multipliers | 1 | 分别修正武器伤害、初速、射程、散布；散布倍率越小越准。 |
| `armor_penetration` | fraction | 0; 0..1 | 护甲穿透参数；不等于连续穿透实体数量。 |
| `ballistics.gravity_multiplier / drag_multiplier / water_drag_multiplier` | multipliers | 1 | 弹种对武器弹道参数的乘数。 |
| `ballistics.headshot_multiplier` | multiplier | 1 | 弹种对爆头倍率的进一步修正。 |
| `ballistics.max_entity_hits` | integer | 0; 0..16 | 0 继承枪械，正数替换枪械穿透数量。 |
| `ballistics.speed_retention_multiplier / damage_retention_multiplier` | multipliers | 1 | 进一步修正穿透后的速度/伤害保留比例。 |
| `tracer.count_interval` | integer | 0; -1..127 | -1 禁用弹种尾迹，0 每发，正数每 (count_interval+1) 发显示一次；还受枪的 bullet_tracer.enabled 控制。 |
| `tracer.color` | color | #FFFFEBA0 | 支持 #RRGGBB / #AARRGGBB。 |
| `tracer.size_multiplier / length_multiplier` | multipliers | 1 / 1 | 尾迹粗细/长度；不改变命中或弹速。 |
| `models.cartridge / casing / projectile` | model objects | 可选 / optional | 完整未击发弹/击发弹壳/飞行弹丸模型；每项包含 model、材质和 scale。 |
| `inspection_module` | string | 空 / empty | 检视资源关联的模块标识；不是可安装弹壳配件。 |

## 资源、材质与显示变换（render JSON）

| 参数 | 类型/单位 | 默认/限制 | 作用及调整影响 |
|---|---|---|---|
| `gltf_model / animation_sources` | ID / ID array | — / [] | 机匣模型/动画库；example:foo 指 assets/example/foo。 |
| `texture / normal / specular / roughness / metallic / emissive` | resource IDs | 可选 / optional | 基础色、法线、高光、粗糙度、金属度、发光贴图；Iris 通道含义还取决于光影包。 |
| `specular_strength / roughness_value / metallic_value / emissive_strength` | numbers | 枪/gun: .35 / .55 / 0 / 0 | 材质强度或缺少对应贴图时的常量；粗糙度越低越光滑。弹药默认为 .35/.45/.8/0，不能混用默认值。 |
| `icon_texture / hud.weapon_icon` | IDs | — | 物品图标/武器 HUD 图标。 |
| `coordinate_system / model_forward_axis` | enums | blender_gun / x | 资源坐标约定/前向轴；blender_gun 要求 +X，普通 blender 要求水平轴。 |
| `gltf_scale / gltf_translation / gltf_rotation` | number / XYZ / XYZ | 1 / [0,0,0] / [0,0,0] | 模型整体换算和变换；rotation 为度。修模型单位用 gltf_scale，别只改某个展示场景。 |
| `first_person / ground / fixed / modify_screen / sprinting` | transform objects | 按场景 / scene-specific | 第一人称/掉落物/展示框/改装界面/程序化奔跑的基础变换。 |
| `TRANSFORM.translation / rotation / scale` | XYZ / degrees / multiplier | 通常/usually 0 / 0 / 1 | 在该场景参考空间内移动/旋转/缩放；XYZ 可用数组或 x/y/z 对象。 |
| `TRANSFORM.anchor_node / camera_node / use_camera_transform` | names / bool | 按场景 / scene-specific | 定位参考节点、相机节点以及是否使用相机变换；必须是模型实际名称。 |
| `modify_screen.camera / modify_screen.ammo` | objects | 见专页 / see guide | 改装镜头预设与子弹预览偏移；详细子项见配置示例页。 |
| `first_person_arms / arms.enabled / arms.model` | bool / bool / ID | false / true / — | 启用独立第一人称手臂/手臂总开关/手臂模型资源。 |
| `arms.left_holder_bone / right_holder_bone` | bone names | LEFT_ARM / RIGHT_ARM | 左右手附着参考骨。 |
| `arms.poses.<状态/state>` | object | — | 该动作的左右 holder、action_follow_bone 与 blend_ticks；blend_ticks 用 tick，不是秒。 |
| `camera.enabled / model_fov` | bool / degrees | true / 70 | 相机配置开关/第一人称枪模 FOV。 |
| `camera.aim_fov_multiplier / aim_sensitivity_multiplier / aim_transition_speed` | multipliers / response | 1 / .72 / 2 | 瞄准 FOV、鼠标灵敏度及过渡响应；响应不是固定秒数。 |
| `camera.camera_position_scale / camera_position_max` | numbers | 0 / 16 | 动画相机位移缩放/限制；0 缩放会关闭该位移贡献。 |
| `offhand_stowed.enabled / translation / rotation / model_roll / scale` | bool / XYZ / degrees / degrees / multiplier | true / [0,.38,.16] / [0,0,50] / 0 / 1 | 副手背负显示和姿态；model_roll 单独控制模型滚转。 |
| `offhand_stowed.max_render_distance / cast_shadow` | blocks / bool | 48 / true | 背负显示距离/是否投影。 |
| `third_person_pose.enabled / raise_speed / lower_speed / shoot_hold_ticks / sprint_lower_weight` | bool / responses / ticks / fraction | false / .22 / .16 / 60 / 1 | 第三人称抬枪、放下、射后保持和奔跑降枪程度。 |
| `third_person_pose.right_arm / left_arm / gun` | objects | — | 双臂 lowered_rotation/raised_rotation 与枪 lowered/raised 显示变换。 |
| `aim_reference.enabled / align_node / focus_node` | bool / node names | true / tag_align_gun / tag_weapon_focus | 瞄准参考节点；影响对齐而非伤害。 |
| `canted_aim.enabled / pose_node / pivot_node / translation / rotation` | bool / names / XYZ / degrees | false / tag_ads / tag_ads / [0,0,0] / [-42,0,0] | 侧瞄开关、参考点、旋转轴点及侧瞄偏移。 |
| `canted_aim.response / damping / fov_multiplier` | numbers | 18 / 1 / 1 | 侧瞄弹簧响应、阻尼与 FOV 倍率。 |

## 后坐力与鼠标摆动

| 参数 | 类型/单位 | 默认/限制 | 作用及调整影响 |
|---|---|---|---|
| `recoil.enabled / auto_recovery` | bools | true / true | 启用程序化后坐力/自动回正；与 GLB 射击动作独立。 |
| `recoil.blend_start / blend_end / blend_curve` | fractions / enum | .15 / .95 / smoothstep | 腰射到瞄准配置的混合区间与曲线；end 必须大于 start，可用 linear。 |
| `recoil.recovery_delay_ms / recovery_duration_ms` | ms | 按射速推导 / 0 | 停止射击后的回正延迟/可选回正时长；0 时长使用现有弹簧恢复。 |
| `recoil.hip / recoil.ads` | objects | 各自基础配置 / distinct base profiles | 分别控制腰射和瞄准；下列参数在两者中均可填写。 |
| `<recoil profile>.vertical / horizontal / model_back / randomness` | multipliers | 1 | 上下后坐/左右随机后坐/枪模后退/随机量倍率，不是直接厘米或角度。 |
| `<recoil profile>.recovery` | multiplier | 1; .1..4 | 恢复强度；同时改变弹簧刚度、阻尼和相机控制响应。 |
| `<recoil profile>.model_pitch_degrees / sustained_vertical_fraction` | degrees / fraction | 0 / .35 | 附加模型俯仰/持续竖向贡献比例。 |
| `weapon_sway.enabled / hip / ads` | bool / objects | true | 鼠标转动造成的枪械摆动开关与腰射/瞄准配置。 |
| `<sway profile>.input_gain / deadzone / max_angle` | gain / degrees / degrees | hip:9/.18/5.5; ads:4/.06/1.2 | 输入强度/不响应范围/最大摆角；max_angle 必须不小于 deadzone。 |
| `<sway profile>.stiffness / damping / edge_damping` | spring coefficients | hip:64/15/8; ads:80/18/10 | 回中心刚度/整体阻尼/到边界的附加阻尼；越高不一定越平滑。 |
| `<sway profile>.location_gain / roll_gain` | multipliers | hip:.09/.45; ads:.06/.35 | 摆动附带的位置和滚转响应。 |

## 配件与弹量槽位

| 参数 | 类型/单位 | 默认/限制 | 作用及调整影响 |
|---|---|---|---|
| `modules` | map | {} | 主枪可用配件集合；值可引用配件行为 JSON，加载器再合并其 render。 |
| `type / slot / anchor_node` | strings | 按类型 / type-dependent | 配件类型、占用槽和安装节点；安装点不是激光或枪口发射点。 |
| `default_installed / embedded / exclusive_slot` | bools | true / false / true | 默认装上/嵌入部件/独占槽位；非默认可选配件应明确写 false。 |
| `depends_on / conflicts_with / parent_slots / parent_types` | arrays | [] | 依赖、冲突与允许安装的父级槽/类型；不是文件路径。 |
| `properties.set / add / multiply` | numeric maps | {} | 替换/加值/乘倍率；使用可识别属性名如 capacity，不可添加任意新逻辑。 |
| `states.translation / rotation / scale` | XYZ / degrees / multiplier | [0,0,0] / [0,0,0] / 1 | 配件安装后的局部显示变换。 |
| `event_actions` | command map | {} | 配件事件的表现命令；帧使用枪的 animation_fps。 |
| `ammo_slots` | object | 见实际骨架 / match rig | 区分弹匣内弹、膛内弹与替换弹匣；相关根骨不能用宽遮罩混在一起。 |
| `ammo_slots.fill_order` | enum | 按骨架 / rig-dependent | ascending/descending 决定槽位填充顺序；沙鹰用 ascending，不能照抄其他枪。 |
| `ammo_slots.chamber_nodes / magazine_in_gun_nodes / expected_slots` | names / integer | 按骨架 / rig-dependent | 膛内弹节点、在枪上的弹匣节点分类与预期槽数；必须核对实际名称。 |
| `gun_bone_visibility.when_slot_empty / when_slot_occupied` | rule maps | {} | 按安装槽为空/被占用执行 show/hide，例如安装瞄具后隐藏原机瞄。 |
| `transparent_nodes.<节点/node>.alpha / depth_write / depth_test / double_sided` | number / bools | .3 / false / true / true | 透明度、深度写入、深度检测、双面渲染；只作用于指定独立节点。 |
| `transparent_nodes.<节点/node>.texture / emissive / emissive_strength` | IDs / number | — / — / 1 | 指定透明节点的独立材质与发光强度。 |

## 特效、声音与近战

| 参数 | 类型/单位 | 默认/限制 | 作用及调整影响 |
|---|---|---|---|
| `sound_events.fire / fire_ads / fire_auto / fire_auto_ads / fire_last / fire_last_ads / fire_interrupt / dry_fire / dry_fire_ads` | sound IDs | — | 对应射击情形的声音事件 ID；引用 sounds.json 事件，不是直接写 OGG 文件路径。 |
| `sound_events.remote_overrides` | ID map | {} | 本地声音事件到远处玩家声音事件的替换映射。 |
| `bullet_tracer.enabled / size_multiplier / length_multiplier / color` | bool / numbers / color | true / 1 / 1 / — | 枪械尾迹总开关与外观；弹种另有 tracer 设置。 |
| `shell_effect.enabled / eject_on_fire / anchor_bone` | bools / bone | true / true / — | 抛壳开关、射击时自动抛壳和实际抛壳参考骨；拉栓/泵动要匹配机械时刻。 |
| `shell_effect.life_seconds / gravity / velocity` | s / acceleration / XYZ | .5 / 18 / [6,0,0] | 弹壳存活、下坠和速度配置；与真正弹丸弹道分开。 |
| `shell_effect.front / up / up_random_deg / front_random_deg` | degrees | 15 / 25 / 20 / 5 | 抛壳方向基准角与随机偏差。 |
| `shell_effect.shell_velocity / velocity_random` | speed / fraction | 6 / .2 | 弹壳速度与随机幅度。 |
| `shell_effect.rotate_pitch_random_offset / rotate_yaw_random_offset` | degrees | 10 / 90 | 初始俯仰/偏航随机角度。 |
| `shell_effect.rotate_pitch_speed / rotate_yaw_speed` | degrees/s | 360 / 3600 | 弹壳旋转速度。 |
| `shell_effect.rotate_pitch_speed_random / rotate_yaw_speed_random` | fractions | .8 / .25 | 上述旋转速度的随机幅度。 |
| `link_effect.source_bone / anchor_bone / direction_anchor_bone / translation` | bones / XYZ | — | 弹链连接件源节点、抛出点、方向点与偏移；其他运动字段沿用 shell_effect，缺少可渲染源模型会拒绝加载。 |
| `muzzle_flash.enabled / muzzle_smoke.enabled` | bools | true / true | 火焰/烟雾分别开关。 |
| `muzzle_flash.scale / flame_scale / flame_alpha / flame_particles / flame_speed` | numbers | 2 / 1 / .9 / 4 / .075 | 整体尺寸、火焰尺寸、透明度、粒子数和速度；粒子多会增加表现负担。 |
| `muzzle_flash.flame_front_texture / flame_side_texture / flame_columns / flame_rows / flame_frames / flame_fps / flame_duration_ms` | IDs / integers / FPS / ms | — / — / 4 / 2 / 8 / 160 / 50 | 火焰前视/侧视序列图与网格、帧数、播放速度、寿命；frames 不应超过图集容量。 |
| `muzzle_flash.layers[]` | objects | [] | 自定义多层火焰：name/type/texture、columns/rows/frames/fps、start_ms/duration_ms、width/length/offset、planes、random_roll/frame_blend/random_frame、chance/alpha/lod_tier/color。分别控制类型、序列、时序、形状、随机与裁剪。 |
| `muzzle_flash.light.intensity / radius / duration_ms` | number / blocks / ms | 2.5 / 4.5 / 100 | 枪口瞬时亮度、范围与持续时间。 |
| `muzzle_flash.lod.full_distance / medium_distance / max_distance` | blocks | 12 / 32 / 64 | 距离细节等级与最远显示距离，后值不得小于前值。 |
| `muzzle_smoke.smoke_particles / smoke_speed / spread / smoke_scale / smoke_alpha` | numbers | 3 / .028 / .018 / 1 / 1 | 烟雾数量、速度、散布、尺寸与透明度。 |
| `muzzle_smoke.smoke_puff_* / smoke_sustained_*` | sequence settings | 见说明 / see notes | 单发烟/连续烟的 texture、columns、rows、frames、fps、duration_ms；sustained_shots 则是进入连续烟的发数阈值。 |
| `muzzle_smoke.smoke_density_per_shot / smoke_max_density / smoke_sustained_shots / smoke_render_scale / smoke_max_particles_first_person / smoke_drag / smoke_buoyancy` | numbers | .28 / 1 / 3 / 3.5 / 8 / 2.8 / .16 | 每发增加烟密度、密度上限、连续阈值、尺寸、第一人称数量上限、阻力和浮升。 |
| `melee.enabled / damage / range / angle / knockback` | bool / damage / blocks / degrees / number | false / 2 / 2 / 30 / .5 | 近战启用、基础伤害、距离、攻击角和击退。 |
| `melee.duration / chain_open` | s | 1.3 / duration | 通用近战动作时长和连击开放时刻；chain_open 不早于命中也不晚于结束。 |
| `melee.combos.primary / heavy / sprint` | combo objects | 独立近战需 primary / melee requires primary | 普通/重击/奔跑攻击组。 |
| `COMBO.mode / reset_ms / attacks[]` | enum / ms / array | ordered / 700 / 必填-required | 按序或 random 选攻击；超时重置；每个攻击单独填写时序。 |
| `ATTACK.animation / duration_ms / commit_ms / chain_open_ms` | name / ms | 必填-required / 650 / 190 / duration_ms | 剪辑、持续、命中提交与连击开放；commit <= chain_open <= duration。 |
| `ATTACK.damage_multiplier / range_multiplier / angle_multiplier / knockback_multiplier` | multipliers | 1 | 这次攻击对近战基础参数的倍率。 |

## 动画、换弹与更多专题

动画通道、姿态层、分支、序列、事件与打断的逐字段解释见 [Lua 动画机](lua-animation.md)。逐发换弹的 `reload_system.clips/events/frame_lengths` 见 [动画规范](animation.md)，开火恢复与新旧弹匣命令见 [射击与换弹](firing-reload.md)。

瞄具倍率、光学节点、激光归零见 [配件与瞄具](attachments-optics.md)；改装镜头/子弹预览、挂饰物理见 [配置示例](config-examples.md)；工作台配方见 [枪械工作台](gunsmith-workbench.md)。

### 调参顺序

1. 模型单位和挂点正确后再调显示变换。
2. 先确定机械射速/提交时刻，再调动画时长、声音帧和淡入淡出。
3. 弹量错误同时核对膛内、弹匣内、替换弹匣、fill_order、采样与遮罩。
4. 材质先验证基础色，再检查普通渲染与 Iris 光影；贴图通道解释要匹配光影包。
5. 不要通过放慢射速来掩盖动画打断问题；合法下一发可以在上一发恢复尚未结束时重播。
