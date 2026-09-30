---
title: 声音、图标与改装界面
order: 7
category:
  - 内容包制作
---

## 声音

音频要求：

- OGG 容器。
- Vorbis 编码。
- 建议单声道用于位置声，多声道只在确有必要时使用。
- 不要把多个动作重复混进同一音频，又在事件帧中重复播放。
- 保留需要的完整尾音，不要无故裁断。

`assets/example/sounds.json` 示例：

```json
{
  "example_rifle_fire": {
    "sounds": [
      {
        "name": "example:example_rifle/fire",
        "stream": false
      }
    ]
  },
  "example_rifle_mag_in": {
    "sounds": [
      "example:example_rifle/mag_in"
    ]
  }
}
```

对应文件：

```text
assets/example/sounds/example_rifle/fire.ogg
assets/example/sounds/example_rifle/mag_in.ogg
```

动画帧事件：

```jsonc
"animation_commands": {
  "reload": [
    {"frame": 0, "type": "sound", "sound": "example:example_rifle_reload_start"},
    {"frame": 20, "type": "sound", "sound": "example:example_rifle_mag_out"},
    {"frame": 39, "type": "sound", "sound": "example:example_rifle_mag_in"}
  ]
}
```

枪声、换弹、检视、拉机柄、近战和空击都应走游戏声音系统，才能被 Sound Physics Remastered 等物理声效模组处理。不要只在自定义渲染器里直接播放不可分类的客户端音频。

## 图标、语言与创造栏

每种可获取内容都应提供图标：

```text
textures/item/guns/<id>.png
textures/item/attachments/<id>.png
textures/item/ammo/<id>.png
```

推荐使用 256×256 透明 PNG。GWO 默认内容包采用“亮色/白色模型 + 暗部和阴影”的视觉风格，并保留结构、凹槽、镂空和材质明暗；自定义内容包可以采用自己的美术风格，但同一内容包内应保持一致。

物品模型 JSON 仍应存在于 `assets/<namespace>/models/item/`，否则物品栏可能显示黑紫缺失纹理。

显示名可以直接写在内容 JSON 中；面向正式多语言发布时，同时补 `lang/zh_cn.json` 与 `lang/en_us.json`。`creative_category` 决定枪械类别，`creative_sort` 控制同类排序。手枪、步枪、霰弹枪、狙击枪和独立近战不要共用错误类别。

## 改装界面和默认配件

一把枪的默认部件必须满足：

1. 配件 JSON 存在。
2. 配件渲染 JSON 存在。
3. 枪渲染 JSON 的 `modules` 收录它。
4. 配件 `default_installed` 为 `true`。
5. `anchor_node` 在枪或父配件中存在。
6. 默认部件模型与枪共享正确参考空间。

改装界面只选择“下一次换弹要使用的弹种”时，不应立即改写当前弹匣。生存模式下背包必须有至少一发目标弹种才能选择，实际换弹时装入可用数量并返还原弹；创造模式不受库存限制。

### 部位预览角度

在枪械的渲染配置文件 `weapons/firearms/render/<武器ID>.render.json` 中编辑 `modify_screen`。它的 `translation`、`rotation`、`scale` 控制整枪总览；`preview_camera` 控制选择配件部位后的观察角度。

将下面片段合并到现有 `modify_screen`，保留原来的整枪位置和缩放：

```jsonc
"preview_camera": {
  "transition_ms": 200,
  "parts": {
    "sight": {
      "anchor_node": "tag_reflex",
      "rotation": {"x": -20, "y": 0, "z": 0},
      "zoom": 1.5,
      "offset": {"x": 0, "y": 0, "z": 0},
      "follow_node_rotation": false
    }
  },
  "modules": {
    "example_optic": {
      "zoom": 1.4
    }
  }
}
```

| 字段 | 作用 |
| --- | --- |
| `transition_ms` | 切换部位的过渡时间，默认 200 毫秒，范围 0–2000；0 表示立即切换 |
| `parts` | 按槽位设置镜头，例如 `sight`、`laser`、`magazine`、`stock`、`barrel`、`muzzle` |
| `modules` | 按配件覆盖设置；键必须是本枪 `modules` 中的配件键，不是显示名称 |
| `anchor_node` | 观察中心节点；示例节点需换成自己模型中实际存在的节点，省略时使用配件挂点 |
| `rotation` | 相对整枪预览的观察旋转，单位为度 |
| `zoom` | 部位预览倍率，范围 0.1–8，不是瞄准倍率 |
| `offset` | 聚焦后的预览空间位置偏移，不是下面子弹预览使用的界面像素偏移 |
| `follow_node_rotation` | 默认 false，仅跟随挂点位置；true 时还跟随节点朝向 |

