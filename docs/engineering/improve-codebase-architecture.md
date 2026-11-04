## What it does

`improve-codebase-architecture`（代码库架构改进）扫描代码库中的**深化机会（deepening opportunities）**：找出接口（interface）几乎和实现（implementation）一样复杂的浅模块（shallow module），判断哪里可以改为深模块（deep module）。它先生成单文件 HTML 报告，再围绕选中的候选方案开展[访谈澄清（grilling）](https://www.aihero.dev/ai-coding-dictionary/grilling)。默认使用简体中文提问、解释和生成报告，英文技能标识、命令、路径及代码标识保持稳定。

它不直接修改业务代码。报告保存在操作系统临时目录，重构留到之后的独立[会话（session）](https://www.aihero.dev/ai-coding-dictionary/session)，按正常实现流程执行。因此它是架构调查工具，不是自动重构工具；尚未准备好修改代码时，也可以先用它了解问题。访谈中仍可能更新领域术语表，或在用户同意后记录 ADR。

两个筛选条件让报告不至于变成泛泛的清理建议：

- 每个候选方案都必须通过**删除检验（deletion test）**：移除这个模块后，复杂度会被收进更小的接口，还是散落到调用方？只有前一种情况进入报告。
- 除非指定了区域，否则先查看近期提交历史，优先扫描经常变化的路径。没人再改的代码，即使深化，也很难产生回报。

## When to reach for it

通过 `/improve-codebase-architecture` 主动调用；[agent](https://www.aihero.dev/ai-coding-dictionary/agent) 不会自行启动它。中文显示名称不创建中文命令别名，具体的显式调用语法由[宿主（harness）](https://www.aihero.dev/ai-coding-dictionary/harness)决定。

它不是主实现流程中的固定步骤，而是定期维护工具，用来发现后续值得做的工作。

| 场景 | 用法 |
| --- | --- |
| 日常维护 | 每隔几天或有空时运行，避免新增功能期间结构持续退化。 |
| 大型改动之前 | 指向即将实现的[规格（spec）](https://www.aihero.dev/ai-coding-dictionary/spec)，询问「怎样让这次改动更容易？」这是更有效的提示方式。 |
| 现有代码库审查 | 扫描规模大、结构不统一，或主要通过 [vibe coding](https://www.aihero.dev/ai-coding-dictionary/vibe-coding) 产生的仓库，了解当前结构。 |
| 遗留代码补测试 | 先找出缺失的接缝，再为原本难以测试的代码写测试。 |

容易混淆的用途：

- 已经选定一个模块，要设计它的接口：使用 [codebase-design](https://aihero.dev/skills-codebase-design)。本技能找出该改哪个模块，`codebase-design` 提供设计词汇和方法。
- 整项工作大到一个会话无法容纳：使用 [wayfinder](https://aihero.dev/skills-wayfinder)。
- 某个具体功能已经出错：使用 [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs)。发现缺少合适测试接缝后，可以另行手动运行本技能；诊断流程不会自动调用它。

## Prerequisites

需要能访问代码库及提交历史，宿主需支持[子代理（subagent）](https://www.aihero.dev/ai-coding-dictionary/subagent)探索，并能加载 `codebase-design`、`grilling` 和 `domain-modeling` 三个依赖。选择性安装时，要保留这些依赖及其配套文件，不能只复制本技能的 `SKILL.md`。

`GLOSSARY.md` 和 `docs/adr/` 中的 ADR 不是启动前必须具备的文件。如果存在，技能会先读取，并沿用领域中的名称。例如，候选方案应写成「深化 Order 接收模块」，而不是「重构 FooBarHandler」。

它会在两类位置写入内容：

- 报告写入 `<tmpdir>/architecture-review-<timestamp>.html`，位于仓库之外。临时目录优先使用 `$TMPDIR`，未设置时回退到 `/tmp`；Windows 使用 `%TEMP%`。
- 访谈期间添加或明确 `GLOSSARY.md` 中的术语，文件不存在时按需创建。遇到有长期理由的拒绝决定时，会提议记录 ADR，避免后续重复建议。

## 深度与候选报告

本技能的核心是**深度（depth）**：深模块用小而稳定的接口提供大量行为；浅模块的接口几乎和内部实现一样复杂，未能有效隐藏复杂度。报告主要寻找以下表现：

- 纯函数仅为方便测试而被提取，真实缺陷却出在调用方式中，缺乏**局部性（locality）**。
- 模块的实现细节跨**接缝（seam）**泄漏。
- 一个概念需要打开五个文件才能理解。

候选卡片包含涉及的文件、当前阻碍、简明方案、用局部性和**杠杆效应（leverage）**说明的收益、改进前后对比图，以及推荐强度徽章。架构词汇来自 `codebase-design`，中文首次出现时附英文，之后统一使用固定译名；领域词汇以项目的 `GLOSSARY.md` 为准。

| 徽章 | 含义 |
| --- | --- |
| `Strong`（强烈推荐） | 明确通过删除检验，实际阻碍也很清楚，应认真考虑。 |
| `Worth exploring`（值得探索） | 深化方案合理，但回报取决于代码接下来如何变化。 |
| `Speculative`（推测性建议） | 用于补充可能方向，大多数可以忽略。 |

报告以**首选建议**结束，说明最先处理哪个候选方案。随后停下来询问要探索哪一个。此时没有替用户作出决定，也没有修改业务代码。

## 选中候选方案之后

选定一个候选方案后，技能调用 [grilling](https://aihero.dev/skills-grilling)，逐轮讨论约束、接缝后面放什么、哪些测试保留，以及深化后的接口形态。访谈产出是决策，不是代码差异。决策明确后，回到正常流程：[to-spec](https://aihero.dev/skills-to-spec) → [to-tickets](https://aihero.dev/skills-to-tickets) → [implement](https://aihero.dev/skills-implement)。

## Common questions

**它围绕一个想法问了很久，却没有先给选项。可以跳过访谈吗？**

调用时可以明确说「不要访谈，只给报告」。这是原有反馈中常见的问题：有用户原本把它当作全面分析改进方向的便捷工具，加入访谈后却遇到围绕一个方案连续追问几十甚至上百个问题的情况。设计意图是先给报告，仅在用户选中候选方案后开始访谈，但较弱的[模型（model）](https://www.aihero.dev/ai-coding-dictionary/model) 可能跳过报告，直接追问第一个想法。结果随模型而异；技能尚未提供正式的「无访谈模式」，中文化也没有新增这个模式。

**报告打开后只有无样式的 HTML，没有图示，是什么原因？**

Tailwind 和 Mermaid 从 CDN 加载，打开报告时需要网络访问。脚本被拦截时，页面可能失去样式或图示，却没有明显提示。已有报告中，安全钩子要求添加 SRI 哈希，但 CDN 向浏览器返回的内容与计算哈希时 `curl` 获取的内容不同，浏览器因此阻止加载。离线或受限网络环境也会遇到同类问题。agent 不会实际渲染页面，因此无法直接看到这个故障。可明确要求改用内联 CSS 和手工 SVG 图示；这不是本次中文化新增的自动回退，默认仍使用 CDN。

**它给了十二个候选方案，要在同一会话里逐个处理吗？**

建议每个会话只处理一个候选方案。多个方案的报告、访谈和领域模型修改，再加上后续代码修改，会一起占用[上下文窗口（context window）](https://www.aihero.dev/ai-coding-dictionary/context-window)。报告只是临时文件，后续应携带具体候选内容，而不是依赖报告文件长期存在。选择一个，完成访谈，将决策交给 `/to-spec`；其余候选可以记成[工作项（ticket）](https://www.aihero.dev/ai-coding-dictionary/ticket)，之后分别处理。先形成规格，不要直接跳到实现；技能正文没有规定完整的多候选处理流程。

**应该怎样提示它？**

告诉它接下来要构建什么。大型改动之前，指向规格，询问「怎样让这次改动更容易？」不指定方向时，它会自行寻找近期变化热点，适合日常维护；给出方向则更容易得到可执行的报告。

**它适合大型遗留代码库吗？**

部分适合。它能为规模大、缺乏统一结构的现有代码库找出维护方向，也适合一次性结构整理之后的定期维护，但不能自动解开所有历史问题。已有用户反馈，它对失控的项目只有有限帮助；一个维护了八年的遗留代码库曾让模型反复绕圈，而整洁仓库更容易得到清晰图示。当前没有专门解决这类问题的 `/refactor` 技能。代码库缺少共享词汇时，可先使用 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 建立领域语言，通常能改善报告质量。

**它与 `/codebase-design` 有什么不同？**

`codebase-design` 是设计参考，不是独立会话的流程驱动器。它提供模块、接口、深度、接缝、适配器、杠杆效应和局部性等词汇，本技能用这些词汇组织架构调查。只把 `/codebase-design` 当作任务交给全新的 agent，可能让它自行发明探索流程、长时间扫描却不提问。要调查架构，运行本技能，并让它加载该参考。

**它会告诉我代码库已经很好、不需要改吗？**

很少。技能以输出候选发现为目的，容易给出候选，而不是得出「没有问题」。因此要结合推荐强度判断：如果全是 `Speculative`，就应视为没有找到明确值得做的改进。

**它能在 Codex 或其他宿主中使用吗？**

当前指令只要求派子代理探索，并未指定 Claude Code 的 `Agent` 工具或 `subagent_type=Explore`；这类硬编码已在 v1.2.3 移除。但宿主仍需具备子代理能力，并能执行 `Skill` 依赖调用。缺少这些能力时，不能把只读到正文或生成报告当作完整流程验收。本次中文化保留原有调用约定，没有替换子代理或增加宿主适配。

**怎样在 TypeScript 中实际实现深模块？**

技能没有提供具体的 TypeScript 文件或模块布局。用户常希望获得一份 `TYPESCRIPT.md`，但它尚未随本技能提供。这里能确定哪里值得深化、接缝后面放什么，具体的包或目录结构仍需在设计和实现阶段决定。

## It's working if

- 候选方案使用项目中的领域概念，例如「Order 接收模块」，而不是虚构类名。
- 未指定方向时，候选方案优先来自最近修改的文件，而不是无人再改的区域。
- 报告期间没有修改业务代码，HTML 文件写在临时目录；访谈中的术语表或 ADR 修改有明确用途。
- 默认看到中文报告和问题，命令、文件路径及代码标识没有被翻译。
- 报告完成后停下来等待选择，不会自行开始围绕第一个候选方案访谈。
- 每张卡片用局部性或杠杆效应说明收益，并指出哪些测试变简单，而不只是说「更干净」。
- 因一个长期有效的理由拒绝候选方案时，它会提议记录 ADR，避免下次再次建议。

## Where it fits

`improve-codebase-architecture` 是**定期维护**工具：每隔几天在主流程之外运行，用来发现工作，而不是执行重构。它使用 [codebase-design](https://aihero.dev/skills-codebase-design) 的深模块词汇，选定候选方案后通过 [grilling](https://aihero.dev/skills-grilling) 明确决策，并由 [domain-modeling](https://aihero.dev/skills-domain-modeling) 维护术语表和 ADR。

产出的想法回到主流程时：

- 仍需澄清：使用 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)。
- 决策明确：进入 [to-spec](https://aihero.dev/skills-to-spec)。

它改善 agent 工作的代码库结构；主流程末尾的 [retro](https://aihero.dev/skills-retro) 则改善检查、规范和指引文件等环境。需要判断该用哪个技能时，使用全局路由 [ask-matt](https://aihero.dev/skills-ask-matt)。
