---
title: 动画制作与导出规范
order: 3
category:
  - 内容包制作
---

## 8. 动画导出规范

本页主要介绍 GLB 骨骼制作路线；新增开发版的 Bedrock 数值动画和无 Skin Empty 刚性动画见 [Bedrock 与 Empty 动画](./bedrock-empty.md)。GWO 状态名、事件配置仍共用，但 Bedrock 轨道是相对初始姿态的变化，不应直接当作 GLB 局部变换使用。

### 8.1 模型与动画分离

推荐：

- `*_receiver_default.glb`：模型、骨架、蒙皮，不包含动作库。
- `*_receiver_default.anim.glb`：动画库，不包含可见枪械网格。
- `arms.glb`：独立手臂模型。

渲染配置：

```json
{
  "gltf_model": "example:gltf/guns/example_rifle/example_rifle_receiver_default.glb",
  "animation_sources": [
    "example:gltf/animations/example_rifle_receiver_default.anim.glb"
  ],
  "first_person_arms": true,
  "arms": {
    "model": "example:gltf/arms/arms.glb"
  }
}
```

动画库和模型必须拥有能互相匹配的骨骼名称。不能把一个动画内属于不同 skin 的关节错误合成同一 skin；看到 `applies to joints that are not from the same skin` 时，应回 Blender 修复骨架所有权或导出脚本映射。

### 8.2 动画可以从第 0 帧开始

动画和事件统一支持从第 0 帧开始。声音、射击、弹匣可见性等事件均可写在第 0 帧。

### 8.3 基础动画命名

普通弹匣式枪械常用：

```text
static_idle
draw
draw_first
holster
aim_in
aim_out
fire_pre
fire
aim_fire
fire_last
fire_last_ads
dry_fire
aim_dry_fire
reload
reload_empty
aim_reload
aim_reload_empty
inspect
inspect_empty
sprint_in / sprint_loop / sprint_out
super_sprint_in / super_sprint_loop / super_sprint_out
empty_additive
bullet_additive
melee_miss_*
melee_hit_*
melee_fatal_*
```

管式霰弹枪通常还需要：

```text
fire_rechamber
aim_fire_rechamber
reload_start
reload_loop
reload_end
reload_empty_chamber_start
reload_empty_start
reload_empty_chamber_end
aim_reload_start
aim_reload_loop
aim_reload_end
aim_reload_empty_chamber_start
aim_reload_empty_start
aim_reload_empty_chamber_end
shell_additive_*
```

栓动狙击枪通常增加 `fire_rechamber` 和 `aim_fire_rechamber`。独立近战武器使用自己的动作集合，例如：

```text
static_idle
draw_first
holster
inspect
swipe_01 / swipe_02 / swipe_03
stab_01 / stab_02
sprint_in / sprint_loop / sprint_out
super_sprint_in / super_sprint_loop / super_sprint_out
```

#### 动画状态与 GLB 剪辑不是一回事

`animation_clips` 左侧是 GWO 状态名，右侧才是 `.anim.glb` 内的实际剪辑名。例如：

```jsonc
"animation_clips": {
  "reload_xmaglrg": "reload_xmaglrg",
  "reload_drummag": "reload_drummag"
}
```

状态名必须在 `animation_controller`、`animation_machine` 和配件 `animation_override` 中一致声明；剪辑名可以不同，但必须真实存在。下表描述的是“状态用途”，同一状态可以映射到内容作者自己的剪辑名。

`xmaglrg` 和 `drummag` 不是同义词：`xmaglrg` 表示大型箱式扩容弹匣，`drummag` 表示鼓式弹匣。运行时允许状态映射到不同剪辑名，但新内容如果同时拥有这两套动作，必须保留两组独立状态，不能把鼓式弹匣全部塞进 `*_xmaglrg` 分支。

#### `animation_events` 只声明可派发动作

`animation_events` 把动画状态归类到运行时动作通道，例如 `fire`、`reload`、`inspect`、`aim`、`sprint` 和 `melee`。显式映射仍是当前格式，可以保留；它不是废弃配置。

不要把 `static_idle`、`bullet_additive`、`empty_additive`、`aim_additive`、`aim_up_additive` 或 `shell_additive_*` 写进 `animation_events`。这些是基础姿态或附加姿态层，不是可派发事件，应只出现在 `animation_clips`、控制器或姿态图中。事件值必须是 GWO 支持的逻辑事件，不能简单复制任意剪辑名。

状态名与剪辑名相同时，`"fire": "fire"` 之类的 `animation_clips` 映射依然合法，也可以作为内容包的显式能力声明；不要仅因左右名称相同就当作旧兼容字段删除。

#### 基础、装备与展示动画

