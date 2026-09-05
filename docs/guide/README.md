---
title: 内容包制作教程
index: false
icon: book-open
pageInfo: false
breadcrumb: false
toc: false
---

<div class="gwo-guide-hub">
  <div class="gwo-guide-lead">
    <span>GWO CONTENT-PACK AUTHORING</span>
    <p>先选择模型与动画制作方式，只学习你使用的软件。完成导出后，三条路线汇合到共用内容包配置与游戏验收。</p>
  </div>

  <div class="gwo-guide-format-note">
    <strong>代码块标记</strong>
    <code>json</code> 表示可以独立保存的完整文件；<code>jsonc</code> 表示需要插入父对象的配置片段。实际内容包 JSON 不允许注释或尾随逗号。
  </div>

  <div class="gwo-guide-section-heading">
    <span>第一步 · 选择制作方式</span>
    <h2>你想用哪种方式制作模型与动画？</h2>
  </div>

  <p><a href="./choose-workflow.html">不知道怎么选？查看三条路线的区别与版本要求 →</a></p>
  <div class="gwo-beginner-route">
    <a href="./blender-skinning.html"><span>BLENDER</span><strong>骨骼蒙皮路线</strong><small>精细网格、手臂变形、骨骼动画与 GLB 导出。</small></a>
    <a href="./blender-empty.html"><span>BLENDER</span><strong>Empty 刚性路线</strong><small>空物体层级、机构运动与无 Skin GLB 导出。</small></a>
    <a href="./blockbench.html"><span>BLOCKBENCH</span><strong>Bedrock 实体路线</strong><small>方块、分组、枢轴、数值动画与 JSON 导出。</small></a>
  </div>
  <div class="gwo-guide-section-heading compact"><span>导出完成后 · 共用教程</span><h2>配置内容包并进入游戏测试</h2></div>

  <div class="gwo-beginner-route">
    <a href="./getting-started.html">
      <span>01</span>
      <strong>快速开始</strong>
      <small>安装环境、认识资源格式，理解从模型到游戏验收的完整路线。</small>
    </a>
    <a href="./empty-template.html">
      <span>02</span>
      <strong>下载空内容包模板</strong>
      <small>取得当前目录结构正确、没有旧兼容字段的干净起点。</small>
    </a>
    <a href="./first-firearm.html">
      <span>03</span>
      <strong>从零制作第一把枪</strong>
      <small>依次完成显示、射击、换弹、手臂、瞄准、声音和模块化部件。</small>
    </a>
  </div>

  <div class="gwo-guide-section-heading compact">
    <span>技术参考</span>
    <h2>按制作环节查阅</h2>
  </div>

  <div class="gwo-chapter-grid">
    <a href="./bedrock-empty.html"><b>格式</b><strong>格式与支持范围</strong><small>文件格式、配置映射、版本要求与功能限制参考。</small></a>
    <a href="./models.html"><b>模型</b><strong>模型制作规范</strong><small>Blender 3.3、坐标、骨架、Empty/刚性节点、挂点与 GLB 导出。</small></a>
    <a href="./animation.html"><b>动画</b><strong>动画制作与导出</strong><small>动画用途、状态区别、通道所有权、交接与动画机配置。</small></a>
    <a href="./firearms.html"><b>枪械</b><strong>枪械、弹药与材质</strong><small>枪械逻辑、弹道、显示变换、后坐力、特效和贴图。</small></a>
    <a href="./attachments-optics.html"><b>配件</b><strong>配件、瞄具与挂饰</strong><small>挂点、替换动画、倍镜、侧瞄和动态挂饰。</small></a>
    <a href="./melee.html"><b>近战</b><strong>独立近战武器</strong><small>动作集合、连段、命中窗口、打断和声音事件。</small></a>
    <a href="./audio-ui.html"><b>界面</b><strong>声音、图标与界面</strong><small>声音事件、语言文件、物品图标、HUD 和改装界面资源。</small></a>
    <a href="./debugging-release.html"><b>验收</b><strong>调试、验收与发布</strong><small>常见故障、性能检查、完整验收和 ZIP 发布。</small></a>
    <a href="./reference.html"><b>参考</b><strong>当前格式参考</strong><small>典型文件名称、有效字段、已废弃字段和排错入口。</small></a>
  </div>
</div>
