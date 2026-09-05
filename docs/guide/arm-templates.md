---
title: 手臂制作模板
category:
  - 模型与动画路线
---

# 手臂制作模板

先按[制作方式](./choose-workflow.md)选择软件，再下载对应模板。三份文件以同一套手臂为基础，不需要全部学习。

| 制作方式 | 可编辑源文件 | 说明 |
| --- | --- | --- |
| Blender 骨架 | [下载 arms.blend](/downloads/gwo_arms_template_blender33.blend) | Blender 3.3 原始骨架模板 |
| Blender Empty | [下载 arms_empty.blend](/downloads/arms_empty.blend) | Blender 3.3；网格绑定父级 Empty，不使用蒙皮 |
| Blockbench Bedrock | [下载 arms_blockbench.bbmodel](/downloads/arms_blockbench.bbmodel) | 可编辑分组与方块，另附[几何 JSON](/downloads/arms_blockbench.geo.json) |

::: warning 使用包含手臂适配的新构建
提交 `ad17487` 已接入 Empty GLB 和 Bedrock 几何的独立手臂子网格选择与姿态变换。自动测试覆盖左右手、普通/纤细切换、外层和子网格相对变换。常规游戏回归已通过，但两套新模板的专门游戏画面验收仍待完成；仅把源文件放进内容包不会自动启用。
:::


## 我们现在怎样使用手臂

GWO 已经使用**独立的共用手臂网格**：默认加载 `gwo:gltf/arms/arms.glb`，根据玩家选择普通/纤细手臂和皮肤外层，并使用玩家皮肤。

制作时，把手臂和枪放在同一工程中配合制作动作，检查握持、换弹、检视；游戏里由枪械动画提供手臂姿态，由共用模型提供可见手臂网格。**网格独立，动作仍与枪械配合。**不需要另做第二套手臂动画。

| 导出内容 | 用途 |
| --- | --- |
| 枪械网格与机构节点 | 显示枪体和可动部件 |
| 必需的手臂参考节点与动画轨道 | 驱动游戏手臂 |
| 制作时预览的手臂网格 | 使用共用手臂时，不必随每把枪重复导出 |
| 自定义 `arms.model` | 可选替换，需要匹配命名和参考空间 |

移除预览网格时不要连手臂动画轨道一起删除；也不要让预览手臂与游戏共用手臂重复显示。

默认仍使用原来的骨架手臂，不会自动换成新模板。刚性手臂沿用共用手臂的玩家皮肤绑定路径，子网格按实际父子关系归属到对应手臂部件，并保留相对位置、旋转和缩放，不依赖子网格文件名猜测。

## 打开与选择手臂类型

Blender 使用“文件 → 打开”，Blockbench 打开 `.bbmodel`。模板含左右手、普通宽度 `MALE`、纤细宽度 `SLIM` 和皮肤外层 `LAYER`。

- 普通与纤细手臂是替代版本，预览时不要同时显示。
- Empty 模板默认只在视口隐藏 SLIM。导出前仍要检查导出对象与可见性设置。
- 原始素材没有嵌入皮肤图片。预览可导入自己的 64×64 玩家皮肤；没有图片不代表 UV 丢失。

## 层级与动画对象

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

## 尺寸、UV 与导出

Empty 版保留原网格与 UV；Blockbench 版把细分长方体重建为 8 个可编辑方块，保留尺寸和 UV 映射，不保留多余三角面。

Bedrock 按 16 模型单位对应 1 渲染单位换算，模板已据此匹配原模型尺寸。不要再统一乘以 16 或缩放到 0.25。BBMODEL 编辑坐标与 Bedrock 导出坐标存在 X 轴约定差异，不要手工互抄。

`.blend`、`.bbmodel` 是制作源文件，不是模组加载资源。制作完成后按 [Empty 路线](./blender-empty.md)导出 GLB，或按 [Blockbench 路线](./blockbench.md)导出几何和动画 JSON。导出后重新打开检查。

## 在内容包中启用

下面是枪械配置中的片段，二选一填写 `arms.model`，不要重复添加两个 `arms` 对象。

Empty 版导出到 `assets/example/gltf/arms/arms_empty.glb`：

```json
{
  "arms": {
    "enabled": true,
    "model": "example:gltf/arms/arms_empty.glb",
    "left_holder_bone": "LEFT_ARM",
    "right_holder_bone": "RIGHT_ARM"
  }
}
```

Bedrock 版把几何文件放到 `assets/example/models/arms/arms_blockbench.geo.json`：

```json
{
  "arms": {
    "enabled": true,
    "model": "example:models/arms/arms_blockbench.geo.json",
    "left_holder_bone": "LEFT_ARM",
    "right_holder_bone": "RIGHT_ARM"
  }
}
```

把 `example` 替换为自己的命名空间。动作仍配置在枪械动画库中；`arms.model` 只选择手臂几何。保留上述八个 MALE/SLIM/LAYER 部件节点、左右手节点及参考空间。子网格可自行命名，但必须位于正确部件节点下。

重载内容包后，分别用普通和纤细玩家皮肤检查左右手、外层、握持、换弹、检视和光影表现。确认不出现重复手臂、偏移或丢失后再发布。