| 状态 | 触发时机与作用 | 与相近状态的区别 |
|---|---|---|
| `static_idle` | 第一人称正常持有时的稳定基础姿态，也是多数完整动作的交接基准 | 不是展示框姿态，也不应包含空仓、弹量或射击模式状态 |
| `draw` | 普通装备、切回或再次拿出武器 | 每次普通装备可播放；不同于只在首次装备使用的 `draw_first` |
| `draw_first` | 该武器实例在当前客户端会话中第一次成功装备 | 可选；成功开始后才记为已播放，预览与预热不消耗它 |
| `holster` | 正常状态收起武器 | 从正常持有姿态离开画面 |
| `holster_empty` | 空仓状态收起武器 | 仅在空仓机构姿态与普通状态不同且配置了分支时需要 |
| `ground_idle` | 地面掉落物使用的静态/循环状态别名 | 不参与第一人称持枪状态机；通常可映射到简单 `idle` 剪辑 |
| `third_person_idle` | 第三人称持有展示使用的状态别名 | 不替代 `third_person_pose` 的位置配置，也不参与第一人称动作 |

#### 瞄准、射击与枪机循环

| 状态 | 触发时机与作用 | 与相近状态的区别 |
|---|---|---|
| `aim_in` | 从腰射进入普通瞄准 | 只负责进入过程；尾帧是瞄准基准 |
| `aim_out` | 从普通瞄准退出到腰射 | 是 `aim_in` 的反向交接，不应简单跳回 idle |
| `aim_down_settle` | 某些武器退出瞄准后的短暂稳定段 | 可选；不是 `aim_out` 的替代品，只处理退出后的余势 |
| `aim_additive` | GWO 使用的瞄准附加状态名 | 常映射到名为 `aim_up_additive` 的 GLB 剪辑，不需要再做一份同内容动画 |
| `aim_up_additive` | 常见的实际瞄准附加剪辑名，用于修正 `tag_weapon` | 是局部增量，不是完整瞄准姿态，不包含手臂和 `tag_ads` |
| `aim_idle` | 可选的瞄准保持循环 | 只有 `animation_machine.actions.aim.phase_states.loop` 明确引用时才使用；默认内容也可用 `static_idle` 加瞄准层保持 |
| `fire_pre` | 正式开火动作前的极短准备段 | 可选，必须在 fire sequence 中显式引用；不是枪口火焰或扣弹事件本身 |
| `fire` | 非瞄准普通射击动作 | 与 `aim_fire` 的区别是腰射参考姿态 |
| `aim_fire` | 普通瞄准状态射击动作 | 不应再次携带 `tag_ads`，否则会重复叠加瞄准偏移 |
| `fire_last` | 腰射打出弹匣/膛内最后一发 | 负责进入空仓机构姿态；不是普通 `fire` 的声音变体 |
| `fire_last_ads` | 瞄准状态打出最后一发 | 是 `fire_last` 的瞄准版本，不能用普通最后一发动作硬替 |
| `fire_settle` | 普通射击脉冲后的恢复/稳定段 | 不再次开火、不扣弹，只交回稳定姿态 |
| `fire_last_settle` | 最后一发动作后的恢复状态名 | 可以映射到 `fire_settle`，但交接目标必须保留空仓状态 |
| `dry_fire` | 腰射状态无弹空击 | 不生成弹丸、枪口效果或抛壳 |
| `aim_dry_fire` | 瞄准状态无弹空击 | 使用瞄准参考姿态，不能让枪瞬间回到腰射位置 |
| `fire_rechamber` | 腰射开火后进行泵动或拉栓 | 是独立机械循环，不等于开火后坐动画 |
| `aim_fire_rechamber` | 瞄准状态进行泵动或拉栓 | 必须从瞄准开火尾姿态开始，并回到瞄准持有姿态 |

#### 弹匣式换弹、检视与射击模式

