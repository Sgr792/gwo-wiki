---
title: Lua 动画机与参数
category:
  - 内容包制作
---

## 适用版本与职责

本页对应 **Lua 动画机 API 1**，接入日期为 2026-09-30。需使用包含此接口的模组构建；只看 `2.12.87` 版本号不能判断旧 JAR 是否已有 Lua。旧 JSON 动画机仍有兼容解析，新版默认包与科幻包使用 Lua。

Lua 负责选动作、分支、时间线、打断、奔跑阶段选片及弹量采样。Java 负责 GLB 骨骼求值、蒙皮和渲染，并执行既有机械判定。伤害、射速、扣弹、换弹真正提交仍在逻辑 JSON 与服务端。改变动画长度不会自动改变机械射速。

## 把动画机放进同一个内容包

```text
weapons/firearms/example_rifle.json
weapons/firearms/render/example_rifle.render.json
assets/example/scripts/default_machine.lua
assets/example/scripts/weapons/example_rifle.lua
assets/example/gltf/animations/example_rifle_receiver_default.anim.glb
```

render JSON 增加：

```json
{
  "state_machine": "example:weapons/example_rifle",
  "animation_fps": 30
}
```

这是合并片段，保留模型、贴图、挂点等其他字段。资源 ID `example:weapons/example_rifle` 解析为 `assets/example/scripts/weapons/example_rifle.lua`，不写 `.lua` 后缀。

下载 [共享默认策略](/downloads/examples/default_machine.lua)，保存为上述 `default_machine.lua`；下载 [单枪教学脚本](/downloads/examples/example_machine.lua)，保存为 `weapons/example_rifle.lua`。后者的 `require("example:default_machine")` 只读取当前包，不搜索别的内容包。改命名空间时同步改目录、`state_machine` 和 require。普通文件夹与标准 ZIP 均可使用。

教学时长不是通用调校值，脚本没有模型、声音和动画资产。提供其中全部真实剪辑，并同步配置机械提交、音效与遮罩后才能进游戏验证。

## 哪些字段移入 Lua

| Lua `config` 字段 | 作用 |
|---|---|
| `animation_machine` | 动作、分支、序列、事件、打断声明 |
| `animation_controller` | 剪辑通道、时长、层、遮罩、参考空间 |
| `pose_graph` | 基础与叠加层的组合、条件和权重 |
| `animation_events` | 将可派发状态归类到已支持的逻辑事件 |
| `paired_aim_actions` | 腰射动作到瞄准动作的同时间配对 |
| `animation_clips` | 兼容剪辑别名；新默认包使用真实短名称，不必新建别名表 |
| `animation_commands` | 动画帧上的声音、弹匣角色与表现命令 |

这七组字段由 Lua 提供时，render JSON 不能再重复定义。`animation_fps`、`fire_animation`、`reload_system`、`reload_phases`、机械参数和资源引用仍保留原位置。不要把 `damage` 或 `mechanics` 塞进 Lua config，加载器会拒绝。

Lua 用 `array { ... }` 表示配置数组，尤其空数组必须用 `array {}`，不能写成空对象。数据表最后通过以下方式返回：

```lua
local default = require("example:default_machine")
local config = {
    animation_machine = {version = 2, actions = {}, interrupts = array {}},
    animation_controller = {channels = {}}
}
local machine = default.new(config)
return machine
```

这是接口结构示意；完整单枪起点使用下载脚本。

## 动作、分支、序列与打断参数

以下均在 `config.animation_machine` 内。API 版本 1 与数据结构 `version=2` 是不同概念。

