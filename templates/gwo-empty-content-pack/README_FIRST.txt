GWO 空内容包模板 / GWO Empty Content Pack Template

1. 把整个 gwo_empty_content_pack 文件夹复制到 .minecraft/gwo/。
2. 把 assets/example 改成你自己的命名空间，例如 assets/my_pack。
3. 资源 ID 和 JSON 中的 example: 也必须改成相同命名空间。
4. 枪械逻辑放 weapons/firearms/，渲染文件放 weapons/firearms/render/。
5. 独立近战放 weapons/melee/，弹药放 bullets/，配件放 attachments/。
6. 开发时保留文件夹形式；发布时再压缩，ZIP 根目录必须直接看到 pack.mcmeta。
7. 完整步骤：https://sgr792.github.io/gwo-wiki/guide/first-firearm.html

This template intentionally contains no weapon, model, texture, animation, sound, or legacy
compatibility data. Empty folders contain .gitkeep files only; they may be deleted
after adding real content.