| 状态 | 触发时机与作用 | 与相近状态的区别 |
|---|---|---|
| `reload` | 膛内仍有弹时的普通换弹 | 通常不需要拉机柄/释放套筒，提交时机与 `reload_empty` 不同 |
| `reload_empty` | 弹匣和膛内均空时换弹 | 包含必要的上膛或枪机释放动作 |
| `aim_reload` | 保持瞄准参考空间的普通换弹 | 不是把 `reload` 整体缩放；手和枪必须按瞄准姿态制作 |
| `aim_reload_empty` | 保持瞄准参考空间的空仓换弹 | 对应 `reload_empty`，同时保持瞄准层所有权 |
| `reload_xmaglrg` / `reload_empty_xmaglrg` | 大型箱式扩容弹匣的普通/空仓换弹 | 只用于 `xmaglrg`，不代表鼓式弹匣 |
| `aim_reload_xmaglrg` / `aim_reload_empty_xmaglrg` | 大型箱式扩容弹匣换弹的瞄准版本 | 时长、提交帧、声音和显隐必须独立配置 |
| `reload_drummag` / `reload_empty_drummag` | 鼓式弹匣的普通/空仓换弹 | 鼓体尺寸和握持方式不同，应与 `xmaglrg` 分开制作 |
| `aim_reload_drummag` / `aim_reload_empty_drummag` | 鼓式弹匣换弹的瞄准版本 | 必须保持瞄准参考空间，并使用鼓式弹匣自己的事件帧 |
| `inspect` | 非空仓检视 | 应显示当前真实弹量、弹匣和膛内弹状态 |
| `inspect_empty` | 空仓检视 | 使用真实空仓机构姿态 |
| `inspect_xmaglrg` / `inspect_empty_xmaglrg` | 大型箱式扩容弹匣的正常/空仓检视 | 只有外形或动作确实不同才需要 |
| `inspect_drummag` / `inspect_empty_drummag` | 鼓式弹匣的正常/空仓检视 | 不与 `xmaglrg` 共用状态和声音时间线 |
| `switch_fire_mode` | 通用射击模式切换动作 | 不区分切换目标，适合多个模式共享动作 |
| `switch_to_auto` / `switch_to_semi` | 分别切到全自动/半自动 | 目标模式明确，可表现不同方向的选择器运动 |
| `aim_switch_fire_mode` / `aim_switch_to_auto` / `aim_switch_to_semi` | 瞄准状态下的对应切换动作 | 保持瞄准参考姿态，不能闪回腰射 |
| `select_fire_empty` / `aim_select_fire_empty` | 空仓时切换射击模式的腰射/瞄准动作 | 仅在空仓机构会改变手部或选择器动作时需要 |
| `firemode_auto_static` / `firemode_semi_static` | 持续保持快慢机在指定模式的静态状态层 | 只控制选择器骨骼，不是一次性的切换动作 |

#### 管式霰弹枪逐发装填

| 状态 | 触发时机与作用 | 与相近状态的区别 |
|---|---|---|
| `reload_start` | 非空仓逐发装填的进入动作，并可按 `start_commit_frame` 提交第一发 | 第一发属于这一阶段；后续重复装填才进入 `reload_loop` |
| `reload_loop` | 每循环向弹仓装入一发 | 每次循环只提交一发，可重复直到装满或玩家松开 |
| `reload_end` | 停止装填并回到持枪姿态 | 不负责再装一发，也不应无条件 rechamber |
| `reload_empty_chamber_start` | 完全空仓时先把第一发直接送入膛内 | 与 `reload_empty_start` 的主要区别是第一发进入 chamber |
| `reload_empty_start` | 空仓第一发直接入膛后，继续向管式弹仓装入下一发 | 使用独立的 `empty_start_commit_frame`，之后才进入重复 `reload_loop` |
| `reload_empty_chamber_end` | 直接入膛动作与后续弹仓循环之间的交接段 | 可选；用于整理手和枪的姿态，不应再次提交同一发 |
| `aim_reload_start` / `aim_reload_loop` / `aim_reload_end` | 非空仓逐发装填三段的瞄准版本 | 与非 `aim_` 版本流程相同，但参考姿态不同 |
| `aim_reload_empty_chamber_start` / `aim_reload_empty_start` / `aim_reload_empty_chamber_end` | 空仓逐发装填三段的瞄准版本 | 必须与对应腰射状态逐一配对，不能混用世界姿态 |

#### 持续状态层、奔跑与近战

