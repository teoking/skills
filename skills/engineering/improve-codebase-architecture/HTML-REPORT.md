# HTML 报告格式

架构审查报告是保存在操作系统临时目录中的单文件 HTML。Tailwind 和 Mermaid 均从 CDN 加载，因此打开报告时仍需要网络访问。Mermaid 适合表达图状关系；手工 div 和内联 SVG 适合体量对比、剖面等强调视觉表达的图示。混合使用两者，不要把所有图示都交给 Mermaid，否则报告容易显得千篇一律。

默认使用简体中文撰写可见文案，并设置 `lang="zh-CN"`；用户指定其他语言时，同步调整文案和 `lang`。代码标识、占位符、CDN 地址、CSS 类名及推荐强度和依赖类别的英文标识保留原样。

## HTML 骨架

```html
<!doctype html>
<html lang="zh-CN">
  <head>
    <meta charset="utf-8" />
    <title>{{repo name}} 架构审查</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      /* 补充 Tailwind 不便表达的细节，例如接缝虚线和手绘风格箭头。 */
      .seam { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
      .deep { background: linear-gradient(135deg, #0f172a, #1e293b); }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-5xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="candidates" class="space-y-10">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

## 页头

展示仓库名称、日期和简短图例：实线方框表示模块，虚线表示接缝，红色箭头表示泄漏，深色粗边框表示深模块。不写介绍段落，直接进入候选方案。

## 候选卡片

主要信息由图示表达。文字简短、直接，统一使用 `codebase-design` 的术语。

每个候选方案使用一个 `<article>`：

- **标题**：简短，点明深化动作，例如「合并 Order 接收流程」。
- **徽章行**：推荐强度，`Strong`（强烈推荐）用翠绿色，`Worth exploring`（值得探索）用琥珀色，`Speculative`（推测性建议）用灰蓝色；另加依赖类别标签：`in-process`、`local-substitutable`、`ports & adapters`、`mock`。
- **文件**：等宽字体列表，使用 `font-mono text-sm`。
- **改进前后对比图**：卡片的核心，分两列并排展示，图示模式见下文。
- **问题**：一句话，说明哪里造成阻碍。
- **方案**：一句话，说明会改变什么。
- **收益**：短列表，每条最多 6 个词。例如「测试只经过一个接口」「定价逻辑不再泄漏」「删除 4 个浅模块」。
- **ADR 提示**：如有冲突，用一行文字放在琥珀色提示框中。

不要写大段解释。如果必须用一段文字才能说明图意，就重画图示。

## 图示模式

根据候选方案选择合适的模式，并混合使用。不要让所有图示都一样；图示的多样性有助于表达不同的问题。

### Mermaid 关系图：依赖与调用流程的常用模式

当重点是「X 调用 Y，Y 又调用 Z，由此产生复杂关系」时，使用 Mermaid `flowchart` 或 `graph`。外层用 Tailwind 卡片样式，让图示与报告保持一致。使用 `classDef` 将泄漏关系标红，将深模块设为深色。时序图适合表达「改进前往返 6 次，改进后只需 1 次」。

```html
<div class="rounded-lg border border-slate-200 bg-white p-4">
  <pre class="mermaid">
    flowchart LR
      A[OrderHandler] --> B[OrderValidator]
      B --> C[OrderRepo]
      C -.leak.-> D[PricingClient]
      classDef leak stroke:#dc2626,stroke-width:2px;
      class C,D leak
  </pre>
</div>
```

### 手工方框与箭头：Mermaid 布局不合适时

用带边框和标签的 `<div>` 表示模块。在相对定位的容器上，绝对定位内联 SVG 的 `<line>` 或 `<path>` 表示箭头。如果改进后的图示需要呈现一个粗边框深模块，并将内部细节灰显，就使用这个模式；Mermaid 难以表达同样的视觉分量。

### 剖面图：展示多层浅模块

堆叠水平条带（`h-12 border-l-4`），展示一次调用经过的层次。改进前是 6 个几乎不做实质工作的薄层；改进后是 1 个厚条带，标明合并后的职责。

### 体量对比图：展示接口几乎与实现一样复杂

每个模块用两个矩形表示：一个表示接口面积，一个表示实现。改进前，接口矩形与实现矩形几乎一样高，表示浅模块；改进后，接口矩形变矮，实现矩形仍然高，表示深模块。

### 调用图折叠

改进前，用嵌套方框展示函数调用树。改进后，将同一棵树折叠为一个方框，原来的调用变成内部细节，在方框中淡化显示。

## 样式指南

- 采用编辑式排版，而不是企业仪表盘风格。留出充足空白。标题可选用衬线字体，`font-serif` 与 stone/slate 配色搭配较好。
- 克制使用颜色：一种强调色，翠绿色或靛蓝色；红色表示泄漏，琥珀色表示警告。
- 图示高度保持在约 `320px`，让改进前后的图可以并排查看，无需滚动。
- 图示中的模块标签使用 `text-xs uppercase tracking-wider`，呈现结构示意感，而不是界面控件感。
- 脚本只允许 Tailwind CDN 和 Mermaid ESM 导入。报告其余部分保持静态，不添加应用代码，也不添加 Mermaid 自身渲染之外的交互。

## 首选建议

用一张较大的卡片展示候选名称、一句推荐理由，以及指向该候选卡片的锚点链接。不添加其他内容。

## 文案风格

使用简明中文，但架构名词和动词必须来自 `codebase-design`。不能以简洁为由换用含义不同的术语。

**固定使用以下译名，首次出现时附英文原词：** 模块（module）、接口（interface）、实现（implementation）、深度（depth）、深（deep）、浅（shallow）、接缝（seam）、适配器（adapter）、杠杆效应（leverage）、局部性（locality）。英文输出使用这些英文原词。

**不要替换为：** 用「组件」「服务」「单元」代替模块；用「API」「签名」代替接口；用「边界」代替接缝；本意是模块时，用「层」「包装器」替代模块。

**合适的表述：**

- 「Order 接收模块很浅：接口几乎和实现一样复杂。」
- 「定价逻辑跨接缝泄漏。」
- 「深化：一个接口，一个测试位置。」
- 「两个适配器足以支持这个接缝：生产环境用 HTTP，测试用内存适配器。」

**收益列表**用术语说明具体收益，例如「局部性：缺陷集中在一个模块」「杠杆效应：一个接口供 N 个调用点使用」「接口缩小；实现吸收原来的包装逻辑」。不要写「更容易维护」或「代码更干净」；这些说法不在术语表中，也没有说明实际收益。

不要含糊措辞，不写开场套话，也不要写「值得注意的是……」。能写成列表项的句子，就用列表项；能删掉的列表项，就删掉。某个词不在 `codebase-design` 的术语表中时，先找已有术语，不要急于创造新词。
