---
title: 从零制作第一把枪
order: 3
category:
  - 零基础入门
---

# 从零制作第一把枪

这是三条制作路线共用的内容包配置教程。尚未制作模型与动画时，请先[选择制作方式](./choose-workflow.md)。本章文件名以 GLB 为例；Blockbench 路线按[格式配置](./bedrock-empty.md)替换为自己的几何与动画 JSON 路径，逻辑、材质与事件配置仍共用。Blender 蒙皮专属操作不适用于纯刚性模型。

本章面向第一次制作 GWO 内容包的人。目标不是第一遍就做出完整商业级武器，而是按固定顺序得到一把能加载、能显示、能射击、能换弹，再逐步加入瞄准、手臂、声音和配件的枪。

每一步都有“完成标准”。没有达到当前标准时不要继续堆功能，否则多个错误会混在一起。

## 最终会得到什么

完成本章后，你应当拥有：

- 一份独立命名空间的内容包。
- 一把创造栏可获得的半自动训练步枪。
- 一种可装填的弹药。
- 第一人称模型、基础动画、基础色/法线/材质贴图和图标。
- 可以验证的射击与弹匣式换弹逻辑。
- 后续增加瞄准、声音、默认配件和完整状态机的正确入口。

本章统一使用这些名称：

| 项目 | 示例值 |
|---|---|
| 内容包文件夹 | `my_first_gwo_pack` |
| 命名空间 | `tutorial` |
| 枪械 ID | `training_rifle` |
| 弹药 ID | `training_ammo` |
| 弹药族 | `training_caliber` |
| 动画帧率 | 30 FPS |

实际制作时可以替换这些名称，但同一个名称必须在所有文件中保持一致。

## 第 0 步：准备环境

1. 安装 Minecraft 1.21.1、匹配版本 NeoForge 和 GWO。
2. 只准备所选路线的软件：Blender 或 Blockbench。
3. 准备 VS Code 或其他能保存 UTF-8 JSON 的编辑器。
4. 下载并解压[空内容包模板](/downloads/gwo_empty_content_pack_template.zip)。
5. 需要制作手臂动作时，按路线下载[手臂制作模板](./arm-templates.md)。
6. 把模板文件夹改名为 `my_first_gwo_pack`，放进 `.minecraft/gwo/`。
7. 把 `assets/example/` 改名为 `assets/tutorial/`。

### 完成标准

```text
.minecraft/gwo/my_first_gwo_pack/pack.mcmeta
.minecraft/gwo/my_first_gwo_pack/assets/tutorial/
```

游戏能够启动，日志没有内容包 JSON 错误。空包不出现物品属于正常现象。

## 第 1 步：先规划名字，避免后期全盘重命名

创建下表中的目标路径：

```text
my_first_gwo_pack/
├─ weapons/firearms/training_rifle.json
├─ weapons/firearms/render/training_rifle.render.json
├─ bullets/training_ammo.json
└─ assets/tutorial/
   ├─ gltf/guns/training_rifle/training_rifle_receiver_default.glb
   ├─ gltf/animations/training_rifle_receiver_default.anim.glb
   ├─ skins/guns/training_rifle.png
   ├─ skins/guns/training_rifle_n.png
   ├─ skins/guns/training_rifle_s.png
   └─ textures/item/guns/training_rifle.png
```

先不要创建配件文件。第一轮让整把枪作为一个机匣模型显示，可以排除挂点和模块树错误。确认基础枪正常后再分离默认枪管、弹匣、枪托。

### 命名规则

- 文件路径只用小写字母、数字和下划线。
- JSON 资源 ID 写成 `命名空间:路径`。
- `tutorial:gltf/...` 一定对应 `assets/tutorial/gltf/...`。
- `model_data` 与 `icon_model_data` 在自己的内容包内不要重复。
- 不要使用 `idle.001`、`Action`、`Cube.003` 作为最终动作或关键网格名称。

### 完成标准

你能从任意一个资源 ID 反推出真实路径。例如：

