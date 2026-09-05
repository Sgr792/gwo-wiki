import type { SidebarConfig } from "vuepress-theme-hope";

export default {
  "/en/guide/": [
    {
      text: "GWO Content-Pack Authoring",
      icon: "book-open",
      link: "/en/guide/",
      collapsible: false,
      children: [
        "choose-workflow",
        { text: "Model and animation routes", collapsible: true, children: ["blender-skinning", "blender-empty", "blockbench", "arm-templates"] },
        "getting-started",
        "empty-template",
        "first-firearm",
        "models",
        "bedrock-empty",
        "animation",
        "config-examples",
        "firearms",
        "attachments-optics",
        "melee",
        "audio-ui",
        "debugging-release",
        "reference",
      ],
    },
  ],
} satisfies SidebarConfig;
