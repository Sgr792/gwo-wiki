---
title: Content-Pack Authoring Guide
index: false
icon: book-open
pageInfo: false
breadcrumb: false
toc: false
---

<div class="gwo-guide-hub">
  <div class="gwo-guide-lead">
    <span>GWO CONTENT-PACK AUTHORING</span>
    <p>Choose your modeling and animation workflow first and learn only the application you use. After export, all three routes join the shared configuration and in-game validation tutorials.</p>
  </div>

  <div class="gwo-guide-format-note">
    <strong>Code-block labels</strong>
    <code>json</code> is a complete file that can be saved directly. <code>jsonc</code> is a fragment that belongs inside its stated parent object. Actual content-pack JSON must not contain comments or trailing commas.
  </div>

  <div class="gwo-guide-section-heading">
    <span>Step one · Choose your workflow</span>
    <h2>How will you build your model and animation?</h2>
  </div>

  <p><a href="./choose-workflow.html">Not sure? Compare the routes and build requirements →</a></p>
  <div class="gwo-beginner-route">
    <a href="./blender-skinning.html"><span>BLENDER</span><strong>Skinning route</strong><small>Detailed meshes, deforming arms, bone animation, and GLB export.</small></a>
    <a href="./blender-empty.html"><span>BLENDER</span><strong>Empty rigid route</strong><small>Parent nodes, mechanical movement, and no-Skin GLB export.</small></a>
    <a href="./blockbench.html"><span>BLOCKBENCH</span><strong>Bedrock entity route</strong><small>Cubes, groups, pivots, numeric animation, and JSON export.</small></a>
  </div>
  <div class="gwo-guide-section-heading compact"><span>After export · Shared tutorials</span><h2>Configure the pack and test in game</h2></div>

  <div class="gwo-beginner-route">
    <a href="./getting-started.html">
      <span>01</span>
      <strong>Getting Started</strong>
      <small>Install the tools, understand the formats, and follow the full route from model to in-game validation.</small>
    </a>
    <a href="./empty-template.html">
      <span>02</span>
      <strong>Download the Empty Template</strong>
      <small>Begin with the current directory structure and no removed compatibility fields.</small>
    </a>
    <a href="./first-firearm.html">
      <span>03</span>
      <strong>Build Your First Firearm</strong>
      <small>Add rendering, shooting, reload, arms, aiming, audio, and modular parts in a tested order.</small>
    </a>
  </div>

  <div class="gwo-guide-section-heading compact">
    <span>Technical reference</span>
    <h2>Browse by authoring stage</h2>
  </div>

  <div class="gwo-chapter-grid">
    <a href="./arm-templates.html"><b>Arms</b><strong>Arm authoring templates</strong><small>Shared runtime arms, authoring tracks, and source downloads.</small></a>
    <a href="./config-examples.html"><b>Examples</b><strong>Configuration examples</strong><small>Animation routing, pose layers, scopes, and charms.</small></a>
    <a href="./bedrock-empty.html"><b>Formats</b><strong>Formats and Support Scope</strong><small>File formats, configuration mapping, build requirements, and limitations.</small></a>
    <a href="./models.html"><b>Models</b><strong>Model Rules</strong><small>Blender 3.3, coordinates, skeletons, Empty/rigid nodes, anchors, and GLB export.</small></a>
    <a href="./animation.html"><b>Animation</b><strong>Animation Rules</strong><small>Clip purpose, state differences, channel ownership, handoff, and machine configuration.</small></a>
    <a href="./firearms.html"><b>Firearms</b><strong>Firearms and Ammunition</strong><small>Behavior, ballistics, display transforms, recoil, effects, and materials.</small></a>
    <a href="./attachments-optics.html"><b>Modules</b><strong>Attachments and Optics</strong><small>Anchors, replacement animation, optics, tactical stance, and dynamic charms.</small></a>
    <a href="./melee.html"><b>Melee</b><strong>Standalone Melee</strong><small>Attack sets, combos, hit windows, interruption, and sound events.</small></a>
    <a href="./audio-ui.html"><b>Interface</b><strong>Audio and UI</strong><small>Sound events, language files, item icons, HUD, and modification-screen assets.</small></a>
    <a href="./debugging-release.html"><b>Validation</b><strong>Debugging and Release</strong><small>Common failures, performance checks, full acceptance, and ZIP release.</small></a>
    <a href="./reference.html"><b>Reference</b><strong>Current Format Reference</strong><small>Typical filenames, active fields, removed fields, and troubleshooting entry points.</small></a>
  </div>
</div>
