import { hopeTheme } from "vuepress-theme-hope";
import navbar from "./navbar.js";
import navbarEn from "./navbar.en.js";
import sidebar from "./sidebar.js";
import sidebarEn from "./sidebar.en.js";

export default hopeTheme({
  hostname: "https://wiki.playgwo.com/",
  author: {
    name: "GWO Team",
    url: "https://github.com/Sgr792/gwo",
  },
  repo: "Sgr792/gwo-wiki",
  docsDir: "docs",
  locales: {
    "/": {
      lang: "zh-CN",
      navbar,
      sidebar,
      headerDepth: 3,
    },
    "/en/": {
      lang: "en-US",
      navbar: navbarEn,
      sidebar: sidebarEn,
      headerDepth: 3,
    },
  },
  displayFooter: true,
  footer: "Guns Workshop Origins",
  copyright: "GWO Wiki",
  lastUpdated: true,
  contributors: true,
  editLink: true,
  editLinkPattern: ":repo/edit/:branch/:path",
  plugins: {
    searchPro: {
      indexContent: true,
      autoSuggestions: true,
    },
    mdEnhance: {
      align: true,
      attrs: true,
      figure: true,
      footnote: true,
      tasklist: true,
      tabs: true,
    },
  },
});