| 状态 | 触发时机与作用 | 与相近状态的区别 |
|---|---|---|
| `empty_additive` | 持续保持空仓枪机、套筒等机构姿态 | 局部状态层，不包含完整持枪姿态 |
| `empty_additive_xmaglrg` | 大型箱式扩容弹匣的空仓状态层 | 只有替换弹匣导致机构/弹药节点不同才需要 |
| `empty_additive_drummag` | 鼓式弹匣的空仓状态层 | 鼓式弹匣有独立空仓机构或弹药节点时使用 |
| `bullet_additive` | 根据剩余弹量驱动 `j_ammo_*`、弹托或 follower | 只控制弹药相关节点，不是装填动作 |
| `bullet_additive_xmaglrg` | 大型箱式扩容弹匣的弹量状态层 | 骨骼布局或容量曲线与默认弹匣不同时使用 |
| `bullet_additive_drummag` | 鼓式弹匣的弹量状态层 | 使用鼓式弹匣自己的容量、透明节点和 `j_ammo_*` 布局 |
| `shell_additive_*` | 管式弹仓内弹壳与 follower 的持续弹量姿态 | 后缀由内容配置映射；不代表运行时会仅凭名字自动猜容量 |
| `sprint_in` / `sprint_loop` / `sprint_out` | 普通奔跑的进入、循环、退出三段 | `in/out` 是有限交接，只有 `loop` 循环 |
| `super_sprint_in` / `super_sprint_loop` / `super_sprint_out` | 超级奔跑的进入、循环、退出三段 | 姿态和幅度通常比普通奔跑更强，两套端点不能互相混用 |
| `melee_miss_*` | 枪械近战对空气或未命中的攻击集合 | 编号连续；与命中结果动画分开选择 |
| `melee_hit_*` | 枪械近战造成非致命命中时的集合 | 命中反馈和声音按命中结果触发 |
| `melee_fatal_*` | 枪械近战造成致命结果时的集合 | 只用于致命结果，不是“更重的随机动作” |
| `swipe_*` / `stab_*` | 独立近战武器的横砍/刺击剪辑 | 名称本身不决定伤害；顺序、随机、提交和连段窗口由 `melee.combos` 配置 |

::: tip
并非每把武器都需要以上全部动画。只导出真实使用、并被 `animation_clips`、控制器或动画机引用的剪辑；未引用的动画不会因为名字正确就自动播放。
:::

### 8.3.1 动画制作的基本原则

1. 动画统一按 30 FPS 制作和校验；内容配置中的帧号也按 30 FPS 解释。
2. 模型、独立手臂和动画库必须使用同一套骨骼名称、父子层级、绑定姿态和坐标空间。
3. 动画只保存真正参与该动作的通道。没有运动的骨骼不要批量烘焙静态关键帧。
4. 所有位移、旋转和缩放都应在骨骼局部空间内制作。不要在导出前临时改变 Armature 对象变换。
5. Armature 对象与网格对象应应用对象级旋转和缩放；骨骼动画本身不能通过“应用变换”破坏。
6. 每个动作的名称必须唯一且稳定，不要出现 `idle`、`idle.001`、`Action` 等无意生成的动作。
7. 动画源文件中不存在的动作不要在 JSON 中虚构；JSON 中启用的动作必须能在 `.anim.glb` 中找到。
8. 动画开始帧、结束帧、事件帧、提交帧和声音帧必须在同一个时间基准上。
9. 动画文件只负责姿态。弹量、伤害、换弹提交和服务器判定仍由配置与游戏逻辑决定。

`draw_first` 是可选的首次装备动作。它按武器实例身份记录：同一客户端会话中，该实例第一次被成功装备时播放一次，之后播放 `draw`；离开世界、玩家死亡或客户端运行时重置后会重新允许首次装备。预览、改装界面和资源预热不会消耗 `draw_first`。如果只配置 `draw`，所有装备都播放 `draw`；如果希望普通装备也有动作，应同时提供 `draw`，不要只留下 `draw_first`。

`fire_pre` 也是可选动作，用于需要在真正开火动作之前执行极短准备段的武器。它应通过 `animation_machine.actions.fire.sequences` 接到 `fire`、`aim_fire` 或最后一发动作之前；普通武器不需要为了凑齐名称而添加它。

### 8.3.2 骨架、父子层级与坐标空间

推荐第一人称层级：

```text
root
├─ tag_view
├─ tag_camera
├─ tag_weapon
│  ├─ 枪身机构骨骼
│  ├─ 配件挂点
│  └─ 弹药挂点
└─ arms_root
   ├─ RIGHT_ARM
   └─ LEFT_ARM
```

必须遵守：

- `root` 是统一根节点，不能在不同模型和动画文件中拥有不同的绑定变换。
- `tag_view` 决定第一人称视角参考位置；所有动作使用同一基准，不用它制作普通镜头摇晃。
- `tag_camera` 只保存确实需要的相机动画。
- `tag_weapon` 是枪械主体与手臂相对运动的核心参考。
- 手臂在动作中应相对 `tag_weapon` 保持作者制作的关系，不能在运行时需要跟枪的动作里又回到 `static_idle` 空间。
- 默认部件和活动部件必须挂在正确节点上。泵动护木使用随泵动作移动的挂点，枪机、套筒、弹匣也必须跟随各自机构。
- 同名骨骼只能有一个明确所有者。多个 Armature 中重复出现同名目标会导致 duplicate target 或 ambiguous owner。
- 动画库和模型中的 skin 必须一致。出现 `applies to joints that are not from the same skin` 时不能忽略。

### 8.3.3 通道所有权与禁止轨道总表