| 参数 | 作用、单位与约束 |
|---|---|
| `version` | 当前数据结构为 2 |
| `actions.<动作>.type` | finite、continuous、per_round；应与已注册逻辑动作类型一致 |
| `default_state` | 有限动作的默认剪辑状态；使用真实已声明通道名 |
| `phase_states` | continuous 至少声明 enter/loop/exit；sprint 可加 super_enter/super_loop/super_exit |
| `state_phases` | 将具体状态映射到 enter/action/exit/loop 阶段，用于运行时判断 |
| `variants[]` | 根据状态选择剪辑；每项 state、when、priority、transition |
| `when` | 字符串状态条件。支持 true/false 字符串、`*`（非空）、`!`（缺失/空）、`!值`、用 &#124; 分隔的候选，以及 `>=2` 等数值比较 |
| `priority` | 默认 0；高优先级先匹配，同优先级先选条件更具体者，再按声明顺序 |
| `transition` | 过渡秒数，不是毫秒；数据配置范围 0..1 |
| `sequences[]` | 条件与优先级选定一组 steps；默认策略按步骤时长依次编排 |
| `steps[].state / marker / phase` | 剪辑状态/事件定位标记/enter、action、exit 或 loop；marker 不是骨骼名 |
| `events[].type` | 已支持 shot_effects、fire_sound、recoil；不是任意 Java 命令或伤害脚本 |
| `events[].marker / offset_ms / when` | 在标记开始时间之后偏移指定毫秒，按条件派发表现事件；offset_ms 为 0..60000 |
| `interrupts[].active / incoming` | 当前与新动作匹配表达式；声明中应引用已有动作 |
| `interrupts[].decision` | allow、interrupt、reject、queue、pause_resume；声明中的 default 表示继续默认策略，自定义函数最终必须返回明确决定 |
| `interrupts[].phases / min_progress / max_progress` | 限定阶段与 0..1 动作进度区间 |
| `interrupts[].priority / transition / reason` | 规则优先级、过渡秒数、必填说明；便于排查哪条规则起作用 |

逻辑动作名与剪辑名可以不同，例如 `raise` 动作播放 `raise` 剪辑、`aim` 动作播放 `ads_up`。动作 ID 必须是已注册 GWO 动作，不能靠新增任意 actions 键扩展玩法。

## 动画通道参数

路径：`config.animation_controller.channels.<状态>`。

| 参数 | 默认 | 作用 |
|---|---|---|
| `clip / layer` | 状态名 / action | 真实剪辑名/执行层，如 base、action、recoil、aim、sprint |
| `duration_frame / duration` | 0 / 0 | 总时长（帧/秒）；写帧时优先帧，按 JSON 的 animation_fps 换算；0 可依赖实际剪辑时长 |
| `speed` | 1 | 播放倍率；2 为两倍速度，必须同时核对事件和机械提交 |
| `fade_in / fade_out` | 0 / 0 | 淡入、淡出秒数；不能修复错误的骨架坐标或重复叠加 |
| `loop / keep_last_frame` | false / false | 循环/保持最后一帧；有限动作不要无意保持旧权重 |
| `bone_mask` | 空数组 | 限制该通道影响的骨骼；弹量层不要覆盖所有手臂和替换弹匣 |
| `lock_fire` | false | 动作期间锁射击配置；射击恢复段不要用它代替机械冷却 |
| `sample_frame / sample_time` | 0 / 0 | 静态姿态采样帧/秒，帧优先；不是动作提交时刻 |
| `state_conditions` | 空对象 | 通道生效的武器状态条件 |
| `suppress_aim_additive / suppress_empty_additive` | false / false | 播放时抑制对应瞄准/空仓附加层，避免重复作用 |
| `clip_start_time / clip_end_time` | 0 / -1 | 截取剪辑范围，单位秒；-1 末尾表示不主动限定 |
| `next_state` | 空字符串 | 当前状态结束后续接；射击恢复可接 fire_settle，不再次派发射击 |
| `blend` | 空字符串 | 通道可显式指定参考空间；空值沿用所在层的配置 |
| `follow_source_bone / follow_target_bones` | 空 / 空数组 | 将来源骨骼变化传递给目标骨骼，例如枪体动作带动 arms_root；需匹配真实骨架 |
| `preserve_ammo_pose` | false | 换弹动作期间保留当前弹量姿态至对应视觉提交；不改变真实弹量 |
| `recoil_arm_mode` | auto | 射击层手臂处理模式；沿用匹配武器的既有配置，不凭拼写猜新枚举 |

## 姿态层、配对和表现命令

