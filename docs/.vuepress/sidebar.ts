import type { SidebarConfig } from "vuepress-theme-hope";

export default {
  "/guide/": [
    {
      text: "GWO 内容包制作",
      icon: "book-open",
      link: "/guide/",
      collapsible: false,
      children: [
        "getting-started",
        "empty-template",
        "first-firearm",
        "models",
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
