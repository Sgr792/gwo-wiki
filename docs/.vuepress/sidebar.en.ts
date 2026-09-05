import type { SidebarConfig } from "vuepress-theme-hope";

export default {
  "/en/guide/": [
    {
      text: "GWO Content-Pack Authoring",
      icon: "book-open",
      link: "/en/guide/",
      collapsible: false,
      children: [
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
