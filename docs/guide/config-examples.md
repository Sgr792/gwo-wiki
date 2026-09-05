---
title: 配置示例与接入步骤
category:
  - 内容包制作
---

# 配置示例与接入步骤

这些教学示例不包含武器模型、贴图、声音或动画，也不依赖默认内容包。它们是配置起点，不是直接可玩的内容包。所有尺寸和时间是教学值，必须匹配自己的资源。

下载文件可独立解析，但前两份是**合并到现有渲染定义的配置片段**：不要替换整个渲染文件或建立重复的 JSON 根键。保留现有有效字段和默认值；同名子项应人工比较后修改。

## 动画分支、序列、标记与打断

[下载配置片段](/downloads/examples/animation-routing.json)

```json
{
  "animation_fps": 30,
  "animation_clips": {
    "static_idle": "static_idle",
    "fire_pre": "fire_pre",
    "fire": "fire",
    "fire_settle": "fire_settle",
    "reload": "reload",
    "reload_empty": "reload_empty"
  },
  "animation_events": {
    "fire_pre": "fire",
    "fire": "fire",
    "fire_settle": "fire_settle",
    "reload": "reload",
    "reload_empty": "reload_empty"
  },
  "animation_machine": {
    "version": 2,
    "actions": {
      "fire": {
        "type": "finite",
        "default_state": "fire",
        "sequences": [
          {
            "priority": 0,
            "steps": [
              {
                "state": "fire_pre",
                "marker": "prepare",
                "phase": "enter"
              },
              {
                "state": "fire",
                "marker": "shot",
                "phase": "action"
              },
              {
                "state": "fire_settle",
                "marker": "settle",
                "phase": "exit"
              }
            ]
          }
        ],
        "events": [
          {
            "type": "shot_effects",
            "marker": "shot",
            "offset_ms": 0
          },
          {
            "type": "fire_sound",
            "marker": "shot",
            "offset_ms": 0
          },
          {
            "type": "recoil",
            "marker": "shot",
            "offset_ms": 0
          }
        ]
      },
      "reload": {
        "type": "finite",
        "default_state": "reload",
        "variants": [
          {
            "state": "reload_empty",
            "priority": 100,
            "when": {
              "empty": "true"
            }
          },
          {
            "state": "reload",
            "priority": 0
          }
        ]
      }
    },
    "interrupts": [
      {
        "active": "reload",
        "incoming": "fire",
        "decision": "reject",
        "min_progress": 0,
        "max_progress": 1,
        "priority": 100,
        "reason": "finish_reload_before_fire"
      }
    ]
  },
  "animation_controller": {
    "channels": {
      "fire_pre": {
        "clip": "fire_pre",
        "layer": "recoil",
        "duration_frame": 2,
        "loop": false,
        "fade_in": 0,
        "fade_out": 0
      },
      "fire": {
        "clip": "fire",
        "layer": "recoil",
        "duration_frame": 6,
        "loop": false,
        "fade_in": 0,
        "fade_out": 0
      },
      "fire_settle": {
        "clip": "fire_settle",
        "layer": "recoil",
        "duration_frame": 8,
        "loop": false,
        "fade_in": 0,
        "fade_out": 0
      },
      "reload": {
        "clip": "reload",
        "layer": "action",
        "duration_frame": 60,
        "loop": false,
        "fade_in": 0,
        "fade_out": 0
      },
      "reload_empty": {
        "clip": "reload_empty",
        "layer": "action",
        "duration_frame": 75,
        "loop": false,
        "fade_in": 0,
        "fade_out": 0
      }
    }
  }
}
```


接入顺序：

1. 先准备表中全部剪辑，再填写同名通道及真实时长。Bedrock 的右侧剪辑名换为完整导出名。
2. `variants` 根据 `when` 选状态，优先级高的匹配分支优先；这里空仓选 `reload_empty`。
3. `sequences` 将开火动作分为准备、击发和恢复段；`marker` 是步骤的事件定位标记，不是动画文件里的骨骼。
4. 三个开火视觉事件定位到 `shot`，`offset_ms: 0` 表示该步骤开始时。它们不代替服务器扣弹、伤害或换弹提交。
5. 打断规则这里拒绝换弹期间的开火请求。`active` 和 `incoming` 写已声明的动作 ID，不是任意 GLB 剪辑名；`reason` 必须非空。
6. 弹匣式换弹的实际提交时间仍写枪械逻辑的 `mechanics.action_commit_ms`，不能仅设置动画时长。

本例只覆盖腰射教学分支。正式枪还需按需求增加瞄准、最后一发和空击；不要照抄后删除已有分支。不需要准备段的枪不必增加 `fire_pre`。

## 姿态层与通道所有权

[下载配置片段](/downloads/examples/pose-layers.json)

```json
{
  "pose_graph": {
    "base_clip": "static_idle",
    "default_blend": "override",
    "layers": {
      "action": {
        "channels": [
          "reload",
          "hand_action",
          "action",
          "inspect"
        ],
        "blend": "override",
        "priority": 100
      },
      "recoil": {
        "channels": [
          "recoil"
        ],
        "blend": "override",
        "priority": 200,
        "bone_mask": [
          "tag_weapon"
        ]
      }
    }
  }
}
```


