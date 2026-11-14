---
title: 第三方模组 Java API v1
category:
  - 模组开发
---

GWO 提供实验性 Java API，适用于 **Minecraft 1.21.1、NeoForge 21.1.x、Java 21**。入口是 `com.sgr792.gwo.api.GwoApi`，事件在 `com.sgr792.gwo.api.event`，`GwoApi.API_VERSION` 当前为 `1`。Java API 用于第三方模组集成，内容包制作使用 JSON/Lua 接口。

编译与运行时使用配套的 API 依赖。内部的 `GunData`、模块树、网络消息和渲染类不属于公开接口。

## 引入与调用时机

使用带 API 的完整运行时 JAR 作为编译依赖；源码包只供 IDE 查看，不装入游戏。当前没有可在这里直接填写的公共 Maven 坐标。

```groovy
dependencies {
    compileOnly files("libs/gwo-1.1.1-beta.jar")
    localRuntime files("libs/gwo-1.1.1-beta.jar")
}
```

在自己的 `META-INF/neoforge.mods.toml` 声明依赖：

```toml
[[dependencies.your_mod_id]]
modId="gwo"
type="required"
versionRange="[1.1.1-beta,)"
ordering="AFTER"
side="BOTH"
```

可选集成应隔离 GWO 类型引用，只在确认兼容 GWO 已安装后加载集成类。

事件监听器注册到 `NeoForge.EVENT_BUS`。在内容加载完成后查询/创建物品，例如服务端命令回调。操作使用所属游戏线程；异步任务先回到 `server.execute(...)`。查询是不可变快照，重载后重新查询，不在每个渲染帧遍历整个目录。

## 读取与创建物品

| 调用 | 用途 |
|---|---|
| `weapons()`、`weapon(id)` | 武器目录及基础信息，包括近战 |
| `ammunition()`、`ammo(id)` | 弹药目录和基础信息 |
| `attachments()`、`attachments(weaponId)` | 全局去重配件目录，或指定武器的可创建模块；后者包含默认/隐藏模块，排除 embedded |
| `weaponId(stack)`、`ammoId(stack)`、`attachmentId(stack)` | 校验实际物品类型后识别内容 ID |
| `state(stack)` | 弹量、容量、模式、弹膛、实例 ID 与已装模块快照 |
| `compatibleAmmo(stack)` | 当前模块组合接受的已加载弹药 |
| `ballistics(stack, charge)` | 当前模块/弹药的飞行常量；有限 `charge` 值为 0～1 |
| `createWeapon(id)` | 创建有独立实例 ID、默认模块的空仓武器或近战 |
| `createAmmo(id, count)` | 创建弹药；count 是物品数量 |
| `createAttachment(weaponId, moduleId)`、`createAttachment(globalId)` | 创建配件物品 |
| `give(player, stack)` | 服务端发放物品副本；背包装不下的部分掉落 |

未知 ID 返回空结果或 `ItemStack.EMPTY`；非法数量或 charge 会报错。近战状态的 `loadedAmmo` 可以为空。配件可创建不代表可安装到所有枪，真实改装仍校验挂点、冲突和库存。本版没有直接写模块树的公开方法；每把新武器单独调用工厂，不复制同一个实例 ID。

`WeaponInfo` 是基础数据，`state`/`ballistics` 才结合当前物品。弹道速度与重力单位为格/tick、格/tick²；正常 1 tick=1/20 秒。结果不是完整命中模拟器，不包含对最终命中、护甲和第三方伤害事件的保证。

## 事件语义

以下事件在逻辑服务端同步通知，单人内置服务端同样适用，不会因客户端预测重复触发。

| 事件 | 时点 |
|---|---|
| `GunShootEvent.Pre/Post` | 射击资格检查通过后、生成弹丸/扣弹前，可取消；Post 在提交后发布 |
| `GunReloadEvent.Pre/Post` | 装填交易提交前/后；逐发装填每发各一次 |
| `MeleeAttackEvent.Pre/Post` | 近战请求加入延迟命中队列前/后；Post 不等于命中 |
| `WeaponDamageEvent.Pre/Post` | 命中后、伤害/护甲处理前，可取消或改伤害；Post 在 hurt 或护甲板吸收成功后发布 |
| `FireModeChangedEvent` | 普通快慢机实际改变射击模式后 |
| `AttachmentsChangedEvent` | 改装校验和库存交易成功提交后 |
| `WeaponActionEvent` | 有效动作上报的生命周期，仅观察，不可取消 |

射击事件每发弹药一次，霰弹的多个弹丸不会产生多次射击 Post；伤害事件则按弹丸/目标触发。使用 `GunShootEvent.Post` 计射击耐久，使用 `WeaponDamageEvent.Post` 及 `isKilled()` 计命中/击杀。失败、空仓、重复或冷却请求没有射击 Post。

`getShotId()` 可关联一次射击与其伤害事件；内部直接调用可能为 0。近战使用独立负数 ID，同一挥击多个目标共享它。子弹发射时记录内容 ID，不会因玩家后来换枪而改归属。

伤害 Pre 已含 GWO 的距离/部位倍率，未经过护甲；Post 数值仍是请求伤害，不是实际扣血。取消或设为零不发布 Post。末影人原版弹丸免疫/瞬移特殊路径不发布此伤害事件。动作上报的 STARTED/UPDATED/PAUSED/RESUMED/COMPLETED/CANCELED 和 0～1000 progress 不是扣弹或命中证据。

## 示例

在自己模组初始化中注册监听器，`myDurability` 由自己的模组实现：

```java
import com.sgr792.gwo.api.event.GunShootEvent;
import net.neoforged.bus.api.EventPriority;
import net.neoforged.neoforge.common.NeoForge;

NeoForge.EVENT_BUS.addListener(EventPriority.NORMAL, false, GunShootEvent.Post.class,
    event -> myDurability.consume(event.getWeapon(), 1));
NeoForge.EVENT_BUS.addListener(EventPriority.NORMAL, false, GunShootEvent.Pre.class,
    event -> { if (myDurability.isBroken(event.getWeapon())) event.setCanceled(true); });
```

在服务端回调中，为已确定的 `weaponId` 选择一个可创建配件：

```java
import com.sgr792.gwo.api.GwoApi;

var candidates = GwoApi.attachments(weaponId);
if (!candidates.isEmpty()) {
    var info = candidates.getFirst();
    var attachment = GwoApi.createAttachment(info.sourceWeaponId(), info.moduleId());
    GwoApi.give(player, attachment);
}
```

事件中的武器是活物品，只修改自己拥有的数据组件。不要重入开火/换弹、覆盖 GWO 的 CUSTOM_DATA、身份或模块树；移除物品等后续操作应安排在下一服务端 tick。取消服务端交易不承诺撤回已经播出的预测声音/动画。

公开 API 不读取受保护媒体原始字节，不绕过联机验证。实验性接口未来仍可能变更；破坏性 API 变更会提升 API_VERSION。集成验收需覆盖单人、专服、取消交易、逐发装填、配件兼容及物品同步。
