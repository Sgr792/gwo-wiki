import type { SidebarConfig } from "vuepress-theme-hope";

export default {
  "/en/guide/": [
    {
      text: "GWO Content-Pack Authoring",
      icon: "book-open",
      link: "/en/guide/",
      collapsible: false,
      children: [
        "content-editor",
        "choose-workflow",
        "visual-guide",
        { text: "Model and animation routes", collapsible: true, children: ["blender-skinning", "blender-empty", "blockbench", "arm-templates"] },
        "getting-started",
        "empty-template",
        "first-firearm",
        "models",
        "bedrock-empty",
        "animation",
        "lua-animation",
        "animation-names",
        "firing-reload",
        "config-examples",
        "firearms",
        "gunsmith-workbench",
        "attachments-optics",
        "melee",
        "audio-ui",
        "debugging-release",
        "parameters",
        "reference",
      ],
    },
  ],
} satisfies SidebarConfig;
