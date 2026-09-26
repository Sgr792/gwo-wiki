---
title: Metal Training Target
icon: bullseye
category:
  - Content-Pack Authoring
---

# Metal Training Target

`gwo:training_target` is a two-block-tall target built into the core mod; it does not require a content pack. Find it in the Other creative tab, or craft it in survival with five iron ingots, one vanilla target block, and one redstone dust. Place it on sturdy ground with space in front for the plate to fall; placement follows the player's facing.

Only a bullet striking the **printed front face of the plate** knocks it down and shows the shooter a target reading. The back, sides, and base stop bullets without toppling the target. The plate falls in about 0.25 seconds, stays down about one second, and rises in about 0.45 seconds, making a full cycle of about 1.7 seconds. The fallen plate still blocks projectiles but gives no repeat target score or target-hit sound. Right-click a fallen target to reset it early; break the target or its support to recover the item.

The target model and animation are bundled as Bedrock JSON in the core mod. Content-pack authors do not need to copy these files. When testing firearm hits, check the front, back, base, and fallen plate separately. See the [core implementation guide](https://github.com/Sgr792/gwo/blob/main/docs/training-target-block.md) for details.
