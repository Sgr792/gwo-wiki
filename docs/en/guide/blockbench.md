---
title: Blockbench format support removed
---

# Blockbench format support removed

GWO gun packs no longer load Bedrock geometry or animation JSON. Existing `.bbmodel` files can remain authoring sources, but saving or renaming them does not convert them into GLB.

Export or convert assets to GLB and check node names, hierarchy, UVs, pivots, and animation clips before using them. Conversion is not automatic and may require reworking animations.

Continue with [Blender skinning](./blender-skinning.md), [Blender Empty](./blender-empty.md), and [format configuration](./bedrock-empty.md).