“禁止轨道”表示动画文件中不应存在该节点的位置、旋转或缩放关键帧。即使整段数值不变，静态通道仍可能覆盖其他动画层。

| 动画类型 | 允许控制的主要通道 | 禁止或应删除的通道 |
|---|---|---|
| `aim_in`、`aim_out`、`aim_down_settle` | 仅 `tag_ads` | `tag_weapon`、`tag_camera`、`tag_view`、`arms_root`、左右手、枪机、弹匣、`j_ammo_*` |
| `aim_additive` / `aim_up_additive` | 仅 `tag_weapon` | `tag_ads`、`tag_camera`、`tag_view`、左右手、弹药、弹匣和无关机构 |
| `bullet_additive` | `j_ammo_*` 与配置指定的 follower | 枪身、手臂、瞄准、相机、枪机和配件挂点 |
| `shell_additive_*` | 管式弹仓的弹壳节点与 follower | 枪身、手臂、瞄准、相机、护木和枪机 |
| `empty_additive` | 该枪配置中用于保持空仓姿态的机构 | `tag_weapon`、`tag_ads`、`tag_camera`、`tag_view`、左右手；其余必须与 `bone_mask` 一致 |
| `firemode_*_static` | 仅快慢机/选择器，例如 `j_firesel` | 枪身、手臂、瞄准、相机、弹药和弹匣 |
| `fire*`、`aim_fire*`、`dry_fire*` | 后坐、枪机、套筒、击锤及作者制作的手臂动作 | `tag_ads`；没有相机动作时删除 `tag_camera` 静态轨道 |
| `reload*`、`aim_reload*`、`inspect*`、`draw*`、`holster*`、近战攻击 | 动作需要的枪身、手臂、弹匣、机构和相机 | `tag_ads`；不参与动作的骨骼不得批量烘焙 |
| `sprint_*`、`super_sprint_*` | 奔跑需要的枪身、手臂和相机 | `tag_ads`、弹量状态、快慢机状态和无关配件骨骼 |
| `static_idle` | 基础持枪姿态 | 空仓、弹量、射击模式和临时动作状态 |

`bullet_additive` / `shell_additive_*` 只控制配置中的弹药节点与 follower，`aim_in` / `aim_out` 只控制 `tag_ads`，`aim_additive` 只控制 `tag_weapon`。内容作者修改 `bone_mask` 后，动画通道必须同步服从新的所有权范围。

当前侧瞄由运行时根据 `canted_aim` 配置程序化生成，不需要制作 `canted_aim_in` / `canted_aim_out`。不要用旧侧瞄动画重复旋转 `tag_ads`，否则会与程序化姿态叠加。

### 8.3.4 基础姿态 `static_idle`

- 只描述武器正常持有时的基础姿态。
- 武器、左右手和必要机构应处于稳定位置。
- 不要写空仓枪机、弹托高度、快慢机选择等状态，这些由专用状态层控制。
- 首尾姿态必须一致；循环播放时不能跳变。
- 手臂、枪身和 `tag_weapon` 的相对关系是其他完整动作的基准。
- 改装界面、展示框、右下角动态图标和副手收纳使用静态模型姿态，不应依赖歪斜的 `static_idle` 修正模型展示。

### 8.3.5 掏枪与收枪

- `draw` / `draw_first` 从屏幕外或收纳姿态进入 `static_idle`。
- `holster` / `holster_empty` 从当前持有姿态完整离开画面。
- `draw` 最后一帧必须与 `static_idle` 对齐。
- `holster` 第一帧必须与对应的正常/空仓持有姿态对齐。
- 动画结束前不能提前回到 idle，也不能在最后一帧停留后再闪回 idle。
- 正常与空仓使用不同收枪动作时，两者的手臂、枪机和弹匣状态必须分别正确。
- 动作可包含 `tag_camera`，但没有相机动画时必须删除该静态通道。

### 8.3.6 瞄准进入、退出与瞄准附加姿态

- `aim_in`、`aim_out` 只制作 `tag_ads`，不制作手臂和枪身动作。
- `aim_in` 最后一帧是开镜保持姿态；`aim_out` 第一帧应从该姿态开始，最后回到非瞄准姿态。
- 使用 `aim_up_additive` 的武器由该动画修正 `tag_weapon`，不能再在 `aim_in` 内重复修正枪身。
- `aim_up_additive` 不包含手臂。手臂跟随由瞄准动作配对和运行时相对枪身姿态完成。
- `aim_reload`、`aim_fire` 等动作自身不能再写 `tag_ads`，否则会与瞄准过渡层争夺同一节点。
- 普通瞄具、增倍镜、双用瞄具的视觉切换由瞄具配置控制，不要在武器动画中重复制作镜片画面或准心移动。

