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
