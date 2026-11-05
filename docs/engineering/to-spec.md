## What it does

`to-spec` 将刚刚完成的对话整理成一份**[规格说明](https://www.aihero.dev/ai-coding-dictionary/spec)**，并以一张工单的形式发布到工单跟踪器。

它不会访谈用户。使用它时，决策已经完成。因此，它只综合已有信息（来自对话、代码库、`GLOSSARY.md` 和架构决策记录 ADR），不会开始新一轮提问。规格说明记录已经作出的决策，不是作出新决策的地方。

## When to reach for it

输入 `/to-spec` 主动调用；[agent](https://www.aihero.dev/ai-coding-dictionary/agent) 不会自行调用。

当构建工作太大，无法在一个 agent [会话](https://www.aihero.dev/ai-coding-dictionary/session)中完成，必须分到多个会话时使用。适用边界仅此而已：

| 当前情况 | 使用方式 |
| --- | --- |
| 尚未作出任何决策 | 先用 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |
| 决策已定，工作能放进一个[上下文窗口](https://www.aihero.dev/ai-coding-dictionary/context-window) | 用 [implement](https://aihero.dev/skills-implement)，跳过规格说明 |
| 决策已定，工作跨多个会话 | 先用 `/to-spec`，再用 [to-tickets](https://aihero.dev/skills-to-tickets) |
| [wayfinder](https://aihero.dev/skills-wayfinder) 地图中的待决问题已全部解决 | `/to-spec #<map_issue>` |

## Prerequisites

`to-spec` 将规格说明发布为工单，因此必须先由 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 为仓库配置跟踪器及分诊标签词汇。两种跟踪器均可：GitHub 等真实跟踪器，或 `.scratch/` 下的本地 Markdown 文件；本地模式无须额外配置。

## 规格说明是决策记录

上下文窗口会结束，因此需要规格说明。在[深入提问](https://www.aihero.dev/ai-coding-dictionary/grilling)的过程中，已经确定了许多事情：解决方案的形态、反复讨论过的选择，以及明确拒绝的事项。这些都在即将清空的一段对话中。规格说明将它们保留下来。

因此，规格说明不验证任何事情，也不作出决策。它用项目自己的词汇记录已有决策，让新会话能够接手工作，无须再次解释。如果规格说明写了从未说过的内容，那就是缺陷。

## 先确定接缝，再写正文

在动笔前，`to-spec` 会概述测试功能所用的**接缝**（seam），并与用户确认。它优先使用已有接缝，而非新建接缝，并选择尽可能高层的接缝。一项变更的理想接缝数量是一个。

其他技能随后会使用这些已约定的接缝。[tdd](https://aihero.dev/skills-tdd) 只在事先约定的接缝上工作。[code-review](https://aihero.dev/skills-code-review) 对照规格说明审查差异，因此未经约定的接缝会成为审查发现。这两项衔接都通过本文档完成。所以应在这里认真确认接缝，不要留到实现时再决定。

## Common questions

**`/to-prd` 去哪里了？**

它就是本技能，在 v1.1 中改名。现在统一使用「规格说明（spec）」这一术语，旧的 `to-prd` 标识已失效，需要按新名称重新安装。旧词汇由「规格说明」和「工单」这一对概念取代。规格说明描述目的地以及确定目的地的决策，[工单](https://www.aihero.dev/ai-coding-dictionary/ticket)则是到达目的地的步骤。如果改变方向，删除未完成的工单，保留规格说明。

**为什么规格说明会添加 `ready-for-agent` 标签？我不想让 agent 直接照着它实现。**

该标签表示「无须进一步分诊」：文档已经足够完整，agent 可以据此工作。它标记的是输入材料，而非执行指令。但轮询 `ready-for-agent` 的 [AFK](https://www.aihero.dev/ai-coding-dictionary/afk) agent 无法区分两者。它们会尝试在一次运行中实现整份规格说明，而不是领取切片工单。这是本技能收到最多反馈的问题。在行为改变之前，应在 AFK agent 的提示中明确排除父级规格说明工单，或在 `/to-tickets` 运行后移除该标签。

**为什么不从深入提问直接进入 `/to-tickets`，跳过规格说明？**

很多时候确实应跳过。只有跨多个会话的工作才值得增加规格说明这一步。它的价值在于：工单可以丢弃，而规格说明不应随工单丢弃。每张工单的规模适合一个全新上下文窗口，随后会被删除或关闭；规格说明则留下来，作为记录工单背后理由的唯一位置。对于单会话变更，这没有收益，反而多付出一次综合整理的成本，让[模型](https://www.aihero.dev/ai-coding-dictionary/model)有机会偏离原意。此时应从深入提问直接进入 `/implement`。

**刚完成 wayfinder 地图，应传给它什么？**

传入地图主工单，即 `/to-spec #<map_issue>`，而不是各张决策工单。[wayfinder](https://aihero.dev/skills-wayfinder) 产出的决策分散在地图中，而非可交付成果。`to-spec` 将它们汇总成一份可据以构建的文档。如果直接把地图送入 `/implement`，就会丢掉这一步。

**规格说明是给用户审阅的，还是只给 agent 的？**

主要给 agent，因此行文也面向 agent：内容完整、密集，包含大量引用。应阅读接缝和范围外事项这两部分。在这两处，现在发现错误决策的成本最低，日后发现的成本最高。确实有人抱怨需要阅读整篇内容，而且没有摘要模式。但如果规格说明让人意外，说明深入提问做得太浅，而不是规格说明太长。

**开始执行工单后，应冻结规格说明，还是让 agent 重写？**

没有任何机制保持它同步。实际使用中，它是当时认知的快照；实现第一次带来新认识时，它就会过时。工作交付后，可以将它视为可丢弃材料。`GLOSSARY.md` 和 ADR 才是应长期保留的文件。如果实现过程中有值得长期保留的新认识，应写入这些文件，而不是通过编辑规格说明保存。

**工作是重构或模块边界调整，而非功能开发，模板适用吗？**

适用性较差，这是已知限制。模板高度依赖用户故事，而用户故事并不适合架构工作。这样会围绕本质上涉及接口和不变量的决策，编出无人要求的故事。应改用 `Implementation Decisions` 和 `Testing Decisions` 章节记录这些内容。长期有效的架构决策应通过 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 记录为 ADR，而不是放在规格说明中。

**它会在跟踪器中检查相关工作，或引用它遵循的 ADR 吗？**

两者都不会。它会阅读并遵循所涉及领域的 ADR，但不会链接到它们。它也不会在编写前搜索跟踪器中的重叠工单，因此规格说明可能重复别人已提交的工作，而且不会有提醒。如果该领域已有很多工作，应先自行搜索跟踪器。

**`/to-tickets` 读不了规格说明，总是被截断。**

跟踪器工单可能无法完整返回很大的规格说明，也没有本地副本可供替代。解决方法是：不要在 `/to-spec` 和 `/to-tickets` 之间[清空上下文](https://www.aihero.dev/ai-coding-dictionary/clearing)或[压缩上下文](https://www.aihero.dev/ai-coding-dictionary/compaction)。在同一个上下文窗口内运行两者，`/to-tickets` 就无须重新获取规格说明。

## It's working if

- 它着手编写，而不是开始新一轮访谈。
- 它在编写前展示接缝，并尽量减少接缝数量。
- 它使用项目自己的名词，而非通用的产品管理套话。
- 文档中的每项决策都能回忆起何时作出；它没有为了填满章节而编造内容。
- 范围外事项列出的是真实内容。明确拒绝的事项通常是文档中最有用的部分。

## Where it fits

`to-spec` 是主构建链中的一步，但仅适用于跨多个会话的分支：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

上游的 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 负责作出决策，本技能只记录这些决策；完成的 [wayfinder](https://aihero.dev/skills-wayfinder) 地图也从这里接入构建链。下游的 [to-tickets](https://aihero.dev/skills-to-tickets) 将规格说明切分为曳光弹工单，供 [implement](https://aihero.dev/skills-implement) 构建。不确定适合哪个技能或流程时，由 [ask-matt](https://aihero.dev/skills-ask-matt) 提供路由建议。
