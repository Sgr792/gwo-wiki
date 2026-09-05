---
title: Configuration Examples and Integration
category:
  - Content-Pack Authoring
---

# Configuration examples and integration

These examples contain no weapon models, textures, sounds, or animations and do not depend on the default pack. They are configuration starting points, not a playable pack. Dimensions and timings are instructional values to replace with your own.

Downloads are valid JSON. The first two are **fragments to merge into an existing render definition**, not replacements for that file. Preserve valid fields and explicit defaults; compare matching entries instead of creating duplicate root keys.

## Variants, sequences, markers, and interrupts

[Download fragment](/downloads/examples/animation-routing.json)

```json
{
  "animation_fps": 30,
  "animation_clips": {
    "static_idle": "static_idle",
    "fire_pre": "fire_pre",
    "fire": "fire",
    "fire_settle": "fire_settle",
    "reload": "reload",
    "reload_empty": "reload_empty"
  },
  "animation_events": {
    "fire_pre": "fire",
    "fire": "fire",
    "fire_settle": "fire_settle",
    "reload": "reload",
    "reload_empty": "reload_empty"
  },
  "animation_machine": {
    "version": 2,
    "actions": {
      "fire": {
        "type": "finite",
        "default_state": "fire",
        "sequences": [
          {
            "priority": 0,
            "steps": [
              {
                "state": "fire_pre",
                "marker": "prepare",
                "phase": "enter"
              },
              {
                "state": "fire",
                "marker": "shot",
                "phase": "action"
              },
              {
                "state": "fire_settle",
                "marker": "settle",
                "phase": "exit"
              }
            ]
          }
        ],
        "events": [
          {
            "type": "shot_effects",
            "marker": "shot",
            "offset_ms": 0
          },
          {
            "type": "fire_sound",
            "marker": "shot",
            "offset_ms": 0
          },
          {
            "type": "recoil",
            "marker": "shot",
            "offset_ms": 0
          }
        ]
      },
      "reload": {
        "type": "finite",
        "default_state": "reload",
        "variants": [
          {
            "state": "reload_empty",
            "priority": 100,
            "when": {
              "empty": "true"
            }
          },
          {
            "state": "reload",
            "priority": 0
          }
        ]
      }
    },
    "interrupts": [
      {
        "active": "reload",
        "incoming": "fire",
        "decision": "reject",
        "min_progress": 0,
        "max_progress": 1,
        "priority": 100,
        "reason": "finish_reload_before_fire"
      }
    ]
  },
  "animation_controller": {
    "channels": {
      "fire_pre": {
        "clip": "fire_pre",
        "layer": "recoil",
        "duration_frame": 2,
        "loop": false,
        "fade_in": 0,
        "fade_out": 0
      },
      "fire": {
        "clip": "fire",
        "layer": "recoil",
        "duration_frame": 6,
        "loop": false,
        "fade_in": 0,
        "fade_out": 0
      },
      "fire_settle": {
        "clip": "fire_settle",
        "layer": "recoil",
        "duration_frame": 8,
        "loop": false,
        "fade_in": 0,
        "fade_out": 0
      },
      "reload": {
        "clip": "reload",
        "layer": "action",
        "duration_frame": 60,
        "loop": false,
        "fade_in": 0,
        "fade_out": 0
      },
      "reload_empty": {
        "clip": "reload_empty",
        "layer": "action",
        "duration_frame": 75,
        "loop": false,
        "fade_in": 0,
        "fade_out": 0
      }
    }
  }
}
```


1. Supply all referenced clips and matching channels with real durations. For Bedrock, use full exported clip names on the right.
2. `variants` selects a state by `when`, with higher-priority matching rules first. Here empty reload selects `reload_empty`.
3. `sequences` splits firing into preparation, shot, and recovery. A `marker` locates a sequence step; it is not a model bone.
4. The three visual firing events use the `shot` marker and zero offset from that step. They do not replace server ammunition, damage, or reload commits.
5. This interrupt rule rejects fire during reload. `active` and `incoming` are declared action IDs, not arbitrary exported clips; `reason` is required.
6. Magazine reload commits still belong in gameplay `mechanics.action_commit_ms`, separate from animation length.

This covers hip-fire teaching branches only. Add ADS, last-round, and dry-fire branches as needed without deleting existing behavior. Weapons without a preparation stage do not need `fire_pre`.

## Pose layers and channel ownership

[Download fragment](/downloads/examples/pose-layers.json)

