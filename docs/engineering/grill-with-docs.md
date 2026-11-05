## What it does

`grill-with-docs` 围绕计划或设计进行访谈，直到使用者与 [agent](https://www.aihero.dev/ai-coding-dictionary/agent) 达成共同理解，并在过程中把术语和重大决策写入仓库。它与 [grill-me](https://aihero.dev/skills-grill-me) 使用相同的访谈方式（提问一轮，等待回答，再进入下一轮），但面向代码库。

它是**[有状态的（stateful）](https://www.aihero.dev/ai-coding-dictionary/stateful)**。其他 grilling 技能把[会话（session）](https://www.aihero.dev/ai-coding-dictionary/session)的结果留在脑中；这个技能会在磁盘上留下文件。术语一旦确定，就立即写入 `GLOSSARY.md`，而不是等到最后集中处理。决策通过三项条件后，会写成架构决策记录（ADR）。这就是全部区别，也是使用者遇到的大多数问题的起因。产物是真实仓库中的真实文件，因此预期的文件可能没有出现，多人编写时内容也可能发生偏移。

## When to reach for it

输入 `/grill-with-docs` 主动调用，agent 不会自行启动它。

在仓库中开始一项变更时，如果计划仍不清晰、相关用词尚未确定，就使用它。它适合在一次会话中完成规划。选择哪一个 grilling 技能，取决于眼前的情况：

| 当前情况 | 使用的技能 |
| --- | --- |
| 完全不在工作目录中开展工作 | [grill-me](https://aihero.dev/skills-grill-me) |
| 有仓库，且能在一次会话中确定这项变更 | `grill-with-docs` |
| 工作规模太大，一次会话容纳不下（全新构建、大型功能） | [wayfinder](https://aihero.dev/skills-wayfinder) |
| 仓库完全没有领域文档，也没有要讨论的特定功能 | `grill-with-docs`，把目标指向仓库而不是某项变更 |
| 某项决策被他人掌握的知识阻塞 | [to-questionnaire](https://aihero.dev/skills-to-questionnaire) |

与 wayfinder 的分界取决于会话数量：`/grill-with-docs` 用于单次会话规划，`/wayfinder` 用于跨多次会话的规划。

## Prerequisites

技能会写入仓库，因此需要处于可以安全写入的位置。确定的术语进入根目录的术语表 `GLOSSARY.md`；如果根目录的 `GLOSSARY-MAP.md` 表明仓库采用多上下文（multi-context）结构，则写入对应上下文的 `GLOSSARY.md`。决策写入 `docs/adr/`。只有需要时，技能才会创建这些文件或目录。第一个术语或决策确定之前，不会产生文件，因此无需提前准备它们。

还需要具备另外两个技能，因为 `SKILL.md` 中的业务指令只有一行，委托它们完成工作。[grilling](https://aihero.dev/skills-grilling) 提供访谈，[domain-modeling](https://aihero.dev/skills-domain-modeling) 提供文档编写。只安装 `grill-with-docs`，技能无法正常工作。

## 留下的记录

一次会话会产生三类结果，但它们并不等价。

| 已确定的内容 | 记录位置 |
| --- | --- |
| 术语：项目对某个事物的专用词 | `GLOSSARY.md`，术语确定时即时写入 |
| 难以撤销、缺少背景就令人费解、且确实权衡过不同方案的决策 | `docs/adr/` 下的 ADR |
| 其他所有决定 | 只留在对话中 |

第三行最容易出乎意料。`GLOSSARY.md` 只是术语表，不包含实现细节、[规格说明（spec）](https://www.aihero.dev/ai-coding-dictionary/spec)或草稿笔记。ADR 必须同时满足三项条件，因此大多数决策不符合要求，大多数会话不会产生 ADR。术语表变得更准确而 ADR 数量为零，符合技能的设计；但这也意味着，大多数共识只存在于当时的[上下文窗口（context window）](https://www.aihero.dev/ai-coding-dictionary/context-window)中。把同一段对话交给 [to-spec](https://aihero.dev/skills-to-spec)，不要直接[清空（clearing）](https://www.aihero.dev/ai-coding-dictionary/clearing)它。

术语表是主要产物。技能构建领域语言：把项目专用词一次确定下来，使用者、agent 和同事就不必反复讨论同一套用词。并非所有人都认同这能改善 agent 的表现。最有力的反对意见是：术语和它的普通英文释义会让[模型（model）](https://www.aihero.dev/ai-coding-dictionary/model)产生相同结果，词汇主要缩短了掌握它的人之间的沟通。在这种观点下，术语表仍有价值，但价值主要属于人。

## Common questions

**应该用这个技能，还是 `/wayfinder`？**

由范围决定。能在一次会话中确定的工作使用本技能；规模太大、一次会话容纳不下时，使用 [wayfinder](https://aihero.dev/skills-wayfinder)，它会先把工作组织为决策[工单（ticket）](https://www.aihero.dev/ai-coding-dictionary/ticket)地图。Wayfinder 更慢、内容更密集，对范围明确的功能使用它是常见误区。它不取代本技能，而且可以针对地图中适合的部分启动 grilling 会话。

**技能运行了，但没有出现 `GLOSSARY.md` 或 ADR。**

有两个已知原因。第一，没有内容符合写入条件。ADR 需要同时满足三项条件；如果讨论的变更没有新术语，就没有术语要写。第二，确实存在缺陷。用户报告，当技能在另一层编排机制内运行时（规格驱动开发包装层、多 agent 框架，或将它作为其他流水线步骤调用的规则），访谈仍会进行，但文件编写部分会悄悄缺失。该缺陷已登记，尚未修复。如果处于这种环境，信任会话产物之前先检查工作目录。

**它一次问完所有问题，没有推荐答案，也从未提到 `GLOSSARY.md`。**

这是两个依赖技能未能加载的表现。由于 `SKILL.md` 的业务指令是一行委托调用，如果 agent 没有加载 [grilling](https://aihero.dev/skills-grilling) 和 [domain-modeling](https://aihero.dev/skills-domain-modeling)，就会自行猜测 grilling 的含义，结果是把所有问题一次抛出，毫无结构。部分加载更令人困惑：`grilling` 已加载，`domain-modeling` 未加载，于是访谈进行得不错，却没有留下文档。发生频率取决于模型和[推理投入（effort）](https://www.aihero.dev/ai-coding-dictionary/effort)级别；这是本技能被报告最多的问题。怀疑出现这种情况时，直接询问 agent 加载了哪些技能。

**其他决策都去了哪里？**

只在对话中。这是本技能尚未解决的最严重反馈。术语表不是规格说明，大多数回答不够资格成为 ADR，也没有记录把每个确定的回答关联到规格说明、工单和测试。后续步骤会把准确回答（顺序保证、明确不做什么的要求、数值默认值）弱化成不那么严格的文字；结果看似完整，却漏掉了已经确定的内容。目前，应保留会话并直接交给 [to-spec](https://aihero.dev/skills-to-spec)。然后对照自己的回答重读规格说明，不要假定它已完整记录。

**能用于完全没有文档的现有仓库吗？**

可以。对于没有 ADR、没有领域语言、没有设计原则的代码库，这就是合适的技能：主动调用，并说「帮我为仓库编写文档」。使用者经常将它与 [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 搭配，用于建立或修正 `GLOSSARY.md`。需要主动引导。它读取代码，根据发现提问，再由使用者决定代码库中已有的哪些用词是正确的。

**会话结束后应该做什么？**

技能的结束语经常没有明确后续方向，这是已知问题。主流程中的下一步是在同一段对话里使用 [to-spec](https://aihero.dev/skills-to-spec)。如果变更足够小，可以立即实现，则直接使用 [implement](https://aihero.dev/skills-implement)。

**为什么叫这个名字？**

这个名字并不令人满意。已有尚未解决的建议，希望将其改名为 `grill-domain-model`，以便更准确地描述行为。目前没有进展。如果以后真的改名，docs 页也会迁移，URL 随之改变。

## It's working if

- `GLOSSARY.md` 在会话*过程中*逐个术语地变化，而不是最后一次性出现。
- 术语表只包含词汇（项目专用词及其紧凑定义），没有实现细节或类似规格说明的文字。
- 代码库能够回答的问题，通过读取代码库得到答案，而不是拿来询问使用者。
- ADR 很少或没有；产生的 ADR 记录了那些不愿再次争论的决策。
- 它会质疑使用者的用词，因为现有术语表对该词的定义不同。

## Where it fits

`grill-with-docs` 是主要构建链的起点：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

它位于编写规格说明之前，形成共同理解并确定词汇，随后 [to-spec](https://aihero.dev/skills-to-spec) 据此综合成文，不再重新访谈。相邻技能是 [grill-me](https://aihero.dev/skills-grill-me) 和 [domain-modeling](https://aihero.dev/skills-domain-modeling)：前者运行同样的访谈，但不需要仓库、不写文件；后者提供它所驱动的术语表与 ADR 建模方法。两个访谈入口都使用 [grilling](https://aihero.dev/skills-grilling) 这一基础技能。上游的 [wayfinder](https://aihero.dev/skills-wayfinder) 为一次会话容纳不下的工作绘制地图，再把其中适合的部分交回本技能。不确定该用哪个技能或流程时，使用 [ask-matt](https://aihero.dev/skills-ask-matt) 路由。
