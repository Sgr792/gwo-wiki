import { viteBundler } from "@vuepress/bundler-vite";
import { defineUserConfig } from "vuepress";
import theme from "./theme.js";

export default defineUserConfig({
  base: "/gwo-wiki/",
  locales: {
    "/": {
      lang: "zh-CN",
      title: "GWO Wiki",
      description: "Guns Workshop Origins 内容包制作与开发文档",
    },
    "/en/": {
      lang: "en-US",
      title: "GWO Wiki",
      description: "Guns Workshop Origins content-pack authoring and development documentation",
    },
  },
  head: [
    ["meta", { name: "theme-color", content: "#4b8cff" }],
    ["meta", { name: "apple-mobile-web-app-capable", content: "yes" }],
  ],
  bundler: viteBundler(),
  theme,
});
