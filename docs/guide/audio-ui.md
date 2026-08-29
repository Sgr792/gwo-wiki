---
title: 声音、图标与改装界面
order: 7
category:
  - 内容包制作
---

## 17. 声音

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

```json
"animation_commands": {
  "reload": [
    {"frame": 0, "type": "sound", "sound": "example:example_rifle_reload_start"},
    {"frame": 20, "type": "sound", "sound": "example:example_rifle_mag_out"},
    {"frame": 39, "type": "sound", "sound": "example:example_rifle_mag_in"}
  ]
}
```

枪声、换弹、检视、拉机柄、近战和空击都应走游戏声音系统，才能被 Sound Physics Remastered 等物理声效模组处理。不要只在自定义渲染器里直接播放不可分类的客户端音频。

## 18. 图标、语言与创造栏

每种可获取内容都应提供图标：

```text
textures/item/guns/<id>.png
textures/item/attachments/<id>.png
textures/item/ammo/<id>.png
```

推荐使用 256×256 透明 PNG。GWO 默认内容包采用“亮色/白色模型 + 暗部和阴影”的视觉风格，并保留结构、凹槽、镂空和材质明暗；自定义内容包可以采用自己的美术风格，但同一内容包内应保持一致。

物品模型 JSON 仍应存在于 `assets/<namespace>/models/item/`，否则物品栏可能显示黑紫缺失纹理。

显示名可以直接写在内容 JSON 中；面向正式多语言发布时，同时补 `lang/zh_cn.json` 与 `lang/en_us.json`。`creative_category` 决定枪械类别，`creative_sort` 控制同类排序。手枪、步枪、霰弹枪、狙击枪和独立近战不要共用错误类别。

## 19. 改装界面和默认配件

一把枪的默认部件必须满足：

1. 配件 JSON 存在。
2. 配件渲染 JSON 存在。
3. 枪渲染 JSON 的 `modules` 收录它。
4. 配件 `default_installed` 为 `true`。
5. `anchor_node` 在枪或父配件中存在。
6. 默认部件模型与枪共享正确参考空间。

改装界面只选择“下一次换弹要使用的弹种”时，不应立即改写当前弹匣。生存模式下背包必须有至少一发目标弹种才能选择，实际换弹时装入可用数量并返还原弹；创造模式不受库存限制。

## 19.1 零基础声音接入顺序

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

## 19.2 图标制作与验收

1. 使用透明背景 PNG。
2. 枪械保持侧面轮廓，留出少量透明边距。
3. 不要为了“看清楚”把颜色整体提亮到失去原材质。
4. 同一内容包统一相机角度、轮廓大小、阴影和亮度。
5. `icon_texture` 用于物品/改装卡片图标；`hud.weapon_icon` 是明确指定的 HUD 武器图标。没有需要自定义 HUD 静态图时，不要随意拿物品图标路径替代。

游戏内分别检查创造栏、快捷栏、右下角 HUD、改装卡片和物品提示。某一处正常不代表所有 UI 路径都已正确配置。

## 19.3 语言文件

正式发布至少准备：

```text
assets/<namespace>/lang/zh_cn.json
assets/<namespace>/lang/en_us.json
```

如果 `display_name` 已直接写在内容 JSON 中，物品名称可以先显示；语言文件仍适合保存界面分类、说明和后续可翻译文本。两份 JSON 都必须是有效对象，不能写注释或尾随逗号。
