---
title: Audio, Icons, and Modification UI
order: 7
category:
  - Content-Pack Authoring
---

## 26. Audio

Encode final files as OGG Vorbis and register them in `assets/<namespace>/sounds.json`. Keep action audio untrimmed unless the source design explicitly requires truncation. Map events to the visible animation frame: magazine removal/insertion, chambering, pump/bolt, selector changes, inspect gestures, draw, holster, melee, fire tail, and dry fire.

Avoid layering duplicate composite files and event sounds for the same physical action. Test single fire and sustained fire separately, and allow the sound-physics mod to process firearm and foley categories where supported.

## 27. Icons and localization

Provide item model JSON, transparent PNG icons, and both `zh_cn.json` and `en_us.json` names. Keep the same white-model-with-shadow visual language across weapons, default parts, optional attachments, and ammunition.

## 28. Modification screen

Weapon class, slot names, and attachment cards must be localized. Use `modify_screen` only for the static model's position, rotation, and scale. The model renders behind text and UI cards and must not run `idle` animation. Default parts must attach to their actual nodes in this static pose.