### 8.3.7 射击、最后一发与空击

- `fire` 与 `aim_fire` 分别制作腰射和瞄准射击姿态。
- `fire_last` / `fire_last_ads` 负责最后一发及空仓机构动作。
- `fire_settle` 只描述射击后枪械恢复/稳定阶段，不得重复包含完整开火脉冲。
- `dry_fire` / `aim_dry_fire` 只描述空击机构动作。
- 枪口火焰事件的帧必须与模型枪口动作同步。
- 抛壳事件必须在枪机开锁并到达正确位置后触发。
- 动画中的 `tag_flash`、`tag_brass` 是挂点，不要通过不相关动画让它们脱离枪体。
- 左右手如果在 Blender 中跟随枪身或护木，游戏动画也必须保留相同相对轨迹。
- 射击动作不得携带 `tag_ads`，否则瞄准射击会发生瞬间偏移。

### 8.3.8 换弹动画

- `reload` 用于膛内仍有弹的普通换弹；`reload_empty` 用于空仓换弹。
- `aim_reload` / `aim_reload_empty` 是瞄准状态对应动作，不能简单把普通换弹整体缩小。
- `remove_mag`、`insert_mag`、`commit`、`bolt`、`finish` 等阶段必须与画面一致。
- `commit` 决定弹量真正更新的时刻；不能只看动画结束帧。
- 弹匣在手上、枪内和备用弹匣之间的显隐必须与事件帧一致。
- 右手和左手都允许有动画；不要为了锁手而删除作者制作的有效轨迹。
- 扩容弹匣使用专用动画时，动画时长、事件帧、声音和弹匣显隐需要单独配置。
- 动画结束帧必须能无缝交回正常或空仓基础姿态。

### 8.3.9 管式霰弹枪逐发装填

- `reload_start`：进入装填姿态，并可在 `start_commit_frame` 提交非空仓流程的第一发。
- `reload_loop`：每循环装入一发。
- `reload_end`：结束装填并回到持枪姿态。
- 空仓流程可增加 `reload_empty_chamber_start`，先把第一发直接送入膛内。
- 每个 `reload_loop` 只能提交一发，第一发和后续每发的提交帧都必须正确。
- 手中弹壳、管内弹壳和 follower 的显示由动作事件与 `shell_additive_*` 共同控制。
- `shell_additive_*` 不能包含护木、手臂或枪身轨道。
- 装填结束后是否需要 rechamber 由枪械机械流程决定；已经直接入膛时不能重复执行。

`tube_per_round` 的机械时序以动画帧为唯一数据源。内容包只填写 `*_frame`；运行时会按照武器根配置的 `animation_fps` 自动换算服务端使用的毫秒时间，不要再额外填写 `insert_commit_ms`、`start_commit_ms`、`empty_chamber_start_commit_ms`、`empty_start_commit_ms`、`rechamber_eject_ms` 或 `rechamber_commit_ms`。

```jsonc
"reload_system": {
  "type": "tube_per_round",
  "tube_capacity": 7,
  "chamber_capacity": 1,
  "rechamber_delay_ms": 350,
  "frame_lengths": {
    "start": 27,
    "insert": 22,
    "end": 19,
    "end_rechamber": 19,
    "empty_chamber_start": 53,
    "empty_start": 27,
    "empty_chamber_end": 16,
    "rechamber": 21
  },
  "events": {
    "insert_sound_frame": 19,
    "insert_commit_frame": 19,
    "start_commit_frame": 24,
    "empty_chamber_start_commit_frame": 50,
    "empty_start_commit_frame": 24,
    "rechamber_eject_frame": 2,
    "rechamber_commit_frame": 19
  }
}
```

| 参数 | 对应动画 | 作用 |
|---|---|---|
| `start_commit_frame` | `reload_start` / `aim_reload_start` | 非空仓流程第一发真正加入武器的帧 |
| `insert_commit_frame` | `reload_loop` / `aim_reload_loop` | 每次循环真正增加一发并扣除一颗备弹的帧 |
| `empty_chamber_start_commit_frame` | `reload_empty_chamber_start` / `aim_reload_empty_chamber_start` | 完全空仓时第一发真正加入武器的帧 |
| `empty_start_commit_frame` | `reload_empty_start` / `aim_reload_empty_start` | 空仓流程继续向管内装入下一发的帧 |
| `rechamber_eject_frame` | `fire_rechamber` / `aim_fire_rechamber` | 真正生成并抛出弹壳的帧 |
| `rechamber_commit_frame` | `fire_rechamber` / `aim_fire_rechamber` | 护木复位、下一发进入膛内并解除待循环状态的帧 |
| `insert_sound_frame` | `reload_loop` / `aim_reload_loop` | 装弹声音的作者参考帧；实际声音事件仍在渲染配置的 `animation_commands` 中声明 |

