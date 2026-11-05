## What it does

`domain-modeling` 在设计过程中构建并完善项目的**通用语言（ubiquitous language）**。它质疑与术语表冲突的用词，要求把模糊说法换成准确术语，并通过具体场景检验概念关系，直到边界清晰。

这是一套**主动**建模方法，而非被动读取。任何技能都能读取 `GLOSSARY.md` 并沿用其中词汇；本技能用于*修改*领域模型，因此会打断讨论进行澄清。术语一旦确定，就在对话过程中立即写入 `GLOSSARY.md`，而不是等到最后再产出一份整齐的术语表。结束时编写的术语表是[会话（session）](https://www.aihero.dev/ai-coding-dictionary/session)摘要；即时写入的术语表则是会话的产物。

## When to reach for it

可以输入 `/domain-modeling` 主动调用，[agent](https://www.aihero.dev/ai-coding-dictionary/agent) 也可以在任务适合时自动调用。实践中，自动调用是本技能最薄弱的环节。当 `grill-with-docs` 或 `wayfinder` 要求加载它时，[模型（model）](https://www.aihero.dev/ai-coding-dictionary/model) 经常加载 `grilling`，却跳过本技能。如果一次[深入访谈（grilling）](https://www.aihero.dev/ai-coding-dictionary/grilling)中已经确定了需要记录的术语，结束时 `GLOSSARY.md` 却没有变化，就需要检查是否漏加载了本技能。除另一个技能外，也明确按名称调用它。

当问题出在*用词*上时，使用本技能：

| 情况 | 做法 |
| --- | --- |
| 两个人对「cancellation」的理解不同 | `domain-modeling`：选定规范术语，在 `_Avoid_` 下列出另一个用词 |
| 「Account」在三个文件中承担三种含义 | `domain-modeling`：拆分为 Customer 和 User |
| 刚作出一个难以撤销的架构选择 | `domain-modeling`：如果选择满足条件，它会提议编写架构决策记录（ADR） |
| 问题在于模块的*形态*：接缝放在哪里、接口有多深 | [codebase-design](https://aihero.dev/skills-codebase-design) |
| 希望在构建前深入检验整个计划 | [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，它在底层驱动本技能 |
| 只想查阅术语，而非修改术语 | 不需要技能。读取 `GLOSSARY.md` 即可，它就是一个文件。 |

## Prerequisites

无需提前准备文件，但需要一个可以安全写入的仓库。技能写入以下两个位置，并且都按需创建：

- **`GLOSSARY.md`**：位于仓库根目录，在第一个术语确定时创建。如果根目录存在 `GLOSSARY-MAP.md`，术语改为写入映射文件所指向的对应上下文的 `GLOSSARY.md`。
- **`docs/adr/`**：在需要第一份符合条件的 ADR 时创建。

开始前不需要这些文件或目录，技能也不会提前创建它们。

## 两种产物，两套条件

术语表和 ADR 的写入条件不同。本技能的大多数问题都来自混淆两者。

| | `GLOSSARY.md` | `docs/adr/NNNN-slug.md` |
| --- | --- | --- |
| 内容 | 术语。用一两句话定义事物**是什么**，在 `_Avoid_` 下列出舍弃的同义词 | 一项决策，用 1 至 3 句话说明背景、选择和原因 |
| 写入条件 | 模糊用词成为规范术语 | **三项同时满足**：难以撤销、缺少背景就令人费解、确实权衡过不同方案 |
| 写入方式 | 术语确定时即时写入 | 先提议，而非默认创建 |
| 绝不包含 | 实现细节、[规格说明（spec）](https://www.aihero.dev/ai-coding-dictionary/spec)、草稿笔记、通用编程概念 | 本次会话中每一个选择的流水账 |

ADR 的三项条件缺少任何一项，就不写。容易撤销的决策到时候直接撤销即可；不令人费解的决策不会引起追问；没有真正替代方案的决策，只能记录「采用了显而易见的做法」。

`GLOSSARY.md` 的规则最重要，因为实践中最容易违反它。**它只是术语表，不承载其他内容。**如果不加约束，模型会把「写入 `GLOSSARY.md`」理解为允许保存每一个回答，文件就变成持续扩展的规格说明。这是跨多个模型报告最多的问题。

## 交叉核对的范围与边界

当使用者说明某个机制如何运作时，技能检查代码并指出矛盾。*「代码取消的是整个 Orders，但刚才说可以部分取消，哪一个才是正确的？」*在修改用语或代码之前，它会先明确核对两者，使其一致。

它只交叉核对**代码**以及已提交的 `GLOSSARY.md` 和 ADR，不查其他来源，也不搜索工单跟踪器。如果团队几个月前已在一个关闭的工单中解决命名冲突，技能仍会当作新问题重新提出。对此已有[尚未解决的请求](https://github.com/mattpocock/skills/issues/717)。目前的变通办法是把相应指令写入仓库自己的 `docs/agents/domain.md`，技能集合已经会读取该文件。

## Common questions

**`GLOSSARY.md` 已有 500 行、1,000 行，甚至 3,000 行。怎么办？**

长度是症状。原因是文件纳入了本不属于术语表的实现细节和决策。修正办法是直接下达指令：`/grill-with-docs make my GLOSSARY.md more concise and remove any implementation details from it`。对臃肿文件运行后，大部分内容会被移除。只有文件已经精简，却仍涵盖两个读者不愿同时记住的领域时，才用 `GLOSSARY-MAP.md` 拆分。拆分臃肿文件，只会得到多个臃肿文件。目前，技能的指引还不足以从一开始阻止这种增长，相应工单仍未解决。

**为什么叫 `GLOSSARY.md`，而不是 `CONTEXT.md`？**

在 1.3.0 之前，它叫 `CONTEXT.md`（映射文件叫 `CONTEXT-MAP.md`）。文件只是术语表，`GLOSSARY.md` 能直接表达这一点；正如一位读者所说：「with ai agents everything is [context](https://www.aihero.dev/ai-coding-dictionary/context)」。如果仓库仍有 `CONTEXT.md`，由用户重新运行 `/setup-matt-pocock-skills`：它会提议用 `git mv` 移动文件，并更新 `docs/agents/domain.md`。技能集合中的每个技能都查找 `GLOSSARY.md`，保留旧名称就意味着逐个修改它们。

**`/ubiquitous-language` 去哪里了？**

它已被删除，不是弃用。其职责移入 `domain-modeling`，持续维护整个模型，而不是从一段对话中集中生成术语表。词汇约束变得更重要，而非更不重要。它在 grilling、triage（工单分诊）和制图过程中运行，不再是需要另行记住的独立步骤。

**如何为没有术语表的代码库建立术语表？**

明确提出要求，不要等待它慢慢积累。文档给出的用法是 `/grill-with-docs help me scaffold my existing repo with a GLOSSARY.md`。需要做好长时间深入访谈的准备。一位用户报告，在文件成形之前回答了超过 50 个问题。对已有代码库而言，顺带使用本技能，术语表积累得太慢。

**可以保留领域模型，但使用自己的 ADR 格式吗？**

目前无法顺畅地做到。术语表部分和 ADR 部分随同一个技能交付，因此已经有 ADR 约定（不同模板、位置或命名）的团队会遇到与内部规范冲突的指令。目前可以将技能复制到本地后修改，或者在仓库自己的 agent 文档中覆盖 ADR 约定。拆分这两部分已有[尚未解决的请求](https://github.com/mattpocock/skills/issues/557)。

**术语表真的值得维护吗？它多了一份需要审查的产物，而且可能过时。**

有时不值得。领域驱动设计（DDD）越接近实现层面，价值越低。收益在更早的命名和概念统一阶段，而不在聚合或分层形式本身。同义词控制在命名边界上很重要：模块名、表名、状态枚举、工单标题和 CLI 命令；在普通文字中则没那么重要。也有反对意见认为，领域术语压缩的是*已经掌握它的人之间*的沟通，agent 对普通英文描述的响应并无区别。依此理解，术语表的价值在于让使用者和审查者对 agent 正在做的事保持共同理解，而不是让 agent 更强。对于只需一天完成的构建，跳过术语表维护。未经审查、由 agent 编写的术语表比没有更糟：其中充斥着看似确定的断言，后续会话会把它们当作事实。

**能替我把模糊提示转换成领域语言吗？**

不能，也没有计划提供这样的技能。自己都不理解的领域语言，写下来也没有意义。本技能在已有理解的基础上要求准确表达，不会凭空发明使用者尚未掌握的词汇。相关陷阱是只用领域词汇，却不做建模。把正确的名词套在错误的概念上，产物看起来正确，实际上并不正确。

## It's working if

- 它会中途打断，询问指的是两个概念中的哪一个，而不是自行选择后继续。
- `GLOSSARY.md` 在对话**过程中**变化，而不是最后集中更新。
- 对于明天就能撤销的选择，它拒绝编写 ADR，并说明三项条件中的哪一项未满足。
- 新条目用一两句话定义事物*是什么*，并在 `_Avoid_` 下列出舍弃的用词。
- 代码与说法矛盾时，它会引用代码指出问题。
- `GLOSSARY.md` 既会变长，也同样经常变短。

## Where it fits

`domain-modeling` 是**模型或用户均可调用的参考技能**，多数时候在其他技能*底层*运行，而非独立运行。[grill-with-docs](https://aihero.dev/skills-grill-with-docs) 在深入访谈中驱动它；[wayfinder](https://aihero.dev/skills-wayfinder) 在绘制地图时加载它；[triage](https://aihero.dev/skills-triage) 用它让[工单（ticket）](https://www.aihero.dev/ai-coding-dictionary/ticket)保持项目用语；[improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 在决策明确时调用它。最接近的相邻技能是 [codebase-design](https://aihero.dev/skills-codebase-design)。两者共同构成其他工作的词汇层：本技能负责*领域*，另一个负责模块*形态*。如果只需要这套方法，不想启动通常负责加载它的技能的完整步骤，也可以直接调用。不确定哪个技能合适时，使用 [ask-matt](https://aihero.dev/skills-ask-matt) 路由。
