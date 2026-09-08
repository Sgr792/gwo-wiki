---
title: Audio, Icons, and Modification UI
order: 7
category:
  - Content-Pack Authoring
---

## Audio

Encode final files as OGG Vorbis and register them in `assets/<namespace>/sounds.json`. Keep action audio untrimmed unless the source design explicitly requires truncation. Map events to the visible animation frame: magazine removal/insertion, chambering, pump/bolt, selector changes, inspect gestures, draw, holster, melee, fire tail, and dry fire.

Avoid layering duplicate composite files and event sounds for the same physical action. Test single fire and sustained fire separately, and allow the sound-physics mod to process firearm and foley categories where supported.

For a first integration, add one event at a time: copy the OGG to `assets/<namespace>/sounds/<weapon>/`, register it in `sounds.json`, verify firing, then add reload, inspect, bolt, and melee frame commands. Test again after a full restart.

The physical file, resource value, and event ID are different layers:

```text
file: assets/example/sounds/example_rifle/mag_in.ogg
resource value: example:example_rifle/mag_in
event ID: example:example_rifle_mag_in
```

## Icons and localization

Provide item model JSON, transparent PNG icons, and both `zh_cn.json` and `en_us.json` names. Use a consistent visual language across weapons, default parts, optional attachments, and ammunition; the default pack's bright model/shadow style is an example, not a required author style.

Keep a consistent camera angle, silhouette size, margin, shadow, and brightness. Do not brighten assets until their original material color is lost. `icon_texture` supplies item and modification-card artwork; the HUD first tries the live-rendered icon and uses `hud.weapon_icon` only if that render fails, then a built-in fallback if unset. It does not override a successful live icon. The fallback uses a 512×256 image. Validate creative inventory, hotbar, HUD, modification card, and tooltip separately.

## Modification screen

Weapon class, slot names, and attachment cards must be localized. The base `modify_screen.translation`, `rotation`, and `scale` control the static weapon overview. The model renders behind text and UI cards and must not run `idle` animation. Default parts must attach to their actual nodes in this static pose.

### Attachment detail views

Edit `weapons/firearms/render/<weapon_id>.render.json`. Merge this fragment into its existing `modify_screen` object without replacing the weapon's base display settings:

```jsonc
"preview_camera": {
  "transition_ms": 200,
  "parts": {
    "sight": {
      "anchor_node": "tag_reflex",
      "rotation": {"x": -20, "y": 0, "z": 0},
      "zoom": 1.5,
      "offset": {"x": 0, "y": 0, "z": 0},
      "follow_node_rotation": false
    }
  },
  "modules": {
    "example_optic": {"zoom": 1.4}
  }
}
```

| Field | Meaning |
| --- | --- |
| `transition_ms` | Transition duration: 200 ms by default, range 0–2000; 0 switches immediately |
| `parts` | Overrides keyed by slot, such as `sight`, `laser`, `magazine`, `stock`, `barrel`, or `muzzle` |
| `modules` | Overrides keyed by an entry in this weapon's `modules`, not its display name |
| `anchor_node` | Focus node; replace the example with a real model node, or omit to use the attachment anchor |
| `rotation` | View rotation relative to the base preview, in degrees |
| `zoom` | Detail-view scale, range 0.1–8; not ADS magnification |
| `offset` | Translation in the focused preview space, not the UI-pixel offset used for cartridges below |
| `follow_node_rotation` | Defaults to false (position only); true also follows the node's orientation |

Module overrides take precedence over slot overrides; unspecified fields inherit slot and weapon-class presets. Rotation and offset also accept `[x, y, z]`. View direction is manually configured, not automatically chosen from the attachment's installation side. If a laser is hidden on the opposite side, adjust that module's rotation.

Detail views focus on static attachment anchors and transition smoothly back to the overview. An unresolved or ambiguous anchor keeps the overview; specify `anchor_node` to resolve it. The ammunition page keeps the weapon overview rather than zooming into the magazine.

### Cartridge preview below the receiver

The ammunition page renders the ammunition definition's `models.cartridge` with its own material. Hovering a card changes the preview; leaving restores the selected ammunition. Hovering does not replace loaded rounds.

Add this fragment inside the same `modify_screen` object:

```jsonc
"ammo_preview": {
  "translation": {"x": 0, "y": 80, "z": 0}
}
```

- `x`: horizontal offset from the receiver origin; positive moves right.
- `y`: downward distance from the receiver origin; defaults to 80.
- `z`: relative render depth; leave at 0 unless needed. It does not change size.

Values use the 960×540 UI design coordinates and scale with the interface. Array form `"translation": [0, 80, 0]` is also supported; omitting the setting keeps these defaults. For example, `{"x": -20, "y": 100, "z": 0}` places the preview 20 units left and 100 below the receiver.

Size follows the in-gun cartridge scale chain, including the weapon, magazine, marker, and ammunition's own scale, rather than fitting the preview area. This translation changes neither weapon placement nor cartridge size or orientation. Missing usable `models.cartridge` data displays a missing-model message. Use a mod version that supports these fields; adding them to a pack does not enable the feature in older versions.

## Configuration examples

These examples use the same fields as the Chinese reference. Replace resource IDs, timings, and model-specific nodes with your own. `json` blocks are JSON objects; `jsonc` blocks are fragments to merge, not standalone pack files. Valid JSON alone does not make a complete working weapon.

### Sound registration (assets/example/sounds.json)

```json
{
  "example_rifle_fire": {
    "sounds": [
      {
        "name": "example:example_rifle/fire",
        "stream": false
      }
    ]
  },
  "example_rifle_mag_in": {
    "sounds": [
      "example:example_rifle/mag_in"
    ]
  }
}
```

### Timed reload sounds (merge into render definition)

```jsonc
"animation_commands": {
  "reload": [
    {"frame": 0, "type": "sound", "sound": "example:example_rifle_reload_start"},
    {"frame": 20, "type": "sound", "sound": "example:example_rifle_mag_out"},
    {"frame": 39, "type": "sound", "sound": "example:example_rifle_mag_in"}
  ]
}
```

## Authoring and runtime checks

Use mono audio for positional sounds where practical. Sound files must be OGG Vorbis, not simply renamed audio. Provide and register every event referenced by timed commands, including the reload-start and mag-out events in the illustrative fragment above.

A 256×256 transparent PNG is a useful item-icon starting size. Creators may use their own art style; consistency is recommended, not a requirement to make all assets white. Keep color detail and avoid flattening material colors through overexposure.

Default modules need behavior/render files, module registration, default installation, a real anchor, and matching reference space. Selecting an ammunition type in the modification UI selects the next reload's ammunition; it should not silently replace currently loaded rounds. Survival requires available ammunition, while creative inventory rules differ.

Provide valid `lang/zh_cn.json` and `lang/en_us.json` objects for localized UI and names. Inline display names can be used initially; no comments or trailing commas belong in runtime JSON.