```text
tutorial:skins/guns/training_rifle.png
→ assets/tutorial/skins/guns/training_rifle.png
```

## 第 2 步：制作第一版枪模型

第一版模型只追求参考空间正确。细分默认配件、透明玻璃、挂饰碰撞和复杂骨骼都放到基础验收以后。

### 按所选路线准备场景

- [Blender 骨架](./blender-skinning.md)：骨架、网格和绑定姿态一致。
- [Blender Empty](./blender-empty.md)：保留父级 Empty 与子网格，不要求 Armature 或 Skinning。
- [Blockbench](./blockbench.md)：使用 Bedrock 实体方块、分组和数值动画，不需要安装 Blender。

三条路线都要检查模型方向、比例、节点命名和无用对象。软件操作按对应路线完成，本章不再要求所有作者使用同一种导出器。

### 第一版至少需要的节点

```text
root
└─ tag_view
   ├─ tag_camera
   └─ tag_ads
      └─ tag_weapon
         └─ 枪械主体骨骼（例如 j_gunx）
            ├─ 枪械网格和可动机构
            ├─ tag_align_gun
            ├─ tag_weapon_focus（需要时）
            └─ tag_brass
```

上面的缩进就是父子级，不只是名称清单：`root` 是 `tag_view` 的父级；`tag_view` 同时是 `tag_camera` 和 `tag_ads` 的父级；`tag_ads` 是 `tag_weapon` 的父级；枪械主体骨骼及枪械网格位于 `tag_weapon` 下面。不要把它反过来做成 `root → tag_weapon → tag_view`。

| 子节点 | 应放在谁下面 | 原因 |
|---|---|---|
| `tag_view` | `root` | 建立整套第一人称视角参考空间 |
| `tag_camera` | `tag_view` | 只叠加相机动画，不跟着枪械局部机构运动 |
| `tag_ads` | `tag_view` | 承担腰射与瞄准姿态的切换 |
| `tag_weapon` | `tag_ads` | 让整把枪和手在当前瞄准参考空间内运动 |
| 枪械主体骨骼（如 `j_gunx`） | `tag_weapon` | 承载枪身、手臂参考和枪械动画 |
| `tag_align_gun`、`tag_weapon_focus`、`tag_brass` | 枪械主体的运动分支 | 必须跟随枪身动画；中间可以存在 `tag_sling` 等武器自身骨骼 |

`tag_flash` 的父级取决于模型拆分方式：一体模型应把它放在枪械主体的运动分支下；模块化武器通常把它放进枪管 GLB，并置于该枪管的 `tag_barrel_attach` 分支下。无论哪种方式，它都必须随当前枪管和枪身运动，不能直接放在 `root`、`tag_view` 或 `tag_camera` 下。

它们的用途：

| 节点 | 第一次制作时怎样理解 |
|---|---|
| `root` | 整套武器的根 |
| `tag_weapon` | 枪和手的主要参考空间 |
| `tag_view` | 第一人称视角参考位置 |
| `tag_camera` | 相机动画，不能代替 `tag_view` |
| `tag_ads` | 后续瞄准过渡使用 |
| `tag_align_gun` | 瞄准对齐参考点 |
| `tag_weapon_focus` | 瞄准焦点参考点 |
| `tag_flash` | 枪口火焰、烟雾和第一人称尾迹起点 |
| `tag_brass` | 弹壳抛出位置 |

`tag_flash` 放在真实枪口，局部朝向与枪口出射方向一致。`tag_brass` 放在抛壳窗。节点名和父子级都必须正确，一个字符都不能拼错。

### 导出模型

本章 GLB 示例路径：

```text
assets/tutorial/gltf/guns/training_rifle/training_rifle_receiver_default.glb
```

骨架路线保留所需骨架与 Skinning；Empty 路线保留驱动节点及子网格。Blockbench 则导出几何 JSON，并把后文 `gltf_model` 替换为对应路径，例如 `tutorial:models/training_rifle.geo.json`。静态模型不需要混入无关动作库。

不要改变模型与动画的节点名、绑定/初始姿态后只重导其中一个文件。

### 完成标准

