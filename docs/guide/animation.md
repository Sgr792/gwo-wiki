---
title: 动画制作与导出规范
order: 3
category:
  - 内容包制作
---

## 8. 动画导出规范

### 8.1 模型与动画分离

推荐：

- `*_receiver_default.glb`：模型、骨架、蒙皮，不包含动作库。
- `*_receiver_default.anim.glb`：动画库，不包含可见枪械网格。
- `arms.glb`：独立手臂模型。

渲染配置：

```json
{
  "gltf_model": "example:gltf/guns/example_rifle/example_rifle_receiver_default.glb",
  "animation_sources": "example:gltf/animations/example_rifle_receiver_default.anim.glb",
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
holster
aim_in
aim_out
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
| `aim_in`、`aim_out`、`aim_down_settle`、`canted_aim_in/out` | 仅 `tag_ads` | `tag_weapon`、`tag_camera`、`tag_view`、`arms_root`、左右手、枪机、弹匣、`j_ammo_*` |
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

- `reload_start`：进入装填姿态。
- `reload_loop`：每循环装入一发。
- `reload_end`：结束装填并回到持枪姿态。
- 空仓流程可增加 `reload_empty_chamber_start`，先把第一发直接送入膛内。
- 每个 `reload_loop` 只能提交一发，第一发和后续每发的提交帧都必须正确。
- 手中弹壳、管内弹壳和 follower 的显示由动作事件与 `shell_additive_*` 共同控制。
- `shell_additive_*` 不能包含护木、手臂或枪身轨道。
- 装填结束后是否需要 rechamber 由枪械机械流程决定；已经直接入膛时不能重复执行。

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
2. `mechanics.action_commit_ms`。
3. `reload_phases` 的阶段帧。
4. `animation_commands` 中声音、遮罩、装填、抛壳等事件帧。

30 FPS 动画可用：

```text
毫秒 = 帧数 / 30 × 1000
```

替换 `.anim.glb` 后必须同步核对事件帧，否则会出现声音延迟、弹匣提前消失、换弹提交时机错误或动画结束后才更新弹量。

### 8.5 动画机 v2

最小结构：

```json
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
