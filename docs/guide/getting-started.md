---
title: 快速开始
order: 1
category:
  - 内容包制作
---

## 1. 开始前要准备什么

还没有选择软件与制作方式？先进入[选择制作方式](./choose-workflow.md)，完成其中一条模型与动画路线，再返回本页准备共用环境。

建议准备：

- Minecraft 1.21.1、匹配版本的 NeoForge 和 GWO。
- 制作软件按路线选择：Blender（模板使用 3.3）或 Blockbench；不要求同时安装。
- [GWO 手臂制作模板（Blender 3.3）](/downloads/gwo_arms_template_blender33.blend)，用于建立与示例骨架一致的第一人称手臂。
- 能保存 UTF-8 无 BOM JSON 的编辑器，例如 VS Code。
- PNG 图片编辑工具。
- 能输出 OGG Vorbis 的音频工具。
- [GWO 空内容包模板](/downloads/gwo_empty_content_pack_template.zip)，用于从当前目录格式开始制作，不包含旧兼容内容。

GWO 使用以下主要资源格式：

| 资源 | 格式 |
|---|---|
| 枪械、配件、子弹、手臂模型 | `.glb` |
| 独立动画库 | `.anim.glb` |
| Bedrock 实体方块模型（新增开发版） | `.geo.json` |
| Bedrock 数值动画库（新增开发版） | `.animation.json` |
| 基础色、法线、材质、自发光、图标 | `.png` |
| 声音 | `.ogg`，Vorbis 编码 |
| 行为和渲染配置 | `.json` |
| 内容包元数据 | `pack.mcmeta` |

文件名、目录名和资源 ID 一律建议使用小写英文字母、数字和下划线。不要使用空格、中文、括号或大写字母作为资源路径。

Blender 也可制作 Empty 刚性 GLB；使用 Blockbench 的创作者可选择 Bedrock 实体模型。先阅读 [Bedrock 与 Empty 动画](./bedrock-empty.md)的版本要求、支持范围和配置示例。

## 2. 内容包放在哪里

把内容包放入当前游戏实例的：

```text
.minecraft/gwo/
```

支持两种形式：

1. 普通文件夹，最适合开发和调试。
2. `.zip`，适合普通分发。

ZIP 根目录必须直接看见 `pack.mcmeta`、`weapons`、`bullets` 和 `assets`，不能再多包一层同名文件夹。

正确：

```text
my_pack.zip
├─ pack.mcmeta
├─ weapons/
├─ bullets/
└─ assets/
```

错误：

```text
my_pack.zip
└─ my_pack/
   ├─ pack.mcmeta
   └─ ...
```

开发时仍建议主动保留正确的 `pack.mcmeta`。普通文件夹缺失该文件时，GWO 会生成一份基础元数据作为安全兜底；ZIP 无法在包内补写，因此发布 ZIP 的根目录必须预先包含正确的 `pack.mcmeta`。

## 3. 推荐的完整目录结构

以下使用命名空间 `example` 和武器 ID `example_rifle`：

```text
example_pack/
├─ pack.mcmeta
├─ weapons/
│  ├─ firearms/
│  │  ├─ example_rifle.json
│  │  └─ render/
│  │     └─ example_rifle.render.json
│  └─ melee/
│     ├─ example_knife.json
│     └─ render/
│        └─ example_knife.render.json
├─ attachments/
│  ├─ barrels/
│  ├─ bolts/
│  ├─ casings/
│  ├─ cosmetics/
│  ├─ lasers/
│  ├─ magazines/
│  ├─ muzzles/
│  ├─ rear_grips/
│  ├─ sights/
│  ├─ stocks/
│  ├─ triggers/
│  ├─ underbarrels/
│  └─ render/
│     └─ 对应类别/
├─ bullets/
│  └─ example_ammo.json
└─ assets/
   └─ example/
      ├─ gltf/
      │  ├─ animations/
      │  │  └─ example_rifle_receiver_default.anim.glb
      │  ├─ arms/
      │  │  └─ arms.glb
      │  ├─ guns/
      │  │  └─ example_rifle/
      │  │     ├─ example_rifle_receiver_default.glb
      │  │     ├─ example_rifle_barrel_default.glb
      │  │     ├─ example_rifle_mag_default.glb
      │  │     └─ example_rifle_stock_default.glb
      │  ├─ attachments/
      │  └─ bullets/
      │     ├─ unspent_example_ammo.glb
      │     └─ spent_example_ammo.glb
      ├─ skins/
      │  ├─ guns/
      │  ├─ attachments/
      │  └─ bullets/
      ├─ textures/
      │  ├─ item/
      │  │  ├─ guns/
      │  │  ├─ attachments/
      │  │  └─ ammo/
      │  └─ sights/
      ├─ models/item/
      ├─ lang/
      │  ├─ zh_cn.json
      │  └─ en_us.json
      ├─ sounds/
      └─ sounds.json
```

默认枪管、弹匣、枪托等属于某把枪的模型，统一放进 `gltf/guns/<枪械 ID>/`。通用可选配件放 `gltf/attachments/`，不要把枪本体默认部件散落进通用配件目录。

## 4. `pack.mcmeta`

当前 1.21.1 示例：

```json
{
  "pack": {
    "pack_format": 48,
    "supported_formats": [34, 48],
    "description": "Example GWO Content Pack"
  }
}
```

## 5. 资源 ID 与路径规则

资源位置写成：

```text
命名空间:命名空间内路径
```

例如：

```jsonc
"id": "example:example_rifle",
"gltf_model": "example:gltf/guns/example_rifle/example_rifle_receiver_default.glb",
"texture": "example:skins/guns/example_rifle.png"
```

`example:gltf/...` 对应实际文件：

```text
assets/example/gltf/...
```

行为 JSON 中引用另一个内容包文件时，使用相对内容包根目录的路径，例如：

```jsonc
"render": "weapons/firearms/render/example_rifle.render.json"
```

## 6. 推荐制作顺序

零基础作者先完成[从零制作第一把枪](first-firearm.md)。不要一次把所有系统都填满。最稳定的顺序是：

1. 建立目录和 `pack.mcmeta`。
2. 先导出机匣主模型和最小动画库。
3. 制作弹药定义。
4. 制作枪械逻辑 JSON。
5. 制作枪械渲染 JSON，只启用 `static_idle`、`draw`、`holster`、`fire`、`reload`。
6. 进游戏确认枪能生成、模型方向正确、可以射击和换弹。
7. 分离并挂载默认配件。
8. 增加完整动画机、瞄准、奔跑、空仓、检视、近战和声音事件。
9. 增加可选配件、瞄具、激光和挂饰。
10. 完成第三人称、展示框、改装界面、地面掉落和图标。
11. 用文件夹完成验收，需要分发时再打包为 ZIP。
