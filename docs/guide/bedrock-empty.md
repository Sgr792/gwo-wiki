---
title: 格式与支持范围
category:
  - 内容包制作
---

::: warning 版本与验收状态
需要包含本次格式接入更新的开发版构建；此前发布的版本不代表已支持。本次自动测试通过，游戏画面仍需验收。
:::

## 接入方式

本页只作格式与配置参考。软件操作请先[选择制作方式](./choose-workflow.md)，进入独立的 Blender 或 Blockbench 路线。

以下三种模型使用相同的 GWO 配置、动画状态和渲染流程：

- 原有 GLB Armature / Skin 骨骼模型。
- Blender Empty 父子层级、网格作为子物体的刚性 GLB。
- Blockbench 导出的 Bedrock 实体几何 JSON 与数值动画 JSON。

不需要离线编译、格式转换工具或其他模组。以下配置片段添加到已有 GWO 枪械定义中；它们不是完整的枪械定义。

## Bedrock 文件与配置

将资源放入自己的命名空间，例如：

```text
assets/example/models/example.geo.json
assets/example/animations/example.animation.json
assets/example/textures/example.png
```

```jsonc
{
  "gltf_model": "example:models/example.geo.json",
  "texture": "example:textures/example.png",
  "animation_sources": ["example:animations/example.animation.json"],
  "animation_clips": {
    "static_idle": "animation.example.idle",
    "draw": "animation.example.draw",
    "fire": "animation.example.fire"
  }
}
```

`gltf_model` 保留现有字段名，现在也接受 `.geo.json`。路径需要包含扩展名。
`animation_clips` 右侧必须与动画 JSON 中的完整名字一致，不会自动删除 `animation.` 前缀。
法线、自发光、反射、透明节点与配件挂点仍使用 GWO 自己的配置。
开火、装弹提交和声音事件仍配置在 GWO 中，不导入 Bedrock 实体事件。

### 本版支持范围

- 单个 `minecraft:geometry` 的实体立方体模型、骨骼层级、pivot 和初始旋转。
- cube origin、size、pivot、rotation、inflate；同一骨骼的方块合为一个网格。
- 盒式 UV、每面 UV、负 `uv_size`、mirror；每面 UV 中省略的面不会绘制。
- locator 作为命名挂点，支持 offset 和 rotation。
- 动画 position / rotation / scale 数值常量、数值关键帧、linear / catmullrom 插值、pre / post。
- 循环、非循环、`hold_on_last_frame` 和没有时长的静态姿态。
- 位置单位按 16 模型单位 = 1 渲染单位换算；旋转是角度，并以模型初始姿态为基准。

本版不运行 Molang、Bedrock 实体动画控制器、实体粒子/声音事件；不支持 `poly_mesh`、每面 `material_instance`、`relative_to`、`ignore_inherited_scale` 和运行时动画时间表达式。
相关不支持的变换字段会明确报错，避免静默显示错误姿态。需要表达式效果时，先在制作工具中烘焙成数值关键帧。
一个几何文件只放一个 geometry；不要把多个实体定义混在一起。

## Blender Empty 刚性 GLB

可使用下面的父子结构（示例名字不代表全部必需挂点）：

```text
root (Empty)
└─ tag_weapon (Empty)
   ├─ receiver (Mesh)
   └─ bolt (Empty)
      └─ bolt_mesh (Mesh)
```

上面的结构只演示刚性父子关系，不是完整第一人称骨架；正式武器仍应遵守[模型规范](./models.md)中的 `root → tag_view → tag_ads → tag_weapon` 主链。

给 Empty 或 Mesh 的位置、旋转、缩放设置关键帧，子物体自动继承。
不需要 Armature、顶点组或权重。网格不会弯曲；需要手臂、布料等变形时继续使用骨骼蒙皮。

```jsonc
{
  "gltf_model": "example:models/example.glb",
  "texture": "example:textures/example.png",
  "animation_sources": ["example:animations/example.anim.glb"]
}
```

动画也可以和模型一起导出在同一个 GLB 中，此时不必另填 `animation_sources`。

### 导出要求

1. 导出模型时包含完整 Empty 层级，不只选择 Mesh。
2. 开启动画导出；检查所有需要的 Action / NLA 剪辑是否进入 GLB。
3. 独立动画 GLB 与模型 GLB 的节点名、父子级和初始变换必须一致。
4. 动画节点使用唯一名字；不要把父物体变换重复烘焙到网格。
5. 约束、驱动器与制作工具专属效果需先烘焙成位置、旋转、缩放关键帧。
6. 此次新增的是纯刚性无 Skin 模型路径，不扩大原有多 Armature 或混合骨架导出的兼容范围。

## 验收

自动测试覆盖真实无 Skin GLB 导入、Empty 动画轨道、父子变换、Bedrock 挂点与立方体、UV 和动画插值。
自动构建通过不等于游戏画面已经验收。发布前还需检查：

- 基础姿态、掏出、开火、换弹和检视。
- Empty 子网格和 Bedrock locator 是否跟随。
- 纹理方向、透明节点、普通环境与 Iris 光影。
- 原有骨骼 GLB 枪械是否保持正常。

格式字段以 [Mojang 官方模型 Schema](https://mojang.github.io/bedrock-samples/Schemas.html) 为依据；本页列出的是 GWO 当前实现范围，而不是整个 Bedrock 实体引擎。


## 版本基线

本格式说明核对的实现基线是提交 `b6d52ab`（2026-09-05）。这是实现版本标记，不是发布下载入口，也不代表游戏验收通过。仅凭 `2.12.87` 版本号无法区分此前构建；应使用明确包含该实现的构建，画面验收仍待完成。

独立手臂子网格适配在 `ad17487` 加入，详见[手臂模板与配置](./arm-templates.md)。该构建的 1346 项自动测试和完整构建通过，常规游戏回归已确认正常；这不代替 Empty / Bedrock 新手臂模板的专门画面验收。此次代码清理没有改变内容包格式和现有资源。

当前加载器未处理 Bedrock 每面 UV 的 `uv_rotation`。导出资源不要依赖面 UV 旋转，应调整贴图布局与 UV 矩形使其无需此字段。导入成功不表示未支持字段已经生效。
