---
title: 权威参考文件
order: 9
category:
  - 内容包制作
---

## 25. 权威参考文件

制作新内容时按武器类型复制最接近的现有实现：

| 类型 | 逻辑文件 | 渲染文件 |
|---|---|---|
| 突击步枪/弹匣式长枪 | `weapons/firearms/m4.json` | `weapons/firearms/render/m4.render.json` |
| 手枪 | `weapons/firearms/staccato_2011_p.json` | `weapons/firearms/render/staccato_2011_p.render.json` |
| 管式霰弹枪 | `weapons/firearms/m590a1.json` | `weapons/firearms/render/m590a1.render.json` |
| 栓动狙击枪 | `weapons/firearms/cheytac_m200.json` | `weapons/firearms/render/cheytac_m200.render.json` |
| 独立近战 | `weapons/melee/karambit.json` | `weapons/melee/render/karambit.render.json` |
| 增倍镜 | `attachments/sights/sz_bullseye_optic.json` | `attachments/render/sights/sz_bullseye_optic.render.json` |
| 激光器 | `attachments/lasers/1mw_laser_box.json` | `attachments/render/lasers/1mw_laser_box.render.json` |
| 大型箱式扩容弹匣（xmaglrg） | `attachments/magazines/m4_xmaglrg.json` | `attachments/render/magazines/m4_xmaglrg.render.json` |
| 鼓式弹匣（drummag，模型与配件定义） | `attachments/magazines/rm277_drummag.json` | `attachments/render/magazines/rm277_drummag.render.json` |
| 弹药 | `bullets/5_56x45.json` | 同一文件包含模型材质定义 |

这些路径均相对于[官方示例内容包](https://github.com/Sgr792/gwo/tree/main/work/example-contentpack)根目录。字段与结构以当前版本示例和加载器校验结果为准。
