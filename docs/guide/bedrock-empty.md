---
title: GLB 与 Empty 动画
category:
  - 模型与动画
---

# GLB 与 Empty 动画

枪械内容包已取消 Bedrock `.geo.json` 模型和 `.animation.json` 动画的直接加载。`.bbmodel` 是编辑源文件，不能直接加载。请使用 GLB/glTF 模型和 GLB 动画库；骨骼蒙皮与 Blender Empty 刚性动画继续支持。

内置靶子和工作台使用独立读取器，它们的 JSON 资源不属于枪械内容包格式。

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


发布内容包前，请在游戏中检查以下项目：

- 基础姿态、掏出、开火、换弹和检视。
- Empty 子网格和挂点 是否跟随。
- 纹理方向、透明节点、普通环境与 Iris 光影。
- 原有骨骼 GLB 枪械是否保持正常。
