---
title: 独立手臂源模板
category:
  - 模型与动画路线
---

# 独立手臂源模板

先按[制作方式](./choose-workflow.md)选择软件，再下载对应模板。三份文件以同一套手臂为基础，不需要全部学习。

| 制作方式 | 可编辑源文件 | 说明 |
| --- | --- | --- |
| Blender 骨架 | [下载 arms.blend](/downloads/gwo_arms_template_blender33.blend) | Blender 3.3 原始骨架模板 |
| Blender Empty | [下载 arms_empty.blend](/downloads/arms_empty.blend) | Blender 3.3；网格绑定父级 Empty，不使用蒙皮 |
| Blockbench Bedrock | [下载 arms_blockbench.bbmodel](/downloads/arms_blockbench.bbmodel) | 可编辑分组与方块，另附[几何 JSON](/downloads/arms_blockbench.geo.json) |

::: warning 源模板与游戏支持是两回事
新增的 Empty、Bedrock 手臂源模板已完成层级、位置和 UV 数据检查，但独立手臂的游戏接入、玩家皮肤绑定和动画表现尚未验收。本页提供制作素材，不表示把文件放进内容包就会自动启用。此次没有修改模组的独立手臂加载代码。
:::

## 1. 打开与选择手臂类型

Blender 使用“文件 → 打开”，Blockbench 打开 `.bbmodel`。模板含左右手、普通宽度 `MALE`、纤细宽度 `SLIM` 和皮肤外层 `LAYER`。

- 普通与纤细手臂是替代版本，预览时不要同时显示。
- Empty 模板默认只在视口隐藏 SLIM。导出前仍要检查导出对象与可见性设置。
- 原始素材没有嵌入皮肤图片。预览可导入自己的 64×64 玩家皮肤；没有图片不代表 UV 丢失。

## 2. 层级与动画对象

```text
arms_root
├─ RIGHT_ARM
│  └─ INNER_R
│     ├─ R_MALE / R_MALE_LAYER
│     └─ R_SLIM / R_SLIM_LAYER
└─ LEFT_ARM
   └─ INNER_L
      ├─ L_MALE / L_MALE_LAYER
      └─ L_SLIM / L_SLIM_LAYER
```

斜杠表示两个同级节点。Empty 版各部件节点下还有对应的 `_mesh` 网格。保留这些名称与父子关系，不要把左右手直接绑定到枪体网格。

Empty 版给 Empty 打位置、旋转、缩放关键帧；Blockbench 版给分组打关键帧。它们带动整块手臂，不会产生肘部或手指的蒙皮弯曲。模板没有预制待机、开火、换弹等动画。

## 3. 尺寸、UV 与导出

Empty 版保留原网格与 UV；Blockbench 版把细分长方体重建为 8 个可编辑方块，保留尺寸和 UV 映射，不保留多余三角面。

Bedrock 按 16 模型单位对应 1 渲染单位换算，模板已据此匹配原模型尺寸。不要再统一乘以 16 或缩放到 0.25。BBMODEL 编辑坐标与 Bedrock 导出坐标存在 X 轴约定差异，不要手工互抄。

`.blend`、`.bbmodel` 是制作源文件，不是模组加载资源。制作完成后按 [Empty 路线](./blender-empty.md)导出 GLB，或按 [Blockbench 路线](./blockbench.md)导出几何和动画 JSON。导出后重新打开检查；游戏独立手臂适配仍需单独验证。
