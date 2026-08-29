---
title: Firearms, Ammunition, and Materials
order: 4
category:
  - Content-Pack Authoring
---

## 16. Ammunition

An ammunition definition owns caliber identity, damage/ballistics, inventory icon, loaded-round model, and spent-case model. A weapon references compatible ammunition IDs; magazines change capacity and animation behavior but do not replace the caliber definition.

Keep loaded rounds and spent cases under `assets/<namespace>/gltf/bullets/`, with base-color, normal, and specular textures under `skins/bullets/`. Each cartridge type may provide a different case model, so ejection follows the currently loaded ammunition.

## 17. Firearm behavior JSON

Start from the closest official example: magazine-fed rifle, pistol, tube-fed shotgun, or bolt-action rifle. Important groups include:

- identity, class, compatible ammunition, capacity, chamber behavior;
- fire mode, rate, range, damage, projectile count, and spread;
- reload/rechamber state and event frames;
- hip/ADS recoil and Weapon Sway;
- animation interruption and action timing;
- default and optional attachment slots.

Do not copy shotgun shell-loop rules into a detachable-magazine weapon, or automatic scheduling into a bolt-action weapon.

Magazine-fed finite actions use `mechanics.action_commit_ms`. A tube-fed shotgun with `reload_system.type: "tube_per_round"` instead authors only the event frames under `reload_system.events`; runtime derives server timing from `animation_fps`, so do not add duplicate per-round `*_ms` fields.

Use `creative_category` to select both the creative-tab group and the weapon-type label shown in the modification screen. Standard values are `assault_rifle`, `battle_rifle`, `submachine_gun`, `shotgun`, `light_machine_gun`, `marksman_rifle`, `sniper_rifle`, `pistol`, `launcher`, and `melee`. `creative_sort` controls ordering within a category. Unknown values fall back to `assault_rifle`.

## 18. Firearm render JSON

The render file binds model, animation library, arms, materials, nodes, action names, and display transforms. Typical declarations include:

```json
{
  "gltf_model": "example:gltf/guns/example_rifle/example_rifle_receiver_default.glb",
  "animation_sources": [
    "example:gltf/animations/example_rifle_receiver_default.anim.glb"
  ],
  "texture": "example:skins/guns/example_rifle.png",
  "normal": "example:skins/guns/example_rifle_n.png",
  "specular": "example:skins/guns/example_rifle_s.png"
}
```

Define transforms independently for first person, third-person pose, offhand stow, modification screen, fixed/item-frame display, and dropped items. A display transform should use the static model pose rather than an authored idle clip.

## 19. Recoil and Weapon Sway

Hip and ADS recoil are separate parameter sets. `vertical` and `horizontal` control view recoil; `model_back` controls model-space rearward impulse; `randomness` and `recovery` shape variation and return. `auto_recovery: false` disables automatic view return for weapons that require manual correction.

Weapon Sway is a spring-like location/rotation offset around the authored pose. It must not be baked into animation clips and must be consumed consistently by the weapon, muzzle, tracers, lasers, and magnified-optic path.

## 20. Muzzle effects and projectiles

`tag_flash` supplies the muzzle origin, while the actual projectile remains authoritative for collision and damage. Tracers are visual segments that begin at the animated muzzle and converge toward the physical trajectory. Shotguns create one physical pellet/tracer path per configured pellet, not one decorative beam for the whole shot.

Muzzle flash and smoke use separate resources. Verify both first and third person, with and without shaders, while moving the camera quickly. Spent cases originate at `tag_brass` and use the currently loaded ammunition's case model.

## 21. Texture channels

- Base color: `*.png`
- Tangent-space normal: `*_n.png`
- GWO packed material/specular map: `*_s.png`
- Optional emissive mask: `*_glow.png`

Every default part should explicitly declare the shared base, normal, and specular textures when it uses them. Do not assume a detached part automatically inherits all receiver maps.