| 参数 | 作用 |
|---|---|
| `pose_graph.base_clip / default_blend` | 基础剪辑/默认参考空间，默认 idle/override |
| `pose_graph.layer_profiles` | 可复用层配置；layer 的 profile 引用后，本层同名字段覆盖模板 |
| `layers.<层>.channel / channels` | 单通道或通道集合；缺省 channel 使用层名 |
| `enabled / priority` | 默认 true/0；层是否参与和组合顺序 |
| `bone_mask / exclude_bone_mask` | 允许/排除骨骼，先确定所有权再调权重 |
| `conditions` | 武器状态条件 |
| `action_progress_weight` | 四项进度/权重控制数据，使用 0..1000 的进度刻度；缺省 [0,0,1000,1000]，不是毫秒 |
| `weight_curve` | smoothstep 或 linear，决定权重插值 |
| `blend=override` | 将层姿态混合到当前结果 |
| `blend=additive` | 以当前基础参考姿态求增量 |
| `blend=bind_additive` | 以绑定姿态为参考求增量 |
| `blend=delta_additive` | 轨道已经是增量，直接叠加；不能把完整动作当成此类型 |
| `blend=clip_start_additive` | 以剪辑起始姿态为参考求增量 |
| `paired_aim_actions` | 将同时间腰射/瞄准动作配对，双版本需真实存在；切瞄准不重新开始换弹 |
| `animation_commands.<状态>[]` | 每项 frame 或 time，type、args、bone、sound 等；frame 优先，按 animation_fps，time 为秒 |
| 命令 `sound` | 在给定时刻播放 sound 事件 ID |
| 命令 `magazine_role` | 指定弹匣骨骼此后是 old/new 等表现角色；实际允许角色以现有实现为准 |
| 命令 `mask_mag_ammo` | 更新换弹表现的弹量遮罩；不代替服务端扣备弹/提交 |

已烘焙的完整奔跑动作不能再重复叠 idle/offset。缺失通道与显式恒定轨道也不是同一件事，Lua 无法修复错误导出的 GLB。

## 覆盖单枪函数

```lua
local original = machine.select
function machine.select(action, fallback, ctx)
    if action == "fire" and ctx.aiming == "true"
        and tonumber(ctx.ammo) == 1 then
        return {state = "fire_last_ads", transition = 0}
    end
    return original(action, fallback, ctx)
end
```

放在 `return machine` 前。该剪辑及通道必须存在。

| 函数 | 输入 | 返回 |
|---|---|---|
| select(action, fallback, ctx) | 动作、回退剪辑、状态表 | {state, transition} |
| plan(action, selected, ctx, duration) | 动作、已选状态、状态表、获取剪辑毫秒时长的函数 | {duration_ms, steps, events} |
| interrupt(ctx) | 当前/新动作上下文 | {decision, transition, priority, reason} |
| phase(action, phase, fallback) | 动作、阶段、回退剪辑 | 状态名字符串 |
| sample(kind, ammo, capacity, length, fps) | magazine/per_round、弹量、容量、剪辑秒数、帧率 | 采样秒数 |

select/plan 的 ctx 值是字符串：ammo、capacity、empty、last_round、aiming、charged、chamber_loaded、cycle_required、per_round、fire_mode、requested_state；plan 另有 selected_state。真实物品的 select 还可读取 moving、crouching、airborne、sprinting、super_sprinting、pose 与模块扩展状态。用 tonumber 转数值，不要把 `"false"` 当 Lua 布尔 false。

interrupt 的 ctx 有 active/incoming、active_state/incoming_state、active_group/incoming_group、active_family/incoming_family、incoming_finite、phase、progress、melee_enabled、chain_open_progress。其中 progress 是 0..1 数字、incoming_finite 是布尔。plan 返回的步骤为 {state, marker, phase, time_ms, duration_ms}、事件为 {type,time_ms}，时间必须是非负整数、步骤时长为正；不超过时间线，按时间排列，最多各 128 项。

共享默认 sample 对弹匣使用 `length × clamp(capacity-ammo,0,capacity)/capacity`。逐发弹量姿态非空时采第 0 秒，空时采末尾前 1 帧。它只改变姿态；必须配合正确的槽位、膛内分类和遮罩。

## 重载、迁移与限制

修改后使用当前版本的内容包重载入口；不确定时重启客户端。配置重载会重新加载 Lua，不会把文件变化自动推送到服务器玩家。

旧 JSON 转换时，把七组动画数据改成 Lua table，数组用 array，删掉 render 重复字段，再增加 state_machine。保留动画资源和非动画参数。原有 [JSON 配置示例](config-examples.md)可用于理解字段，不能与 Lua config 重复合并。

每个武器定义共享一个 VM。函数应依据输入上下文决策；不要用全局变量保存单个玩家/物品的变化，目前没有独立实例存储 API。每次加载/调用最多 100 万条指令、最多 64 个导入、单脚本最多 100 万字符、配置深度最多 48 层。无文件、网络、Java、系统命令或调试接口；这些是常见错误限制，不是完整恶意脚本资源隔离。错误包含脚本路径/函数名，发布前必须试加载和进游戏。

数据/加载测试已经通过；帧率和所有武器视觉表现仍需实际游戏验收，不能承诺迁移到 Lua 会自动提升性能。