- 对应路线的模型文件存在且不是 0 字节。
- 在所选软件的新工程中重新打开导出文件，方向与比例仍正确。
- 节点名称、父子层级和模型比例没有变化。
- `tag_flash` 与 `tag_brass` 位置正确。

## 第 3 步：准备基础贴图和图标

放入：

```text
assets/tutorial/skins/guns/training_rifle.png
assets/tutorial/skins/guns/training_rifle_n.png
assets/tutorial/skins/guns/training_rifle_s.png
assets/tutorial/textures/item/guns/training_rifle.png
```

规则：

- `training_rifle.png` 是基础色和透明度。
- `training_rifle_n.png` 是切线空间法线贴图。
- `training_rifle_s.png` 是 GWO 材质/高光贴图，不要当普通基础色使用。
- 物品图标必须带透明背景，不要把白色背景烘进去。
- 同一 GLB 中如果有透明网格，必须给它独立、稳定的网格名，后续才能在 `transparent_nodes` 中单独配置。

第一次测试可以先使用简单的中性贴图，但不能让 JSON 指向不存在的文件。

### 完成标准

四张 PNG 都能正常打开，尺寸不为 0，文件名与上面完全一致。

## 第 4 步：制作最小动画库

第一轮只做六个动作：

```text
static_idle
draw
holster
fire
reload
reload_empty
```

### 每个动作的作用

| 动作 | 作用 | 第一帧/最后一帧要求 |
|---|---|---|
| `static_idle` | 正常持枪基础姿态 | 作为其他完整动作的稳定交接基准 |
| `draw` | 普通掏枪 | 末帧接 `static_idle` |
| `holster` | 收枪 | 首帧从 `static_idle` 离开 |
| `fire` | 普通开火 | 结束后回到基础持枪参考 |
| `reload` | 弹匣内仍有弹时换弹 | 提交帧前后弹匣动作清晰 |
| `reload_empty` | 完全空仓时换弹 | 包含需要的枪机/释放动作 |

### 按路线建立动作

- Blender 骨架：给所属骨架建立 Action。
- Blender Empty：给运动节点制作对象变换关键帧，并按导出器的 Action/NLA 组织方式归入同名剪辑；不要误选不存在的 Armature。
- Blockbench：在动画工作区创建动作，给分组制作数值关键帧。

本例统一使用 30 FPS 作为配置帧基准。为动作命名、保留有效轨道，删除无关的批量静态轨道和重复动作。具体软件操作见对应路线，所有路线共同遵守[动画通道所有权](./animation.md)。

### 导出动画库

GLB 路线的动画库保存为：

```text
assets/tutorial/gltf/animations/training_rifle_receiver_default.anim.glb
```

Blockbench 路线改为独立 `.animation.json`，并在 `animation_sources` 中引用；`animation_clips` 右侧保留实际完整动作名。各路线模型与动画都要具有相匹配的节点、父子关系和参考姿态，不要单独移动动画根来掩盖错误。

### 完成标准

- 导出的动画库中六个剪辑名称准确且唯一，与配置映射对应。
- 所有剪辑都能从第 0 帧开始。
- `draw` 尾帧与 `static_idle` 对接。
- `fire` 结束后不会留下额外根位移。
- 没有 `applies to joints that are not from the same skin` 警告。

## 第 5 步：创建弹药定义

创建：

```text
bullets/training_ammo.json
```

第一轮使用最少字段：

```json
{
  "id": "tutorial:training_ammo",
  "display_name": "训练弹药",
  "family": "tutorial:training_caliber",
  "icon_model_data": 30001,
  "ballistics": {
    "max_entity_hits": 1
  },
  "tracer": {
    "count_interval": 0,
    "color": "#FFFFEBA0",
    "size_multiplier": 1.0,
    "length_multiplier": 1.0
  }
}
```

这里暂时不写整弹和弹壳模型，目的是先验证逻辑。枪能正常射击后，再按[枪械、弹药与材质](firearms.md)补 `models.cartridge` 和 `models.casing`。

### 完成标准