`base_clip` 是基础姿态；`channels` 选择控制器的 layer 分类，不是模型网格名；`bone_mask` 限定应用范围。本例仅让 recoil 层控制 `tag_weapon`，适用于专门按该所有权制作的示例，不适合直接覆盖带手臂/枪机完整射击动作的现有枪。

已有 `pose_graph.layers` 时应合并需要的层，不能用本例抹掉瞄准、奔跑、空仓和弹量层。`override` 与 `additive` 要匹配动画参考空间，不能为消除跳变随意互换。验收时同时测试层开始、层结束和动作打断。

## 单模式倍率镜

行为文件 [下载](/downloads/examples/scope-example.json)，保存到 `attachments/sights/training_scope.json`：

```json
{
  "id": "example:training_scope",
  "type": "sight",
  "slot": "sight",
  "display_name": "Training Scope",
  "default_installed": false,
  "parent_types": [
    "gun"
  ],
  "sight": {
    "enabled": true,
    "type": "scope",
    "scope_rate": 4,
    "ads_z_compensation": 1
  },
  "render": "attachments/render/sights/training_scope.render.json"
}
```


渲染文件 [下载](/downloads/examples/scope-example.render.json)，保存到行为文件的 `render` 路径：

```json
{
  "model": "example:gltf/attachments/training_scope.glb",
  "texture": "example:skins/attachments/training_scope.png",
  "normal": "example:skins/attachments/training_scope_n.png",
  "specular": "example:skins/attachments/training_scope_s.png",
  "anchor_node": "tag_scope",
  "transparent_nodes": {
    "scope_front_lens": {
      "alpha": 0.8,
      "depth_write": false,
      "depth_test": true,
      "double_sided": true
    },
    "scope_rear_lens": {
      "alpha": 0.8,
      "depth_write": false,
      "depth_test": true,
      "double_sided": true
    }
  },
  "sight": {
    "reticle_node": "tag_reticle_attach",
    "scope_front_lens_node": "scope_front_lens",
    "scope_rear_lens_node": "scope_rear_lens",
    "rear_lens_node": "scope_rear_lens",
    "scope_optical_mesh_prefix": "scope_",
    "scope_stencil_node": "scope_stencil",
    "scope_relief_node": "scope_relief",
    "scope_reflection_node": "scope_reflection",
    "scope_reflection_texture": "example:textures/sights/reflection.png",
    "scope_reflection_alpha": 0.3,
    "reticle_texture": "example:textures/sights/reticle.png",
    "reticle_scale": 1
  }
}
```


主枪的 `modules` 必须收录行为文件。这里的 `tag_scope` 只是示例安装点，改成主枪真实存在的挂点，不能套用到所有枪。

模型必须提供前后物理镜片、准心定位、stencil/relief/reflection 辅助几何；名称与配置逐一对应。所有贴图由作者提供，辅助几何不能与镜框合并。先检查不开镜的玻璃，再检查完全开镜的世界画面、准心、遮罩与反射，最后测试 Iris。没有参考贴图时不要保留指向不存在文件的反射路径。

这是固定 4× 单模式示例，不含双用翻转或可变倍率模式，不能只改倍率就宣称变成双用瞄具。

## 简单物理挂饰

[下载渲染示例](/downloads/examples/charm-example.render.json)

```json
{
  "model": "example:gltf/attachments/training_charm.glb",
  "texture": "example:skins/attachments/training_charm.png",
  "anchor_node": "tag_cosmetic",
  "charm_physics": {
    "enabled": true,
    "root_bone": "tag_cosmetic",
    "bones": [
      "chain_01",
      "chain_02",
      "charm_body"
    ],
    "gravity": 1,
    "velocity_damping": 0.22,
    "constraint_iterations": 6,
    "max_angle": 45,
    "collision_anchor_bone": "tag_cosmetic",
    "collision_radii": [
      0.025,
      0.03,
      0.1
    ],
    "colliders": [
      {
        "type": "box",
        "min": [
          -0.2,
          -0.2,
          -0.2
        ],
        "max": [
          0.2,
          0,
          0.2
        ]
      }
    ]
  }
}
```


另建配件行为文件（`type`/`slot` 为 `cosmetic`），引用此渲染文件，并加入枪的 `modules`。模型中建立固定挂点和依次相连的链条节点；`bones` 从靠近挂点到末端排列，必须使用真实名称。

碰撞盒坐标相对于配置的碰撞参考节点，是教学尺寸，必须按枪体实测调整。先关闭物理检查静态安装位置，再启用物理检查扣环连接、静止重力、移动、转向、暂停恢复和换枪。不要靠扩大碰撞盒补偿错误挂点或重复父变换。

玩家头像是另一项可选能力：头像节点、名字面与链条材质必须分开，不能把普通挂饰的贴图当作玩家皮肤。
