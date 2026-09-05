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

Weapon class, slot names, and attachment cards must be localized. Use `modify_screen` only for the static model's position, rotation, and scale. The model renders behind text and UI cards and must not run `idle` animation. Default parts must attach to their actual nodes in this static pose.

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