执行 `/gwo reload` 后聊天栏没有弹药解析错误，并且：

```text
/gwo give ammo "tutorial:training_ammo"
```

能得到弹药。如果物品图标暂时使用通用外观，不影响这一阶段逻辑验收。

## 第 6 步：创建枪械逻辑 JSON

创建：

```text
weapons/firearms/training_rifle.json
```

复制以下内容：

```json
{
  "id": "tutorial:training_rifle",
  "display_name": "训练步枪",
  "creative_category": "assault_rifle",
  "creative_sort": 100,
  "model_data": 30000,
  "magazine_size": 30,
  "ammo": {
    "default": "tutorial:training_ammo",
    "accepted_families": [
      "tutorial:training_caliber"
    ]
  },
  "damage": 8.0,
  "range": 96.0,
  "ballistics": {
    "muzzle_velocity": 500.0,
    "gravity": 9.8,
    "drag": 0.015,
    "water_drag": 0.6,
    "life_seconds": 2.5,
    "hitbox_inflation": 0.12,
    "headshot_multiplier": 1.5,
    "headshot_height_fraction": 0.25,
    "damage_curve": [
      {"distance": 0, "multiplier": 1.0},
      {"distance": 32, "multiplier": 1.0},
      {"distance": 64, "multiplier": 0.85},
      {"distance": 96, "multiplier": 0.65}
    ]
  },
  "inaccuracy": {
    "stand": 5.0,
    "move": 5.5,
    "sneak": 2.75,
    "lie": 1.5,
    "aim": 0.1
  },
  "mechanics": {
    "rpm": 600,
    "fire_interval_ms": 100,
    "action_commit_ms": {
      "reload": 1300,
      "reload_empty": 1800
    }
  },
  "fire_modes": [
    "semi"
  ],
  "render": "weapons/firearms/render/training_rifle.render.json"
}
```

重要关系：

- `60000 / rpm` 应约等于 `fire_interval_ms`。
- `magazine_size` 是总弹匣容量。
- `ammo.default` 必须指向已经加载的弹药 ID。
- `accepted_families` 匹配弹药的 `family`，不是文件名。
- `action_commit_ms.reload` 是真正改变弹量的时刻，不是声音帧。
- `render` 是相对于内容包根目录的 JSON 路径。

### 完成标准

`/gwo reload` 后没有 `Failed to read weapon definition`，并且：

```text
/gwo give firearm "tutorial:training_rifle"
```

能够得到枪。此时渲染文件还没完成，枪可能不可见或使用缺失表现；只要定义能被识别就通过本步。

## 第 7 步：创建最小渲染与动画配置

创建：

```text
weapons/firearms/render/training_rifle.render.json
```

下面配置假设六段动画均为 30 FPS。把 `duration_frame` 改成你实际动作的最后帧，不要照抄错误长度：

