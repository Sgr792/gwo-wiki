---
title: Installing and Editing Protected Packs
category:
  - Content-Pack Authoring
---

Editable protected packs use the **v2** format. Install the publisher's matching GWO JAR and complete pack, and verify the files against the supplied checksums.

## ZIP or complete extracted folder

Install packs under the active game directory's `gwo/`, and the mod JAR under `mods/`. Keep either the ZIP or its completely extracted same-named folder, never both.

Preserve `pack.mcmeta`, `META-INF`, all payloads, and their relative paths. Copying only `assets/` or adding an extra outer folder is insufficient. Do not modify protected media, headers, or indexes. Editor backup files, unlisted temporary files, symbolic links, missing entries, or renamed entries can invalidate the pack. Adding, deleting, or renaming files requires publisher repacking.

## Edit existing configuration in place

V2 marks these existing text entries as editable:

- `pack.mcmeta`.
- `.lua` scripts.
- `.json` outside `assets/`, including weapons, render files, attachments, ammunition, and `data/`.
- `assets/<namespace>/sounds.json`.

Edit the original path inside the ZIP or its complete extracted folder. **No `config/gwo/overrides/` directory is required.** Exit the game, back up the pack, edit, and restart. JSON must be valid with no duplicate keys; definition and Lua validation still apply. Editable configuration does not make encrypted models or audio replaceable.

To change model FOV, edit this leaf in the existing `camera` object without deleting its other fields:

```jsonc
"camera": {
  "model_fov": 70
}
```

The valid range is 1–179. Model FOV is separate from Minecraft world FOV and optic magnification.

## Single-player and multiplayer

Single-player uses an integrated server. Both sides can read valid local v2 gameplay edits, while media integrity checks remain mandatory.

Multiplayer compares canonical JSON and Lua. Whitespace, JSON object-key order, and equivalent numeric spellings do not change identity. Gameplay values, unknown fields, and scripts remain authoritative. Only these validated leaves in JSON under `weapons/` or `attachments/` may differ for local display preferences:

| Object path | Allowed differing leaves |
|---|---|
| `camera` | `model_fov` |
| `first_person`, `ground`, `fixed`, `modify_screen`, `sprinting`, `offhand_stowed` | Direct `translation`, `rotation`, `scale` |
| `third_person_pose.gun.lowered`, `third_person_pose.gun.raised` | `translation`, `rotation`, `scale` |

This does not exempt whole render files. Recoil, magnification, damage, capacity, cadence, animation timing, and `animation_visibility` still need to match the server. These builds use network protocol **24**; use matching client and server builds.

## Verification failures

Distinguish local configuration errors, server configuration errors, gameplay mismatches, and protected-media failures. Keep the full log and the text copied from GWO Resource Status, then check:

1. Duplicate ZIP/folder installations or duplicate packs.
2. A matching editable protected pack and GWO JAR, with the expected file checksums.
3. JSON/Lua validity, editor backup files, missing entries, and folder layout.
4. Changes to authoritative settings or protected media.

Use the publisher's complete original pack for comparison. Removing signatures or bypassing verification is not a repair. See [debugging and release](debugging-release.md) for ordinary packs and reloads. This offline format discourages direct extraction; it is not online authorization or protection against a modified client.