`frame_lengths` 是各阶段动画的总帧数：`start`、`insert`、`end`、`end_rechamber`、`empty_chamber_start`、`empty_start`、`empty_chamber_end`、`rechamber` 分别对应同名 `clips` 阶段。正常情况下运行时优先读取 GLB 剪辑真实时长；这些数值用于缺失时长信息时的阶段持续时间回退，必须与导出的动画长度一致。弹量 HUD 与真正射击判定读取机械提交结果；`shell_additive_*` 和弹壳显隐只负责模型表现，不能代替提交帧。

### 8.3.10 泵动与栓动 `rechamber`

- `fire_rechamber` / `aim_fire_rechamber` 在开火动作提交后按配置延迟进入。
- 泵动霰弹枪的 `j_pump`、`tag_guard_attach` 和左手必须保持同一运动关系。
- 栓动步枪的枪机、弹壳、右手和抛壳事件必须按机械顺序制作。
- 动画第一帧应对齐开火结束姿态，最后一帧应对齐对应的腰射或瞄准持枪姿态。
- 左手或右手最后一帧与 idle 数值相同仍可能因参考空间不同而跳动，应检查骨骼局部变换、父级关系和绑定姿态，而不只比较曲线数值。

### 8.3.11 检视、近战与有限动作

- `inspect` / `inspect_empty` 可以包含完整枪身、手臂和相机动画。
- 检视中的弹匣、膛内弹和弹托必须读取当前真实弹量状态。
- 枪械近战使用 `melee_miss_*`、`melee_hit_*`、`melee_fatal_*`，编号连续，运行时自动识别可用数量。
- 独立近战武器使用自身攻击集合，例如 `swipe_*`、`stab_*`。
- 每个攻击动作配置自己的命中提交帧、伤害窗口和声音事件。
- 动作结束后不得保留尾帧层权重，必须完整交回基础姿态。

### 8.3.12 奔跑与超级奔跑

- 使用明确的 `sprint_in → sprint_loop → sprint_out` 和 `super_sprint_in → super_sprint_loop → super_sprint_out`。
- `*_in` 最后一帧必须与 `*_loop` 第 0 帧一致。
- `*_loop` 首尾帧必须连续，不能包含回到 idle 的中间帧。
- `*_out` 第 0 帧必须与 loop 姿态一致，最后一帧必须与 `static_idle` 一致。
- 奔跑动画只保留最终需要的枪身、手臂和相机通道；不使用的左右手 IK 通道不要混入导出结果。
- 奔跑动画不能携带弹量、空仓和 `tag_ads` 状态轨道。
- 循环动画每一帧都可烘焙，但不能把其他骨架的静态通道一起烘焙进去。

### 8.3.13 手臂制作规则

- 独立手臂模型与武器动画中的手臂骨架必须拥有完全一致的绑定姿态。
- `arms_root` 负责手臂整体参考，不能在某些动作中意外回到绑定姿态。
- RIGHT_ARM / LEFT_ARM 的位置、旋转、缩放必须使用相同旋转模式和父级空间。
- 只有动作确实需要手臂运动时才保留手臂通道。
- 瞄准射击、瞄准换弹等组合动作必须检查双手相对 `tag_weapon` 的局部姿态，而不是只看世界坐标。
- 配件替换后，握持点移动时需要专用动作或正确的活动挂点，不能让手停在默认部件位置。

### 8.3.14 相机动画规则

- `tag_camera` 只负责相机姿态，`tag_view` 只负责视角参考位置。
- 相机动画不能替代枪械模型动画，两者需要分别制作。
- 没有相机运动的动作应删除 `tag_camera` 通道，不要保留批量烘焙产生的无用静态通道。
- 相机动画首尾需要平滑，不能在动作结束时一帧归零。
- Weapon Sway、后坐力和 Bob 属于运行时层；动画作者不要在每个动作里重复烘焙同一套程序化摆动。

### 8.3.15 配件、弹药和活动挂点

- 静态配件挂点通常不需要关键帧。
- 活动部件的挂点必须跟随对应机构，例如 `tag_guard_attach` 跟随泵动护木。
- 默认配件与替换配件必须使用同一挂点空间，否则动画播放时会脱离枪体。
- `j_ammo_*` 可有专用弹量动画，但不能被每个基础动作的静态轨道覆盖。
- 膛内弹节点与弹匣内弹节点分开管理，不能假设都属于 `j_mag1` 或 `j_mag2`。
- 弹壳模型由弹药定义决定，抛壳挂点使用 `tag_brass`；检视用 casing 模型不作为改装配件出现。

