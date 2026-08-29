---
title: 下载并使用空内容包模板
order: 2
category:
  - 零基础入门
---

# 下载并使用空内容包模板

这一页只解决一件事：建立一份目录正确、可以安全开始制作的 GWO 内容包。它不会自动生成枪，也不包含模型、动画、贴图、声音或旧兼容字段。

## 1. 下载

[下载 GWO 空内容包模板 ZIP](/gwo-wiki/downloads/gwo_empty_content_pack_template.zip)

同时提供：[Blender 3.3 第一人称手臂模板](/gwo-wiki/downloads/gwo_arms_template_blender33.blend)。

下载后先解压。制作期间不要直接编辑 ZIP，使用普通文件夹才能方便修改和重载。

## 2. 放入游戏

把解压得到的 `gwo_empty_content_pack` 整个文件夹放入：

```text
.minecraft/gwo/
```

结果应为：

```text
.minecraft/gwo/gwo_empty_content_pack/pack.mcmeta
```

不能变成：

```text
.minecraft/gwo/gwo_empty_content_pack/gwo_empty_content_pack/pack.mcmeta
```

启动游戏后，这个空模板不会增加任何物品，这是正常结果。它此时只证明内容包目录能被扫描。

## 3. 确定自己的命名空间

模板使用 `example`。先为自己的内容包决定一个只包含小写英文字母、数字和下划线的命名空间，例如：

```text
作者名：My Studio
命名空间：my_studio
```

把目录：

```text
assets/example/
```

重命名为：

```text
assets/my_studio/
```

以后所有资源 ID 都必须使用相同前缀：

```jsonc
"id": "my_studio:training_rifle"
```

下面这些写法是错误的：

```text
My Studio:training_rifle   有大写和空格
my-studio:training_rifle   使用了连字符
my_studio:Training Rifle   路径有大写和空格
```

## 4. 模板目录分别放什么

| 目录 | 放置内容 |
|---|---|
| `weapons/firearms/` | 枪械逻辑 JSON |
| `weapons/firearms/render/` | 枪械渲染、动画和显示 JSON |
| `weapons/melee/` | 独立近战逻辑 JSON |
| `weapons/melee/render/` | 独立近战渲染 JSON |
| `bullets/` | 弹药定义 |
| `attachments/<类别>/` | 配件逻辑 JSON |
| `attachments/render/<类别>/` | 配件渲染 JSON |
| `assets/<命名空间>/gltf/guns/` | 各把枪的默认模型 |
| `assets/<命名空间>/gltf/animations/` | 独立 `.anim.glb` 动画库 |
| `assets/<命名空间>/gltf/arms/` | 第一人称手臂 GLB |
| `assets/<命名空间>/gltf/attachments/` | 通用配件 GLB |
| `assets/<命名空间>/gltf/bullets/` | 整弹、弹壳或弹头 GLB |
| `assets/<命名空间>/skins/` | 基础色、法线、材质和自发光贴图 |
| `assets/<命名空间>/textures/item/` | 物品栏图标 |
| `assets/<命名空间>/textures/gui/hud/` | HUD 图标 |
| `assets/<命名空间>/sounds/` | OGG 声音 |
| `assets/<命名空间>/sounds.json` | 声音注册表 |
| `assets/<命名空间>/lang/` | 中文和英文语言文件 |

目录里的 `.gitkeep` 只是为了让空目录保留在 ZIP 和 Git 中。放入真实文件后可以删除，不会参与游戏逻辑。

## 5. 修改内容包描述

打开根目录的 `pack.mcmeta`：

```json
{
  "pack": {
    "pack_format": 48,
    "supported_formats": [34, 48],
    "description": "Empty GWO Content Pack"
  }
}
```

只修改 `description` 即可开始，例如：

```jsonc
"description": "My Studio Weapon Pack"
```

不要删除外层 `pack`，不要在 JSON 最后一项后留下逗号。

## 6. 建立工作副本

推荐保留一份未修改模板，每次制作新内容包时复制一份：

```text
gwo_empty_content_pack       原始模板
my_studio_weapon_pack       当前项目
```

不要让两个启用的内容包声明相同资源 ID。否则加载顺序会覆盖文件，让你误以为修改没有生效。

## 7. 第一次空包验收

启动游戏后检查 `logs/latest.log`：

1. 能看到 GWO 扫描 `.minecraft/gwo/`。
2. 没有 `Failed to read weapon definition`。
3. 没有 `Failed to read ammunition definitions`。
4. 没有资源路径或 JSON 语法错误。
5. 创造栏没有出现新枪——空模板本来就不包含枪。

如果第 5 条成立且前四条无错误，空模板已经安装正确。下一页开始制作第一把枪。

## 8. 发布 ZIP 时的结构

制作和测试完成后，压缩的是内容包里面的文件，不是外层文件夹。打开发布 ZIP 后必须直接看到：

```text
pack.mcmeta
weapons/
attachments/
bullets/
assets/
```

ZIP 中多套一层目录，是新作者最常见的发布错误。

## 9. 本模板的版本原则

- 面向 Minecraft 1.21.1 和当前 GWO 内容格式。
- 不包含旧版 `guns/` 目录；枪械必须放在 `weapons/firearms/`。
- 不包含已经废弃的兼容字段。
- 默认值不会替作者决定武器表现；实际枪械仍应明确写出当前需要保留的配置。

下一步：[从零制作第一把枪](first-firearm.md)。
