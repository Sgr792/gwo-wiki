import type { NavbarConfig } from "vuepress-theme-hope";

export default [
  "/en/",
  {
    text: "Content Pack Guide",
    icon: "book-open",
    prefix: "/en/guide/",
    children: [
      { text: "Getting Started", link: "getting-started" },
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
  {
    text: "GitHub",
    icon: "github",
    link: "https://github.com/Sgr792/gwo",
  },
] satisfies NavbarConfig;
