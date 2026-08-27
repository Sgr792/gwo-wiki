---
title: 配件、瞄具与挂饰
order: 5
category:
  - 内容包制作
---

## 13. 配件系统

每个配件分为：

1. 行为文件：类别、槽位、兼容父级、属性。
2. 渲染文件：模型、贴图、挂点和特殊渲染。

### 13.1 普通配件

```json
{
  "id": "example:example_extended_mag",
  "type": "magazine",
  "slot": "magazine",
  "display_name": "示例扩容弹匣",
  "display_name_en": "Example Extended Magazine",
  "default_installed": false,
  "parent_types": ["gun"],
  "properties": {
    "set": {
      "capacity": 60
    }
  },
  "render": "attachments/render/magazines/example_extended_mag.render.json"
}
```

配件必须同时被枪的 `modules` 收录，才会在该枪的改装系统中出现。默认部件还应设置 `default_installed: true`。

属性可按现有配件使用 `set`、`add` 或 `multiply`；不要编造加载器不认识的属性名。新属性先从当前默认内容中寻找同类范例。

### 13.2 配件挂点层级

配件可以挂在枪上，也可以挂在另一个配件上。例如激光器：

```json
{
  "id": "example:red_laser",
  "type": "laser",
  "slot": "laser",
  "default_installed": false,
  "parent_types": ["barrel"],
  "parent_slots": ["barrel"],
  "laser": {"color": "#ff0000"},
  "render": "attachments/render/lasers/red_laser.render.json"
}
```

渲染文件：

```json
{
  "model": "example:gltf/attachments/red_laser.glb",
  "texture": "example:skins/attachments/red_laser.png",
  "normal": "example:skins/attachments/red_laser_n.png",
  "specular": "example:skins/attachments/red_laser_s.png",
  "icon_texture": "example:textures/item/attachments/red_laser.png",
  "anchor_node": "tag_laser_attach"
}
```

激光器 GLB 内应有 `tag_laser` 发射节点；`tag_laser_attach` 只是整个配件安装到枪上的挂点。

### 13.3 骨骼可见性

装/不装某类配件时隐藏或显示机瞄、支架等节点：

```json
"gun_bone_visibility": {
  "when_slot_empty": {
    "sight": {
      "show": ["tag_sight_on"],
      "hide": ["tag_sight_off"]
    }
  },
  "when_slot_occupied": {
    "sight": {
      "show": ["tag_sight_off"],
      "hide": ["tag_sight_on"]
    }
  }
}
```

名称必须与实际 GLB 节点完全一致。不要凭含义猜 `tag_bipod_attach`、`tag_bipod_hide` 或 `tag_bipod_pivot`。

### 13.4 配件专用动画

安装某配件后可通过动画 variant 或模块动作覆盖选择 `reload_xxx`、`inspect_xxx` 等专用动作。专用动作必须同时补齐：

- `animation_clips`
- `animation_controller.channels`
- `animation_events`
- `paired_aim_actions`
- `animation_commands`
- `reload_phases`
- `mechanics.action_commit_ms`

弹匣分支不要混用：

- `xmaglrg` 是大型箱式扩容弹匣，使用 `reload_xmaglrg`、`inspect_xmaglrg`、`bullet_additive_xmaglrg` 等状态。
- `drummag` 是鼓式弹匣，使用 `reload_drummag`、`inspect_drummag`、`bullet_additive_drummag` 等独立状态。

行为文件中的 `animation_override` 应指向实际弹匣家族。两种弹匣都存在时，普通/空仓、腰射/瞄准、检视、空仓附加层和弹量附加层都要分别声明，不能只改模型和容量。

## 14. 瞄具

### 14.1 普通红点/全息

行为文件重点：

```json
"sight": {
  "enabled": true,
  "type": "reflex",
  "scope_rate": 1.0
}
```

渲染文件常用：

