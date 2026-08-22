import type { SidebarConfig } from "vuepress-theme-hope";

export default {
  "/en/guide/": [
    {
      text: "GWO Content-Pack Authoring",
      icon: "book-open",
      collapsible: false,
      children: [
        "getting-started",
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