配件配置覆盖部位配置，未填写字段继承部位及武器类别预设。`rotation` 与 `offset` 也支持 `[x, y, z]`。观察方向由这些参数手动设置，不会根据配件安装在哪一侧自动转向；镭射在另一面看不到时，调整该配件的旋转覆盖项。

选择部位后以静态模型挂点为观察中心平滑切换，返回总览恢复整枪视图。无法确定有效挂点时保留总览，可用 `anchor_node` 明确指定。弹药页保持整枪总览，不使用弹匣部位的放大视图。

### 机匣下方的子弹预览

弹药页使用弹药定义的 `models.cartridge` 模型和材质。悬停弹药卡片会切换预览，移开后恢复已选弹药；悬停本身不更换当前弹匣中的子弹。

在同一个 `modify_screen` 对象中加入：

```jsonc
"ammo_preview": {
  "translation": {"x": 0, "y": 80, "z": 0}
}
```

- `x`：相对机匣原点的左右偏移，正值向右。
- `y`：相对机匣原点的向下距离，默认 80；减小则向上移动。
- `z`：相对渲染深度，建议保持 0，不控制子弹大小。

单位按 960×540 界面设计坐标计算，会随界面整体缩放。也可以写成 `"translation": [0, 80, 0]`；省略配置时使用相同默认值。例如 `{"x": -20, "y": 100, "z": 0}` 会向左移动 20、显示在机匣下方 100 的位置。

预览尺寸复用枪内子弹的缩放链，包含枪械、弹匣、挂点和弹药自身缩放，不会按预览区域自动放大。`ammo_preview.translation` 只移动独立子弹，不改变枪体、子弹尺寸或朝向。没有可用的 `models.cartridge` 时显示缺少模型提示。请使用支持这些字段的模组版本；旧版不会因为补写配置就自动支持。

### 零基础声音接入顺序

每次只接入一个声音事件：

1. 把 OGG 放进 `assets/<namespace>/sounds/<武器ID>/`。
2. 在 `sounds.json` 注册逻辑声音名。
3. 先用开火事件确认声音能被找到。
4. 再把换弹、检视、枪机和近战动作声写进 `animation_commands`。
5. 完全重启一次，确认不是热重载缓存造成的“偶尔有声音”。

命名示例：

```text
文件：assets/example/sounds/example_rifle/mag_in.ogg
注册值：example:example_rifle/mag_in
事件 ID：example:example_rifle_mag_in
```

这三个层级分别是文件、`sounds.json` 内的资源值和配置中引用的声音事件，不是同一个字符串。

### 图标制作与验收

1. 使用透明背景 PNG。
2. 枪械保持侧面轮廓，留出少量透明边距。
3. 不要为了“看清楚”把颜色整体提亮到失去原材质。
4. 同一内容包统一相机角度、轮廓大小、阴影和亮度。
5. `icon_texture` 用于物品/改装卡片图标；HUD 优先使用实时生成的武器图标；只有实时图标绘制失败时才回退到 `hud.weapon_icon`，未配置时再使用内置回退图。该字段不会强制覆盖正常的实时图标。回退图按 512×256 使用，不要直接拿正方形物品图标代替。

游戏内分别检查创造栏、快捷栏、右下角 HUD、改装卡片和物品提示。某一处正常不代表所有 UI 路径都已正确配置。

### 语言文件

正式发布至少准备：

```text
assets/<namespace>/lang/zh_cn.json
assets/<namespace>/lang/en_us.json
```

如果 `display_name` 已直接写在内容 JSON 中，物品名称可以先显示；语言文件仍适合保存界面分类、说明和后续可翻译文本。两份 JSON 都必须是有效对象，不能写注释或尾随逗号。


### HUD 缩放与状态提示

枪械图标、弹量和防弹插板 HUD 按窗口尺寸及 GUI 缩放统一调整。枪械 HUD 保持右下角锚点；插板 HUD 保持与原版快捷栏的底部间距，缩小窗口时不按旧画布位置漂移。

当前版本不再向快捷栏上方或聊天栏发送枪械状态通知，包括激光、倍镜、倍率、侧瞄、测距锁定、装填和改装结果。操作和校验逻辑继续执行，瞄具米数和常驻 HUD 正常显示。旧动画命令 `show_msg` 仍可解析，但不显示文字。


字段的作用、单位、默认值和调参影响可查 [内容包参数参考](parameters.md)。动画控制与混合见 [Lua 动画机](lua-animation.md)。
