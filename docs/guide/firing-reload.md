---
title: 射击与换弹进阶
---

# 射击与换弹进阶

先完成[动画规范](./animation.md)与[配置示例](./config-examples.md)，再按武器实际动画选择下面的功能。示例是局部配置，不要覆盖整份武器文件；帧数必须以你自己的动画为准。

## 首发准备：fire_pre

`fire_pre` 是击发前的准备动画，不是另一发子弹。渲染定义的 `animation_machine.actions.fire` 支持：

| 字段 | 默认值 | 用途 |
| --- | --- | --- |
| `pre_fire_mode` | `presentation` | `presentation` 不建立首发等待门控；`per_trigger` 每次扣扳机准备一次；`per_shot` 每发都准备 |
| `first_shot_delay_ms` | `-1` | 非负值为等待毫秒数；`-1` 从准备动画时长推导。范围 -1～60000 |

MG338 使用 `per_trigger`、167 毫秒首发延迟：按下后先准备，再实际击发；持续按住后的连射不会逐发重播完整准备段。准备期间松开仍会完成这次待发的一枪，但切枪或其他无效开火条件可以取消它。等待期间不提前扣弹。

启用门控时，每条射击 sequence 必须以 `fire_pre` 开始，第二步必须带 `"marker": "shot"`。腰射、瞄准、最后一发的分支都要对应正确：

```json
{
  "type": "finite",
  "default_state": "fire",
  "pre_fire_mode": "per_trigger",
  "first_shot_delay_ms": 167,
  "sequences": [{
    "priority": 0,
    "steps": [
      {"state": "fire_pre", "marker": "enter", "phase": "enter"},
      {"state": "fire", "marker": "shot", "phase": "action"}
    ]
  }]
}
```

这是最小腰射示例；已有瞄准、最后一发分支时请保留并分别配置。两段仍需真实动画和 controller channel。首发延迟与持续射速是两回事；`per_shot` 会额外等待，不能用于要求维持原射速的普通连射。

## 射击恢复：fire_settle

`fire` 表现击发脉冲，`fire_settle` 表现后续恢复，不再次生成子弹、扣弹或播放整套击发事件。是否拆段由源动画决定，不是每把枪都必须有恢复片段。

- 在 `animation_controller.channels` 用 `next_state` 衔接恢复段。
- 若 `fire` 已包含恢复尾部，可用 `clip_end_time`（秒）截取脉冲段，避免恢复播放两遍。
- `clip_start_time`、`speed`、`fade_in` 与 `fade_out` 要与实际剪辑匹配；非零进入混合会从上一段的交接姿态过渡。
- 最后一发如果已结束在正确空仓姿态，不应再强行接普通恢复段。
- `aim_fire` 与最后一发分支分别检查，不要直接复制腰射设置。
- 恢复尾帧应回到对应持枪状态，连续开火、单发松开与空仓都要测试。

M4、RM277、MG338 的剪辑结构不同，因此不能仅凭同名 `fire_settle` 使用同一组时间参数。

## 换弹时显示新弹匣：magazine_role

某些动画会重复使用同一个 `j_mag1`：先表示旧弹匣，随后表示手里取出的新弹匣。真实弹量尚未提交时，新弹匣不能继续显示为空。

在渲染定义 `animation_commands.<对应状态>` 的事件数组中，按新弹匣出现的帧添加：

```json
{"frame": 24, "type": "magazine_role", "bone": "j_mag1", "args": ["new"]}
```

24 帧只是示例。这里的 `bone` 是模型中真实弹匣根节点，不要求固定叫 `j_mag1`。

| 角色 | 显示弹量来源 |
| --- | --- |
| `new` | 本次预计装入量，考虑可用备弹，并非永远满弹 |
| `old` | 本次换弹开始前的弹量 |

它仅影响本次第一人称换弹中指定根节点及其后代的弹药显示，并让对应 `bullet_additive` 使用该弹量的采样姿态，包括子弹和托弹板。弹膛、其他弹匣、HUD 和实际弹量不提前改变。模块重定向姿态也使用同样的规则。

当前一次换弹只保存一个活动角色根节点；后续角色事件会替换它，不是多弹匣角色表。换弹结束、取消或切换武器后清除。瞄准换弹、扩容弹匣的状态也要按各自事件帧配置。

**不要为了显示新弹匣而提前真实装弹提交点。** `magazine_role`、可见性遮罩和机械装弹提交是不同职责。

## 弹链换弹保留弹量姿态

在需要保持剩余弹链状态的 controller channel 上设置：

```jsonc
"preserve_ammo_pose": true
```

默认是 `false`。MG338 的 `reload` 与 `reload_empty` 使用它，避免换弹一开始就把空链条重新显示出来。弹药状态仍按已有装入时间与可见性事件更新；这个开关不替代换弹提交配置，也不应无条件加到所有动作上。

检视、空仓掏枪、空击和最后几发都要检查。没有空击动画时不要为了占位把 `dry_fire` 映射到 idle；MG338 不配置这两个空击剪辑通道，空机声音单独保留。

## 链节抛出与模型复用

渲染定义的 `link_effect` 可直接复用机匣模型中的链节网格，不需要另存一份 GLB。MG338 使用：

- `enabled: true`：开启链节效果。
- `source_bone: "j_bulletlink_spent1"`：选择模型中的链节来源。
- `anchor_bone: "j_cover"`：抛出位置。
- `direction_anchor_bone: "tag_brass"`：方向参考，与位置节点可以不同。
- `velocity`、`front`、`up`、随机量、旋转速度、寿命与重力：控制运动，不改变源模型绑定。

一个射击事件产生一个链节；弹壳仍由 `shell_effect` 独立控制。先确认源网格确实是单个链节，再校验方向，不要把整条弹链当作抛出物。发射的子弹、枪内子弹、弹壳与链节是不同对象。

## MG338 配件挂点示例

MG338 的 1mW Laser Box 挂在**机匣**的 `tag_laser_attach`，不是枪管。武器渲染定义可覆盖模块父级：

```jsonc
"modules": {
  "1mw_laser_box": {
    "definition": "attachments/lasers/1mw_laser_box.json",
    "parent_types": ["gun"],
    "parent_slots": []
  }
}
```

这里只展示一个模块项，请合并到已有 `modules`。当前 MG338 侧瞄旋转为 `canted_aim.rotation.x = -25`；这是武器独立调校值，不是所有枪的统一默认值。

完成后使用 `/gwo reload` 重载并测试：单发/连射、松开扳机、最后一发、空仓/有弹/备弹不足换弹、瞄准与侧瞄切换，以及普通渲染和光影下的弹壳、链节与透明弹匣。
