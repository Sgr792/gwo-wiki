---
title: Third-Party Java API v1
category:
  - Mod Development
---

GWO provides an experimental Java API for **Minecraft 1.21.1, NeoForge 21.1.x, and Java 21**. The entry point is `com.sgr792.gwo.api.GwoApi`; events are under `com.sgr792.gwo.api.event`. `GwoApi.API_VERSION` is currently `1`. This is separate from content-pack JSON/Lua and is not a TaCZ compatibility layer.

This page was checked against the implementation on 2026-11-14. Older JARs may also say `1.1.1-beta`; verify that the actual artifact contains the API. Internal GunData, module-tree, network, and rendering classes are not public contracts.

## Dependency and lifecycle

Compile against the complete API-enabled runtime JAR. Source JARs are for IDE use, not installation. No public Maven coordinate is provided here.

```groovy
dependencies {
    compileOnly files("libs/gwo-1.1.1-beta.jar")
    localRuntime files("libs/gwo-1.1.1-beta.jar")
}
```

Declare the dependency in your `META-INF/neoforge.mods.toml`:

```toml
[[dependencies.your_mod_id]]
modId="gwo"
type="required"
versionRange="[1.1.1-beta,)"
ordering="AFTER"
side="BOTH"
```

The version range alone cannot distinguish older identically named builds. Optional integrations must isolate GWO type references in a compatibility class loaded only after a compatible GWO build is confirmed.

Register listeners on `NeoForge.EVENT_BUS`. Query or create items after content loading, such as in server command callbacks. Use the owning game thread; return from asynchronous work through `server.execute(...)`. Results are immutable snapshots: query again after content reload and avoid catalog enumeration every render frame.

## Queries and factories

| Method | Purpose |
|---|---|
| `weapons()` / `weapon(id)` | Weapon catalog and base data, including melee |
| `ammunition()` / `ammo(id)` | Ammunition catalog and base data |
| `attachments()` / `attachments(weaponId)` | Deduplicated global catalog or a weapon's creatable modules, including default/hidden modules but excluding embedded modules |
| `weaponId(stack)` / `ammoId(stack)` / `attachmentId(stack)` | Identify content after validating actual item type |
| `state(stack)` | Ammunition, capacity, mode, chamber, instance identity, and installed-module snapshot |
| `compatibleAmmo(stack)` | Loaded ammunition accepted by the current module combination |
| `ballistics(stack, charge)` | Resolved flight constants for current modules/ammunition; charge must be finite and within 0–1 |
| `createWeapon(id)` | An empty weapon with default modules and a new instance identity, or a melee item |
| `createAmmo(id, count)` | Ammunition items; count means item count |
| `createAttachment(weaponId, moduleId)` / `createAttachment(globalId)` | Create an attachment item |
| `give(player, stack)` | Give a copy on the server thread; drop inventory overflow |

Unknown IDs return empty results or `ItemStack.EMPTY`; invalid counts or charge throw. Melee `loadedAmmo` may be null. A creatable attachment is not necessarily compatible with every gun. Installation still checks slots, conflicts, and inventory. There is no public direct module-tree setter; create each new weapon through its factory rather than copying one instance identity.

`WeaponInfo` contains base data; `state` and `ballistics` resolve the current item. Velocity and gravity use blocks/tick and blocks/tick², with a normal tick of 1/20 second. Ballistics is not a complete hit or final-damage simulator.

## Server events

Events run synchronously on the logical server, including the integrated single-player server. Client prediction does not emit a duplicate.

| Event | Timing |
|---|---|
| `GunShootEvent.Pre/Post` | After eligibility checks, before projectile/ammo commit (cancelable Pre); Post after commit |
| `GunReloadEvent.Pre/Post` | Before/after loading transaction; each per-round insertion has its own pair |
| `MeleeAttackEvent.Pre/Post` | Before/after queuing an accepted delayed melee hit; Post is not proof of a hit |
| `WeaponDamageEvent.Pre/Post` | Before damage/armor processing (cancelable and editable); Post after successful hurt or armor-plate absorption |
| `FireModeChangedEvent` | A normal selector request actually changes fire mode |
| `AttachmentsChangedEvent` | Attachment rules and inventory transaction have committed |
| `WeaponActionEvent` | Valid action lifecycle reports; observation only |

Shooting events occur once per ammunition round, not once per pellet. Damage events occur per projectile/target. Use shooting Post for durability, and damage Post plus `isKilled()` for hit/kill rewards. Failed, empty, duplicate, or cooldown requests have no shooting Post.

`getShotId()` links a shot with its damage events; internal direct calls may use 0. Melee uses separate negative IDs shared by targets of one swing. Projectile weapon identity is captured at firing and does not change when the player switches weapons.

Damage Pre includes GWO distance/location modifiers but precedes armor. Post damage is the requested damage, not measured health loss. Cancellation or zero damage produces no Post. The vanilla Enderman projectile-immunity/teleport path does not emit these damage events. Action statuses STARTED/UPDATED/PAUSED/RESUMED/COMPLETED/CANCELED and progress 0–1000 are not evidence of ammunition or damage commits.

## Examples

Register during your mod initialization. `myDurability` belongs to your mod:

```java
import com.sgr792.gwo.api.event.GunShootEvent;
import net.neoforged.bus.api.EventPriority;
import net.neoforged.neoforge.common.NeoForge;

NeoForge.EVENT_BUS.addListener(EventPriority.NORMAL, false, GunShootEvent.Post.class,
    event -> myDurability.consume(event.getWeapon(), 1));
NeoForge.EVENT_BUS.addListener(EventPriority.NORMAL, false, GunShootEvent.Pre.class,
    event -> { if (myDurability.isBroken(event.getWeapon())) event.setCanceled(true); });
```

In a server callback, select a creatable attachment for an already chosen `weaponId`:

```java
import com.sgr792.gwo.api.GwoApi;

var candidates = GwoApi.attachments(weaponId);
if (!candidates.isEmpty()) {
    var info = candidates.getFirst();
    var attachment = GwoApi.createAttachment(info.sourceWeaponId(), info.moduleId());
    GwoApi.give(player, attachment);
}
```

Event weapon stacks are live items. Modify only your own data components. Do not reenter shooting/reloading or overwrite GWO identity, CUSTOM_DATA, or module trees. Defer removals and similar operations to a later server tick. Server cancellation does not promise to retract predicted sounds or animation already shown.

The API neither exposes protected media bytes nor bypasses multiplayer checks. Breaking experimental API changes will increment API_VERSION. Test integration in single-player and on a dedicated server, including cancellation, per-round reloads, compatibility, and item synchronization.
