import type { NavbarConfig } from "vuepress-theme-hope";

export default [
  "/en/",
  {
    text: "Content Pack Guide",
    icon: "book-open",
    prefix: "/en/guide/",
    children: [
      { text: "Guide Index", link: "" },
      { text: "Choose Your Workflow", link: "choose-workflow" },
      { text: "Blender Skinning Route", link: "blender-skinning" },
      { text: "Blender Empty Route", link: "blender-empty" },
      { text: "Blockbench Route", link: "blockbench" },
      { text: "Getting Started", link: "getting-started" },
      { text: "Empty Template", link: "empty-template" },
      { text: "Build Your First Firearm", link: "first-firearm" },
      { text: "Model Rules", link: "models" },
      { text: "Animation Rules", link: "animation" },
      { text: "Firearms and Ammo", link: "firearms" },
      { text: "Attachments and Optics", link: "attachments-optics" },
      { text: "Melee Weapons", link: "melee" },
      { text: "Audio and UI", link: "audio-ui" },
      { text: "Debugging and Release", link: "debugging-release" },
      { text: "Reference", link: "reference" },
    ],
  },
] satisfies NavbarConfig;
