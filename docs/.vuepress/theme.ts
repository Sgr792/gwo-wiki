import { hopeTheme } from "vuepress-theme-hope";
import navbar from "./navbar.js";
import sidebar from "./sidebar.js";

export default hopeTheme({
  hostname: "https://sgr792.github.io/gwo-wiki/",
  author: {
    name: "GWO Team",
    url: "https://github.com/Sgr792/gwo",
  },
  repo: "Sgr792/gwo-wiki",
  docsDir: "docs",
  navbar,
  sidebar,
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