```json
{
  "gltf_model": "tutorial:gltf/guns/training_rifle/training_rifle_receiver_default.glb",
  "animation_sources": [
    "tutorial:gltf/animations/training_rifle_receiver_default.anim.glb"
  ],
  "texture": "tutorial:skins/guns/training_rifle.png",
  "normal": "tutorial:skins/guns/training_rifle_n.png",
  "specular": "tutorial:skins/guns/training_rifle_s.png",
  "icon_texture": "tutorial:textures/item/guns/training_rifle.png",
  "animation_clips": {
    "static_idle": "static_idle",
    "draw": "draw",
    "holster": "holster",
    "fire": "fire",
    "reload": "reload",
    "reload_empty": "reload_empty"
  },
  "animation_events": {
    "draw": "draw",
    "holster": "holster",
    "fire": "fire",
    "reload": "reload",
    "reload_empty": "reload_empty"
  },
  "animation_machine": {
    "version": 2,
    "actions": {
      "draw": {
        "type": "finite",
        "default_state": "draw"
      },
      "holster": {
        "type": "finite",
        "default_state": "holster"
      },
      "fire": {
        "type": "finite",
        "default_state": "fire",
        "events": [
          {"type": "shot_effects", "marker": "shot", "offset_ms": 0},
          {"type": "fire_sound", "marker": "shot", "offset_ms": 0},
          {"type": "recoil", "marker": "shot", "offset_ms": 0}
        ]
      },
      "reload": {
        "type": "finite",
        "default_state": "reload",
        "variants": [
          {
            "state": "reload_empty",
            "priority": 100,
            "when": {"empty": "true"}
          },
          {
            "state": "reload",
            "priority": 0
          }
        ]
      }
    },
    "interrupts": []
  },
  "animation_controller": {
    "channels": {
      "draw": {
        "clip": "draw",
        "layer": "action",
        "fade_in": 0,
        "fade_out": 0,
        "loop": false,
        "duration_frame": 24
      },
      "holster": {
        "clip": "holster",
        "layer": "action",
        "fade_in": 0,
        "fade_out": 0,
        "loop": false,
        "duration_frame": 21
      },
      "fire": {
        "clip": "fire",
        "layer": "recoil",
        "fade_in": 0,
        "fade_out": 0,
        "loop": false,
        "duration_frame": 8
      },
      "reload": {
        "clip": "reload",
        "layer": "action",
        "fade_in": 0,
        "fade_out": 0,
        "loop": false,
        "duration_frame": 76,
        "lock_fire": true
      },
      "reload_empty": {
        "clip": "reload_empty",
        "layer": "action",
        "fade_in": 0,
        "fade_out": 0,
        "loop": false,
        "duration_frame": 81,
        "lock_fire": true
      }
    }
  },
  "gltf_scale": 0.075,
  "first_person": {
    "anchor_node": "tag_camera",
    "camera_node": "tag_view",
    "use_camera_transform": true,
    "translation": {"x": 0, "y": 0, "z": 0},
    "rotation": {"x": 0, "y": 0, "z": 0},
    "scale": 1
  },
  "camera": {
    "model_fov": 50
  },
  "recoil": {
    "enabled": true,
    "hip": {
      "vertical": 1.0,
      "horizontal": 1.0,
      "model_back": 5.0,
      "randomness": 1.0,
      "recovery": 0.8
    },
    "ads": {
      "vertical": 1.0,
      "horizontal": 1.0,
      "model_back": 7.0,
      "randomness": 1.0,
      "recovery": 0.8
    }
  },
  "shell_effect": {
    "anchor_bone": "tag_brass"
  }
}
```

### 必须按自己资源修改的值

| 字段 | 必须检查什么 |
|---|---|
| `gltf_model` | 是否真实存在 |
| `animation_sources` | 是否真实存在，剪辑名是否一致 |
| 四个贴图路径 | 文件名和命名空间是否一致 |
| `duration_frame` | 是否等于各动作真实长度 |
| `gltf_scale` | 枪在游戏中的基础大小是否合理 |
| `first_person` 节点 | GLB 中是否存在 |
| `shell_effect.anchor_bone` | GLB 中是否存在 |

不要用 `first_person.translation` 修复枪口朝向错误，也不要用 `gltf_scale` 修复某一个配件的挂点比例。

## 第 8 步：第一次进游戏验收

复杂模型和动画库第一次加载时，建议完全重启游戏。进入世界后：

```text
/gwo reload
/gwo give firearm "tutorial:training_rifle"
/gwo give ammo "tutorial:training_ammo"
```

依次检查：

1. 枪能出现在物品栏。
2. 拿出时播放 `draw`。
3. 正常持有时位置稳定，不持续漂移。
4. 左键能射击并扣除弹量。
5. 开火时播放 `fire`。
6. 弹匣有余弹时换弹，真正上弹发生在 `action_commit_ms.reload`。
7. 完全打空后换弹，播放 `reload_empty`。
8. 收起时播放 `holster`。
9. 枪口效果和尾迹起点在 `tag_flash`。
10. 日志没有缺失剪辑、缺失节点、跨 skin 或 JSON 解析错误。

### 按症状定位，不要同时乱改

