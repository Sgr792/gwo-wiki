---
title: Blockbench 格式支持已移除
---

# Blockbench 格式支持已移除

GWO 枪械内容包不再直接加载 Bedrock 几何和动画 JSON。已有 `.bbmodel` 可保留为制作源文件，但保存或修改扩展名不能将它转换为 GLB。

请导出或转换为 GLB，重新核对节点名称、层级、UV、枢轴和动画剪辑后再接入。转换不是自动适配，动画可能需要重新整理。

继续查看 [Blender 骨骼蒙皮](./blender-skinning.md)、[Blender Empty](./blender-empty.md)与[格式配置](./bedrock-empty.md)。
