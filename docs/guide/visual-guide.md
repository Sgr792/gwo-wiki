---
title: 图解索引
category:
  - 零基础入门
---

# 图解索引

这些图解已放进对应教程的操作步骤旁边。图中使用教学示意，不是 Blender / Blockbench 界面截图，也不是游戏效果截图；软件按钮以对应路线的文字说明为准。

图片支持点击打开原图；手机上可以打开后缩放查看。所有步骤仍保留文字说明，不需要只靠颜色或图片理解。

| 图解与教程 | 要检查什么 | 原图 |
|---|---|---|
| [三条路线如何汇合](./choose-workflow.md) | 选择软件，不必重复学习。 | [查看原图](/images/guide/zh/workflow.svg) |
| [第一人称父子层级](./models.md) | 看清相机与瞄准分支。 | [查看原图](/images/guide/zh/hierarchy.svg) |
| [权重、父级与枢轴](./blender-empty.md) | 判断到底是谁在带动网格。 | [查看原图](/images/guide/zh/rigid-pivot.svg) |
| [默认配件挂点](./attachments-optics.md) | 核对挂点与部件参考空间。 | [查看原图](/images/guide/zh/anchors.svg) |
| [动画轨道所有权](./animation.md) | 无关静态关键帧也要删除。 | [查看原图](/images/guide/zh/animation-tracks.svg) |
| [贴图到材质配置](./firearms.md) | 分清基础色、法线、高光和发光。 | [查看原图](/images/guide/zh/materials.svg) |
| [导出与重新导入检查](./blockbench.md) | 区分源工程与游戏加载文件。 | [查看原图](/images/guide/zh/export-check.svg) |
| [资源 ID 与真实路径](./first-firearm.md) | 沿路径检查资源缺失。 | [查看原图](/images/guide/zh/resource-path.svg) |

<figure class="gwo-guide-figure">
  <a href="/images/guide/zh/workflow.svg" target="_blank" rel="noopener" aria-label="查看路线图原图">
    <img src="/images/guide/zh/workflow.svg" alt="先选一条制作路线" width="960" height="610" loading="lazy" decoding="async" />
  </a>
  <figcaption>先选一条路线，完成模型与动画后再进入共用配置。</figcaption>
</figure>

## 跟着图解完成一次检查

1. 按自己使用的软件完成 [Blender 骨骼蒙皮](./blender-skinning.md)、[Blender Empty](./blender-empty.md) 或 [Blockbench](./blockbench.md)。
2. 对照层级图和挂点图，逐个移动父节点，观察子部件是否正确跟随。
3. 对照轨道图检查瞄准动作，再按动画规范检查其他动作；图中的禁止轨道不能机械套用到所有动画。
4. 重新导入导出文件，检查节点、姿态和时长，再进入游戏验收。
