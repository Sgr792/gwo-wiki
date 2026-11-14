# GWO Wiki

Guns Workshop Origins 的中文内容包制作与开发文档。

本仓库公开 Wiki、内容包教学示例与制作模板，不包含 GWO 模组本体源码。模组本体源码暂不公开；第三方集成请使用 Wiki 中的公开 API 文档。

## 本地运行

```bash
pnpm install
pnpm docs:dev
```

## 构建

```bash
pnpm docs:build
```

构建产物位于 `docs/.vuepress/dist`。

## GitHub Pages

仓库已包含 `.github/workflows/deploy.yml`。推送到 `main` 后，在 GitHub 仓库的
**Settings → Pages → Build and deployment → Source** 中选择 **GitHub Actions**。

站点地址：`https://wiki.playgwo.com/`。