| 现象 | 先检查 |
|---|---|
| 创造栏没有枪 | 逻辑 JSON 路径、`id`、`render`、`/gwo reload` 日志 |
| 枪是黑紫色 | `texture` 或物品图标路径不存在 |
| 只显示一部分 | GLB 导出选择、节点可见性、材质透明度 |
| 枪方向反了 | Blender 中是否让枪口朝 `+X` |
| 枪大小错误 | 模型单位、应用缩放、`gltf_scale` |
| 动画完全不播 | `animation_sources`、剪辑名、`animation_clips`、状态机引用 |
| 换弹播了但弹量不变 | `mechanics.action_commit_ms` 是否存在且位于动作有效时段 |
| 枪口特效位置错 | `tag_flash` 的位置和朝向 |
| 弹壳位置错 | `tag_brass` 的位置和朝向 |
| 修改后没变化 | 重复 ID、另一个 ZIP 覆盖、未重载或缓存需重启 |

只有这十项通过，才进入下一阶段。

## 第 9 步：使用共用第一人称手臂

先阅读[手臂制作与运行时的区别](./arm-templates.md)。制作时手臂与枪放在一起做动作；游戏默认加载共用手臂网格，读取玩家皮肤，再跟随枪械动画中的手臂姿态。不是要求制作第二套动作。

使用现有共用骨架手臂时，在渲染 JSON 增加：

```jsonc
"first_person_arms": true,
"arms": {
  "enabled": true,
  "left_holder_bone": "LEFT_ARM",
  "right_holder_bone": "RIGHT_ARM",
  "poses": {
    "draw": {"blend_ticks": 5},
    "holster": {"blend_ticks": 5},
    "fire": {"blend_ticks": 2},
    "reload": {"blend_ticks": 6},
    "reload_empty": {"blend_ticks": 6}
  }
}
```

未填写 `arms.model` 时使用内置 `gwo:gltf/arms/arms.glb`。不需要每把枪或每个包重复导出一份手臂网格；但枪械动画中有效的手臂节点与轨道必须保留。两个 holder 名称需要对应实际动画节点，`blend_ticks` 调整交接，不代替正确的轨道和参考空间。

如确实需要自定义手臂外观，可额外配置 `arms.model` 并提供匹配的模型，这是进阶选项。Empty / Bedrock 独立手臂适配已在 `ad17487` 接入，配置方法与专门验收要求见[手臂模板](./arm-templates.md)。默认手臂和现有配置无需修改。

### 完成标准

- 使用玩家皮肤，普通/纤细手臂与外层选择正确。
- 待机、开火、换弹时双手握持正确。
- 动作结束无跳变，枪内没有重复显示制作时的预览手臂网格。

## 第 10 步：加入瞄准

在动画库增加：

```text
aim_in
aim_out
aim_fire
```

再按[动画制作与导出规范](animation.md)补：

- `animation_clips` 映射。
- `animation_events` 的 `aim_in`、`aim_out` 和 `aim_fire` 分类。
- `paired_aim_actions.fire = aim_fire`。
- `animation_machine.actions.aim` 的 enter/loop/exit。
- `animation_controller.channels` 中的 `aim_transition` 和瞄准开火通道。
- `tag_ads` 骨骼遮罩与 `keep_last_frame`。

瞄准应当用 `tag_ads` 和瞄准参考节点解决。不要通过移动准心贴图伪造对齐。

### 完成标准

- 按住瞄准后机瞄中心稳定对准屏幕中心。
- 退出瞄准不会闪回 idle 中间姿态。
- 瞄准开火使用 `aim_fire`，结束后仍保持正确瞄准位置。

## 第 11 步：加入声音

1. 把 OGG Vorbis 文件放入 `assets/tutorial/sounds/training_rifle/`。
2. 在 `assets/tutorial/sounds.json` 注册声音。
3. 枪声在逻辑 JSON 的 `sound_events` 中声明。
4. 换弹、检视、拉机柄等动作声音写入渲染 JSON 的 `animation_commands` 对应帧。

示例：

