---
title: Blender 模型规范
order: 2
category:
  - 内容包制作
---

## 7. Blender 模型规范

### 7.1 坐标与单位

GWO 当前内容以枪口朝模型 `+X` 方向为基准。不要只靠 JSON 把一把方向完全错误的枪硬转正，否则枪口、弹壳、激光、第三人称和配件坐标会互相不一致。

建议：

- 在 Blender 中应用网格对象的旋转和缩放。
- 保持骨架、网格和动画库使用同一绑定姿态。
- 模型原点、骨架原点和导出选择保持一致。
- 不要在导出前随意应用骨架对象变换。
- 枪械、默认配件、动画库和独立手臂必须来自同一套骨骼命名和参考空间。

### 7.2 主骨骼与常用挂点

不同武器不必拥有所有节点，但已经写进配置的节点必须真实存在。

| 节点 | 作用 |
|---|---|
| `root` | 枪械根节点 |
| `tag_weapon` | 第一人称枪械/手部主要参考节点 |
| `tag_view` | 第一人称视角位置 |
| `tag_camera` | 相机动画节点，只用于相机姿态 |
| `tag_ads` | 瞄准定位和瞄准过渡 |
| `tag_align_gun` | 武器对齐参考 |
| `tag_weapon_focus` | 武器焦点参考 |
| `tag_flash` 或内容指定枪口节点 | 枪口火焰和尾迹起点 |
| `tag_brass` | 抛壳起点 |
| `tag_cosmetic` | 挂饰挂点 |
| `tag_barrel_attach` | 枪管挂点 |
| `tag_mag_attach` | 弹匣挂点 |
| `tag_stock_attach` | 枪托挂点 |
| `tag_pistolgrip_attach` | 后握把挂点 |
| `tag_trigger_attach` | 扳机组件挂点 |
| `tag_guard_attach` | 护木/泵动护木挂点 |
| `tag_laser_attach` | 激光器模型挂点 |
| `tag_laser` | 激光射线发射点，应位于激光器模型中 |
| `tag_hybrid` | 双用/混合瞄具挂点 |

不要把 `tag_camera` 当成 `tag_view`。`tag_camera` 提供相机动画，`tag_view` 决定视角参考位置。

### 7.3 默认部件

主机匣模型必须保留供其他部件挂载的节点。默认部件模型在各自渲染文件中通过 `anchor_node` 挂到主枪节点。

示例：

```json
{
  "model": "example:gltf/guns/example_rifle/example_rifle_barrel_default.glb",
  "texture": "example:skins/guns/example_rifle.png",
  "normal": "example:skins/guns/example_rifle_n.png",
  "specular": "example:skins/guns/example_rifle_s.png",
  "icon_texture": "example:textures/item/attachments/example_rifle_barrel_default.png",
  "anchor_node": "tag_barrel_attach"
}
```

如果部件在游戏中反向、大小错误或完全不跟动画，优先检查：

1. 部件 GLB 和主枪是否使用同一参考空间。
2. `anchor_node` 是否拼写正确。
3. 挂点是否在主枪当前动画骨架里。
4. 部件是否错误地保留了额外根变换。
5. 多骨架动画导出时，该挂点通道是否被错误删除或分配给错误 Armature。

### 7.4 Empty 与刚性节点

GLB 可以包含 Blender `Empty`/普通节点并由其带动子网格，但 GWO 的完整第一人称动画、骨骼遮罩、手臂跟随和多层姿态系统仍以骨骼节点最稳定。静态或简单刚性部件可以使用 Empty；会参与复杂动画混合的节点建议继续使用骨骼。
