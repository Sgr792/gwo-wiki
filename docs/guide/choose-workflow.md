---
title: 选择制作方式
category:
  - 零基础入门
---

# 先选择模型与动画的制作方式

你不需要同时学习两套软件。先选择一条路线，在同一条路线完成模型和动画，再进入共用的内容包配置。

<div class="gwo-beginner-route">
  <a href="./blender-skinning.html"><span>01 · BLENDER</span><strong>骨骼蒙皮</strong><small>制作精细网格与需要弯曲变形的手臂，导出 GLB。</small></a>
  <a href="./blender-empty.html"><span>02 · BLENDER</span><strong>Empty 刚性动画</strong><small>使用空物体带动整块网格，适合枪械机构与机械部件。</small></a>
  <a href="./blockbench.html"><span>03 · BLOCKBENCH</span><strong>Bedrock 实体模型</strong><small>通过方块、分组和枢轴制作模型与数值动画，导出 JSON。</small></a>
</div>

## 不知道选哪条？

- 想制作精细枪模，同时制作会弯曲的手指和手臂：选择 **Blender 骨骼蒙皮**。
- 已经会 Blender，只需要弹匣移动、枪机旋转等整块运动：选择 **Blender Empty**。
- 喜欢方块风格，想在 Blockbench 中完成模型与动画：选择 **Blockbench Bedrock**。

“刚性”指一块网格整体移动、旋转或缩放，不会因为权重而弯曲。Empty 路线不替代手臂蒙皮，也不保证比骨骼路线有更高帧率。

::: warning 新增路线的版本要求
Empty 无 Skin 动画与 Bedrock 支持需要包含本次格式更新的开发版。自动测试已通过，游戏显示仍需验收。旧版不代表已支持；Blockbench 路线只支持实体方块模型与数值关键帧，不运行 Molang 或实体控制器。
:::

## 教程顺序

1. 选择上面一条路线。
2. 按该路线完成软件准备、模型、层级与挂点、UV、动画和导出检查。
3. 阅读[快速开始](./getting-started.md)，准备游戏环境。
4. [下载空内容包模板](./empty-template.md)，建立配置。
5. 进入[从零制作第一把枪](./first-firearm.md)，完成共用的逻辑、事件、材质和游戏测试。
6. 按[调试与发布](./debugging-release.md)完成验收。

[格式与支持范围](./bedrock-empty.md)供需要查询具体字段的创作者使用，不是另一条必须学习的路线。