```json
{
  "pose_graph": {
    "base_clip": "static_idle",
    "default_blend": "override",
    "layers": {
      "action": {
        "channels": [
          "reload",
          "hand_action",
          "action",
          "inspect"
        ],
        "blend": "override",
        "priority": 100
      },
      "recoil": {
        "channels": [
          "recoil"
        ],
        "blend": "override",
        "priority": 200,
        "bone_mask": [
          "tag_weapon"
        ]
      }
    }
  }
}
```


`base_clip` selects the base pose. `channels` selects controller layer categories, not mesh names; `bone_mask` limits affected nodes. This example restricts recoil to `tag_weapon` and requires animations authored for that ownership. Do not use it unchanged for a full firing clip containing arms or bolt motion.

Merge needed layers into an existing graph rather than deleting ADS, sprint, empty-state, or ammo layers. Choose override/additive according to authored reference space, not as a trial fix for jumps. Test layer entry, exit, and interruption.

## Single-mode magnified optic

Save this [behavior download](/downloads/examples/scope-example.json) as `attachments/sights/training_scope.json`:

```json
{
  "id": "example:training_scope",
  "type": "sight",
  "slot": "sight",
  "display_name": "Training Scope",
  "default_installed": false,
  "parent_types": [
    "gun"
  ],
  "sight": {
    "enabled": true,
    "type": "scope",
    "scope_rate": 4,
    "ads_z_compensation": 1
  },
  "render": "attachments/render/sights/training_scope.render.json"
}
```


Save the [render download](/downloads/examples/scope-example.render.json) at its referenced `render` path:

```json
{
  "model": "example:gltf/attachments/training_scope.glb",
  "texture": "example:skins/attachments/training_scope.png",
  "normal": "example:skins/attachments/training_scope_n.png",
  "specular": "example:skins/attachments/training_scope_s.png",
  "anchor_node": "tag_scope",
  "transparent_nodes": {
    "scope_front_lens": {
      "alpha": 0.8,
      "depth_write": false,
      "depth_test": true,
      "double_sided": true
    },
    "scope_rear_lens": {
      "alpha": 0.8,
      "depth_write": false,
      "depth_test": true,
      "double_sided": true
    }
  },
  "sight": {
    "reticle_node": "tag_reticle_attach",
    "scope_front_lens_node": "scope_front_lens",
    "scope_rear_lens_node": "scope_rear_lens",
    "rear_lens_node": "scope_rear_lens",
    "scope_optical_mesh_prefix": "scope_",
    "scope_stencil_node": "scope_stencil",
    "scope_relief_node": "scope_relief",
    "scope_reflection_node": "scope_reflection",
    "scope_reflection_texture": "example:textures/sights/reflection.png",
    "scope_reflection_alpha": 0.3,
    "reticle_texture": "example:textures/sights/reticle.png",
    "reticle_scale": 1
  }
}
```


Register the behavior file in the weapon's `modules`. Replace example `tag_scope` with a real installation anchor; it is not a universal anchor for every weapon.

Supply physical front/rear lenses, reticle placement, stencil/relief/reflection geometry, and all textures. Match names individually and keep optical helpers separate from the frame. Check glass while not aiming, then the fully aimed world image, reticle, mask, and reflection, then Iris. Do not leave nonexistent reflection texture references.

This is a fixed 4× single-mode example, not hybrid flipping or variable magnification.

## Simple physics charm

[Download render example](/downloads/examples/charm-example.render.json)

```json
{
  "model": "example:gltf/attachments/training_charm.glb",
  "texture": "example:skins/attachments/training_charm.png",
  "anchor_node": "tag_cosmetic",
  "charm_physics": {
    "enabled": true,
    "root_bone": "tag_cosmetic",
    "bones": [
      "chain_01",
      "chain_02",
      "charm_body"
    ],
    "gravity": 1,
    "velocity_damping": 0.22,
    "constraint_iterations": 6,
    "max_angle": 45,
    "collision_anchor_bone": "tag_cosmetic",
    "collision_radii": [
      0.025,
      0.03,
      0.1
    ],
    "colliders": [
      {
        "type": "box",
        "min": [
          -0.2,
          -0.2,
          -0.2
        ],
        "max": [
          0.2,
          0,
          0.2
        ]
      }
    ]
  }
}
```


Create a behavior definition with `type`/`slot` set to `cosmetic`, reference this render file, and add it to weapon `modules`. Model a fixed attachment and connected chain nodes; list real `bones` from attachment toward tip.

The collider is relative to the configured collision anchor and uses instructional dimensions. Fit it to your weapon. Disable physics first to verify static mounting, then enable it and test ring attachment, gravity at rest, movement, turning, pause/resume, and weapon switches. Do not enlarge colliders to hide wrong anchors or duplicated parent transforms.

Player avatars are a separate optional feature. Keep head nodes, nameplate geometry, and chain material separate; a generic charm texture is not the player's skin.