### 8.3.16 多骨架动画

- 一个动作可以包含多个 Armature 所拥有的骨骼通道，但最终动作名称和时间范围必须统一。
- 每个目标骨骼必须拥有唯一、明确的 Armature 所有者，不能把同名骨骼重复导出到多个 skin。
- 没有参与当前动作的次级骨架不应生成静态通道。
- 导出前删除无用 Action、stash、孤立 NLA strip 和自动生成的 `.001` 动作。
- 具体导入、通道分配和骨骼归属覆盖方法由所使用的 Blender 工具决定，不属于内容包格式要求。

### 8.3.17 关键帧与插值

- 动作范围必须精确覆盖实际关键帧，不留无意义的长尾。
- 机械卡点、弹匣插入和枪机闭锁可使用明确的缓入缓出或线性段，避免自动贝塞尔过冲。
- 四元数每帧应归一化，并保持相邻帧选择最短旋转路径，避免突然翻转。
- 循环动作检查首尾一阶速度连续，不能只检查位置相等。
- 需要逐帧稳定的动作可以烘焙每一帧，但烘焙后仍要删除未参与骨骼的静态曲线。
- 缩放通道默认维持 `(1, 1, 1)`；除非模型确实需要变形，否则不要制作骨骼缩放动画。

### 8.3.18 动画导出检查清单

导出前：

- 动作名称正确且没有 `.001`。
- 帧率为 30 FPS，动作起止帧正确。
- Armature/网格对象级缩放已应用且为 1。
- 骨骼绑定姿态、父子层级和命名一致。
- 禁止轨道已删除，未参与骨骼没有静态关键帧。
- 循环首尾、进入/循环/退出交接已检查。
- 手臂相对 `tag_weapon`、活动配件相对挂点正确。
- 相机轨道只存在于确实需要相机运动的动作。

导出后：

- `.anim.glb` 中动作数量和名称正确。
- 每个动作时长与 Blender 一致。
- 没有 duplicate target、ambiguous owner 或跨 skin 警告。
- `aim_in/out` 仅有 `tag_ads`，`aim_additive` 仅有 `tag_weapon`。
- `bullet_additive` / `shell_additive_*` 仅有弹药与 follower。
- 游戏内测试 idle、瞄准、射击、最后一发、空击、所有已配置的换弹分支、检视、奔跑、近战和切枪。
- 每个动作都测试腰射与瞄准、正常与空仓、默认与替换配件、第一人称与第三人称。

### 8.4 动画时长必须同步

修改动画后至少检查四处：

1. `animation_controller.channels.<动作>.duration_frame` 或 `duration`。
2. 弹匣式武器检查 `mechanics.action_commit_ms`；`tube_per_round` 检查 `reload_system.events` 的 `*_commit_frame`，不要为逐发换弹重复填写 `*_ms`。
3. `reload_phases` 的阶段帧。
4. `animation_commands` 中声音、遮罩、装填、抛壳等事件帧。

弹匣式武器需要手工换算时，30 FPS 动画可用：

```text
毫秒 = 帧数 / 30 × 1000
```

`tube_per_round` 会根据 `animation_fps` 自动完成这一步。替换 `.anim.glb` 后仍必须同步核对事件帧，否则会出现声音延迟、弹壳提前消失、换弹提交时机错误或动画结束后才更新弹量。

### 8.5 动画机 v2

最小结构：

```jsonc
"animation_machine": {
  "version": 2,
  "actions": {
    "draw": {"type": "finite", "default_state": "draw"},
    "holster": {"type": "finite", "default_state": "holster"},
    "fire": {"type": "finite", "default_state": "fire"},
    "reload": {"type": "finite", "default_state": "reload"},
    "inspect": {"type": "finite", "default_state": "inspect"},
    "aim": {
      "type": "continuous",
      "phase_states": {
        "enter": "aim_in",
        "loop": "static_idle",
        "exit": "aim_out"
      }
    },
    "sprint": {
      "type": "continuous",
      "phase_states": {
        "enter": "sprint_in",
        "loop": "sprint_loop",
        "exit": "sprint_out",
        "super_enter": "super_sprint_in",
        "super_loop": "super_sprint_loop",
        "super_exit": "super_sprint_out"
      }
    }
  },
  "interrupts": []
}
```

完整的 variant、sequence、marker、Pose Graph、打断与管式装填写法请直接参照：

- `weapons/firearms/render/m4.render.json`
- `weapons/firearms/render/m590a1.render.json`
- `weapons/firearms/render/cheytac_m200.render.json`
- `weapons/melee/render/karambit.render.json`
- 本页的动画制作与导出规范