```json
{
  "training_rifle_fire": {
    "sounds": [
      "tutorial:training_rifle/fire"
    ]
  },
  "training_rifle_mag_in": {
    "sounds": [
      "tutorial:training_rifle/mag_in"
    ]
  }
}
```

枪械逻辑：

```jsonc
"sound_events": {
  "fire": "tutorial:training_rifle_fire"
}
```

动画帧：

```jsonc
"animation_commands": {
  "reload": [
    {"frame": 39, "type": "sound", "sound": "tutorial:training_rifle_mag_in"}
  ]
}
```

### 完成标准

- 枪声只触发一次，不与动画帧重复播放。
- 换弹动作声与画面帧一致。
- 空仓与普通换弹不会错误共用缺失的事件。

## 第 12 步：拆分默认部件

基础枪完全正常后，再把枪管、弹匣、枪托等拆成独立 GLB。每个默认部件需要：

1. 配件逻辑 JSON。
2. 配件渲染 JSON。
3. 正确 `slot`。
4. `default_installed: true`。
5. 与主枪真实存在的 `anchor_node`。
6. 枪渲染 JSON 的 `modules` 引用。
7. 和主枪相同的参考空间、比例和贴图图集。

第一次每次只加一个默认部件：枪管通过后再加弹匣，弹匣通过后再加枪托。详细格式见[配件、瞄具与挂饰](attachments-optics.md)。

### 完成标准

- 默认部件自动安装。
- 改装界面能识别槽位。
- 动画时弹匣和枪机跟随正确节点。
- 拆装配件不会让枪整体改变比例或方向。

## 第 13 步：补完整武器能力

按需要依次增加，不要为了“名字齐全”创建没有用途的空动画：

1. `draw_first`。
2. `fire_last`、`dry_fire` 和空仓附加姿态。
3. `inspect` 与 `inspect_empty`。
4. `sprint_*` 与 `super_sprint_*`。
5. 射击模式切换。
6. 武器近战。
7. 弹量模型与 `bullet_additive`。
8. 枪口火焰、烟雾、尾迹和抛壳。
9. Weapon Sway 与后坐力。
10. 第三人称、背负、展示框和改装界面变换。
11. 可选弹匣、枪管、瞄具、激光和挂饰。

武器类型分支：

| 类型 | 下一步参考 |
|---|---|
| 普通弹匣式步枪/手枪 | 本章结构 + [动画规范](animation.md) |
| `xmaglrg` 大型箱式弹匣 | 独立 `*_xmaglrg` 状态和提交时间 |
| `drummag` 鼓式弹匣 | 独立 `*_drummag` 状态，不能假装成 xmaglrg |
| 管式霰弹枪 | `reload_system.type: tube_per_round`，事件只写帧 |
| 栓动狙击枪 | `fire_rechamber` / `aim_fire_rechamber` 和循环恢复 |
| 独立近战 | 放 `weapons/melee/`，使用自己的组合攻击状态机 |

## 第 14 步：最终发布前验收

完成[调试、验收与发布](debugging-release.md)中的完整清单，并额外确认：

- 文件夹和 ZIP 不同时启用。
- ZIP 根目录没有多套一层文件夹。
- 所有 JSON 可被严格解析。
- 所有资源 ID 使用自己的命名空间。
- 没有引用本机绝对路径。
- 没有依赖被删除的测试文件。
- 不包含源 `.blend`、临时诊断、缓存、`.bak` 或无用重复资源。
- 全新游戏启动后第一次拿枪也正常，而不只是热重载后正常。

## 学习路线与查询路线

第一次制作请按以下顺序：

1. [下载并使用空内容包模板](empty-template.md)
2. 本页：从零制作第一把枪
3. [Blender 模型规范](models.md)
4. [动画制作与导出规范](animation.md)
5. [枪械、弹药与材质](firearms.md)
6. [配件、瞄具与挂饰](attachments-optics.md)
7. [声音、图标与改装界面](audio-ui.md)
8. [调试、验收与发布](debugging-release.md)

遇到具体字段时查参考页；不要跳过本页的阶段验收直接复制两千行完整枪械配置。
