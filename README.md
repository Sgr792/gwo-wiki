# GWO Wiki

Guns Workshop Origins 的中文内容包制作与开发文档。

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

默认站点地址：`https://sgr792.github.io/gwo-wiki/`。
