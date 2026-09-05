import type { NavbarConfig } from "vuepress-theme-hope";

export default [
  "/",
  {
    text: "内容包教程",
    icon: "book-open",
    prefix: "/guide/",
    children: [
      { text: "教程目录", link: "" },
      { text: "选择制作方式", link: "choose-workflow" },
      { text: "Blender 骨骼路线", link: "blender-skinning" },
      { text: "Blender Empty 路线", link: "blender-empty" },
      { text: "Blockbench 路线", link: "blockbench" },
      { text: "快速开始", link: "getting-started" },
      { text: "空内容包模板", link: "empty-template" },
      { text: "从零制作第一把枪", link: "first-firearm" },
      { text: "模型规范", link: "models" },
      { text: "动画规范", link: "animation" },
      { text: "枪械与弹药", link: "firearms" },
      { text: "配件与瞄具", link: "attachments-optics" },
      { text: "近战武器", link: "melee" },
      { text: "声音与界面", link: "audio-ui" },
      { text: "调试与发布", link: "debugging-release" },
      { text: "参考文件", link: "reference" },
    ],
  },
] satisfies NavbarConfig;
