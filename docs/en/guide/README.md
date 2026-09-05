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
    <p>Complete the beginner route first. After your first working weapon, use the remaining chapters as focused technical reference instead of copying thousands of lines from a finished weapon.</p>
  </div>

  <div class="gwo-guide-format-note">
    <strong>Code-block labels</strong>
    <code>json</code> is a complete file that can be saved directly. <code>jsonc</code> is a fragment that belongs inside its stated parent object. Actual content-pack JSON must not contain comments or trailing commas.
  </div>

  <div class="gwo-guide-section-heading">
    <span>Recommended route</span>
    <h2>Build your first weapon from zero</h2>
  </div>

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
    <a href="./bedrock-empty.html"><b>Formats</b><strong>Bedrock and Empty Animation</strong><small>New development build: Blockbench cubes, numeric animation, and Blender rigid nodes.</small></a>
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