```json
"sight": {
  "reticle_node": "tag_reticle_attach",
  "reticle_plane_node": "tag_lense",
  "rear_lens_node": "rear_lens",
  "lens_node": "lens_glass_ads",
  "projected_reticle": true,
  "reticle_texture": "example:textures/sights/red_dot.png",
  "reticle_emissive_strength": 1.5,
  "reticle_scale": 1.0,
  "reticle_virtual_depth": 1.0
}
```

准心应该锚定瞄具模型节点，并由投影准心系统处理视差。不要把准心直接烘焙到玻璃基础色中。

### 14.2 增倍镜

行为文件：

```json
"sight": {
  "enabled": true,
  "type": "scope",
  "scope_rate": 4.0,
  "ads_z_compensation": 1.0
}
```

渲染文件至少需要正确的前镜片、后镜片、模板/光学节点和准心节点。当前默认完整参考是：

```text
attachments/sights/sz_bullseye_optic.json
attachments/render/sights/sz_bullseye_optic.render.json
```

Weapon Sway 在倍镜模式下会通过镜内投影参考参与画面与准心计算；内容作者不应在动画里再做一套相反的相机摆动。

### 14.3 双用瞄具

两类常见结构：

- 红点 + 可翻转增倍镜。
- 上方红点 + 下方固定倍率镜。

使用 `tag_hybrid` 安装到支持该挂点的枪。模式切换、倍率过渡和物理翻转由通用程序化插值控制，不要求额外翻转动画。必须分别配置两种模式的准心、镜片节点和倍率，不能只改变全局 FOV。

### 14.4 可变倍率

可变倍率瞄具需要在行为配置中声明可用倍率/模式，游戏内按当前绑定键切换。不要把多个倍率做成多份重复模型；镜片、准心与倍率状态应共享同一瞄具定义。

### 14.5 程序化侧瞄（战术姿态）

侧瞄属于枪械渲染配置，不属于瞄具动画。推荐从当前 RM277 或 M4 的渲染文件复制：

```json
"canted_aim": {
  "enabled": true,
  "pose_node": "tag_ads",
  "pivot_node": "tag_weapon",
  "translation": {
    "x": 0.0,
    "y": 0.0,
    "z": 0.0
  },
  "rotation": {
    "x": -55.0,
    "y": 0.0,
    "z": 0.0
  },
  "response": 22.0,
  "damping": 0.62,
  "fov_multiplier": 1.0
}
```

- 玩家必须先按住瞄准键，再按 V 在普通瞄准和侧瞄之间切换；V 的选择按武器实例保存。
- 装有增倍镜或双用瞄具时不能切换侧瞄；普通机瞄、红点和全息可以使用。
- 侧瞄不要求安装激光。进入侧瞄时第一人称激光显示由运行时处理，退出时恢复原来的激光开关状态。
- `pose_node` 是被施加侧瞄变换的节点，`pivot_node` 是旋转枢轴；两者必须真实存在于枪械 GLB 中。
- `rotation` 控制倾斜角度，`translation` 只用于必要的局部校正，`response` 和 `damping` 控制进入/退出力度，`fov_multiplier: 1.0` 表示侧瞄不保留倍镜放大。
- 不要再制作或绑定 `canted_aim_in`、`canted_aim_out`，也不要复用夜视瞄准动画。普通瞄准与侧瞄之间由运行时从当前姿态直接交接。

## 15. 挂饰

枪必须拥有 `tag_cosmetic`。挂饰行为放 `attachments/cosmetics/`，模型放 `gltf/attachments/`。

普通物理挂饰可配置碰撞体，碰撞体应围绕挂点附近的枪体局部空间编写。换枪不会自动推断任意高面模型的精确碰撞体，内容作者应针对枪械或挂点提供合理的简化 collider。

玩家头像挂饰可使用 `player_avatar` 异步读取玩家最新皮肤，并在 `nameplate_face` 上程序化绘制名字。链条网格使用普通材质，头像节点和名字面不要读取链条贴图。

玩家头像挂饰应使用通用资源 ID，并在自己的行为文件和渲染文件中配置玩家名称、UUID、头像节点及名字面；不要依赖默认内容包中的特定玩家示例。
