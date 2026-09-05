import type { SidebarConfig } from "vuepress-theme-hope";

export default {
  "/guide/": [
    {
      text: "GWO 内容包制作",
      icon: "book-open",
      link: "/guide/",
      collapsible: false,
      children: [
        "choose-workflow",
        { text: "模型与动画制作路线", collapsible: true, children: ["blender-skinning", "blender-empty", "blockbench", "arm-templates"] },
        "getting-started",
        "empty-template",
        "first-firearm",
        "models",
        "bedrock-empty",
        "animation",
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
