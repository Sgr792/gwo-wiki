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

#### 标准父子层级

第一人称主链应当按下面的方向建立：

```text
root
└─ tag_view
   ├─ tag_camera
   └─ tag_ads
      └─ tag_weapon
         └─ 枪械主体骨骼（例如 j_gunx 或 j_gun）
            ├─ 枪械网格和可动机构
            ├─ tag_align_gun
            ├─ tag_weapon_focus（需要时）
            └─ tag_brass
```

这里每缩进一级就代表一级真实父子关系。`tag_camera` 和 `tag_ads` 是同级节点；`tag_weapon` 是 `tag_ads` 的子级，不是它的父级。允许在枪械主体骨骼与功能节点之间保留武器自身需要的中间骨骼，例如 `tag_sling` 或 `tag_pistol_offset`，但不能改变 `root → tag_view → tag_ads → tag_weapon` 这条主链。

模块化武器的 `tag_flash` 通常位于枪管 GLB 的 `tag_barrel_attach` 分支下；一体模型则放在枪械主体运动分支下。枪口、抛壳、挂点和需要随枪运动的网格都不能直接挂到 `root`、`tag_view` 或 `tag_camera`，否则瞄准、开火或动画混合时会留在错误空间。

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

### 7.5 手臂制作模板（Blender 3.3）

可以下载 [GWO 手臂制作模板（Blender 3.3）](/downloads/gwo_arms_template_blender33.blend)，直接作为第一人称手臂模型和动画制作的起点。

该文件使用 **Blender 3.3** 保存。它是方便创作者建立正确骨架名称、父子层级、绑定姿态和参考空间的制作模板，不是必须原样使用的固定外观。替换网格或调整外观时，不要单独改变骨骼名称、层级和绑定姿态；如果确实要改变骨架，武器动画库和独立手臂模型必须一起更新并保持一致。

### 7.6 零基础 Blender 操作顺序

下面顺序适合第一次整理枪械模型：

1. `File → Save As`，先保存自己的工程副本。
2. 在 Outliner 中给机匣、枪管、弹匣、枪托和可动机构改成能看懂的名称。
3. 删除导入时附带的灯光、相机、重复 LOD 和不使用的碰撞体。
4. 切到右视图或使用坐标轴，确认枪口朝 `+X`。
5. 对网格执行 `Object → Apply → Rotation & Scale`。
6. 检查 Armature 对象本身是否保持与动画工程一致；已经制作动画后不要单独应用 Armature 变换。
7. 进入 Edit Mode 检查法线，使用 `Mesh → Normals → Recalculate Outside` 处理意外翻面；真实需要双面的薄片应单独决定，不要整枪强制双面。
8. 把透明玻璃、发光区域和需要独立隐藏的部件拆成独立网格并明确命名。
9. 建立主骨架与本页节点，逐个检查父级。
10. 对刚性部件使用单骨骼全权重或稳定的节点父级；不要让一个刚性弹匣被多个无关骨骼以小权重拉扯。
11. 保存工程，再导出模型 GLB。

#### 模型 GLB 导出检查

在 `File → Export → glTF 2.0` 中：

- 选择 `glTF Binary (.glb)`。
- 只导出这把枪需要的对象，避免带入场景垃圾。
- 保留网格、Armature、Skinning 和需要的 Empty/节点。
- 不把完整动作库混进模型文件。
- 导出文件名使用 `<枪械ID>_receiver_default.glb` 或对应默认部件名。

导出完成后不要只看“没有报错”。新建一个空 Blender 文件，重新导入 GLB，检查：

| 检查项 | 正确结果 |
|---|---|
| 枪口方向 | 仍为 `+X` |
| 比例 | 与原工程一致 |
| 节点名 | 没有自动添加 `.001` |
| 层级 | 挂点仍位于正确父节点下 |
| 材质槽 | 数量和顺序没有意外变化 |
| 透明网格 | 仍能独立选择 |
| 骨骼权重 | 刚性部件没有拉花或缺面 |

#### 模型与动画必须一起重导的情况

以下任一项改变后，不能只替换其中一个文件：

- 骨骼重命名。
- 骨骼父子层级变化。
- 绑定姿态变化。
- Armature 对象变换变化。
- 手臂与武器共用参考骨骼的位置变化。

这时应同时重新导出模型 GLB、动画库和受影响的独立手臂模型，否则最常见的结果就是游戏内手的位置与 Blender 不同、动作结束跳变或配件不跟随。
