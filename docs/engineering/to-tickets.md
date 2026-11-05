## What it does

`to-tickets` 将计划、[规格说明](https://www.aihero.dev/ai-coding-dictionary/spec)或当前对话拆成一组工单跟踪器中的**[工单](https://www.aihero.dev/ai-coding-dictionary/ticket)**。每张工单声明其**阻塞关系**（blocking edges）：必须先完成哪些其他工单，它才能开始。

每张工单都是一枚**曳光弹**（tracer bullet）：贯穿变更所有层（数据模式、API、UI、测试）的一条狭窄但完整的路径，合入后即可独立演示。这与常见的拆分方式不同：不是每次只切一层，最后才集成。它还将每张工单的规模限制在一个全新的[上下文窗口](https://www.aihero.dev/ai-coding-dictionary/context-window)内，因为领取工单的[会话](https://www.aihero.dev/ai-coding-dictionary/session)从未见过规格说明。

## When to reach for it

输入 `/to-tickets` 主动调用。[agent](https://www.aihero.dev/ai-coding-dictionary/agent) 不会自行调用。

| 当前情况 | 使用方式 |
| --- | --- |
| 已有规格说明工单，构建工作跨多个会话 | `/to-tickets` 或 `/to-tickets #<spec_issue>` |
| 计划只存在于对话中，从未成文 | `/to-tickets` 直接读取对话，不需要规格说明 |
| 整项变更能放进一个上下文窗口 | 用 [implement](https://aihero.dev/skills-implement)，跳过工单拆分 |
| 尚未作出任何决策 | 先用 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，再用 [to-spec](https://aihero.dev/skills-to-spec) |
| [wayfinder](https://aihero.dev/skills-wayfinder) 地图中的待决问题已全部解决 | 先用 [to-spec](https://aihero.dev/skills-to-spec) 汇总地图，再用 `/to-tickets` |

`to-tickets` 生成的工单本身就已满足 agent 可执行的要求。不要再对它们运行 [triage](https://aihero.dev/skills-triage)。分诊适用于别人提交的工作。

## Prerequisites

`to-tickets` 将工单发布到跟踪器，因此必须先由 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 为仓库配置跟踪器及分诊标签词汇。两种均可：GitHub、Linear 等真实跟踪器，或 `.scratch/` 下的本地 Markdown 文件；本地模式无须额外配置。

## 曳光弹，而非分层

**横向**切片只交付变更的一层。在所有层合入之前，什么都无法工作，而且每张工单的验收标准都要涉及另一张工单负责的工作。**纵向**切片（即曳光弹）一次交付贯穿所有层的一条细路径，因此可以独立验证，并负责验收所涉及的全部内容。

这是最常被违反的规则。一个团队按层（corpus、producer、aggregator、selector）拆出一组 26 张工单，结果平均每关闭一张工单就要运行约 20 次 agent，其中约四分之三是在返工。他们自己的复盘将每类失败都追溯到横向切分，而不是具体实现。

发布前会发生两件事。`to-tickets` 寻找预重构（prefactoring）的机会，即先让变更容易，再完成容易的变更（原文为「make the change easy, then make the easy change」），并将这类工作排在前面。然后，它用编号列表展示拆分方案，请用户逐项确认：粒度是否合适、阻塞关系是否真实、是否应合并或拆分。用户批准之前，什么都不会发布到跟踪器；这个确认环节正是提出异议的时机。

## 阻塞关系

阻塞关系是这一产物的核心。它们有两种表示方式，取决于跟踪器：

| 跟踪器 | 阻塞关系记录在哪里 | 如何执行 |
| --- | --- | --- |
| 本地 Markdown | `.scratch/<feature>/issues/<NN>-<slug>.md` 下每张工单一个文件，以文字记录，阻塞其他工单的工单先编号 | 先完成阻塞工单；完全线性的依赖链可手动自上而下执行 |
| 真实跟踪器（GitHub、Linear） | 优先使用原生阻塞链接；不支持时在 `Blocked by` 中记录 | 阻塞工单均已完成的可执行工单集合称为**前沿**（frontier），其中任何工单都可领取 |

无论哪种模式，阻塞关系都记录在工单中；跟踪器决定其表示方式。在真实工单跟踪器模式下，若来源是已有工单，还会按跟踪器文档将各张新工单设为其子工单。父子关系表示归属，不替代阻塞关系。`to-tickets` 负责产出工单；如何执行（逐个会话，或一组 agent 并行）由用户选择，不是本技能的职责。

## 宽范围重构例外

有一种工作不适用曳光弹规则。**宽范围重构**是一项机械式变更（例如重命名列或修改共享符号的类型），其**影响范围**（blast radius）覆盖整个代码库。一次编辑就会破坏数千个调用点，因此任何纵向切片都无法在合入时保持绿灯。

`to-tickets` 改为按**扩展后收缩**（expand-contract）安排顺序：

- **扩展（Expand）**：在旧形式旁添加新形式，保证不破坏现有行为。
- **迁移（Migrate）**：按影响范围分批迁移调用点（例如按包或目录划分），每批一张工单，每张都由扩展工单阻塞。由于旧形式仍然存在，CI 保持绿灯。
- **收缩（Contract）**：在没有任何调用方使用旧形式后，将其删除；这张工单由所有迁移批次阻塞。

如果连各批次都无法独立保持绿灯，它们会共用一个集成分支，并共同阻塞最后的集成与验证工单。只要求在最后这张工单处保持 CI 绿灯。

## Common questions

**只有三行变更，却生成了十二张工单。**

过度拆分是本技能收到最多反馈的问题，许多用户都遇到过。[模型](https://www.aihero.dev/ai-coding-dictionary/model)默认偏向原子单元，丢失了能让这些单元有意义的分组。逐项确认环节就是纠正这一点的地方。要求它合并工单，它就会合并。也有一个规模下限：如果整项变更能放进一个上下文窗口，就根本不需要本技能，直接用 [implement](https://aihero.dev/skills-implement)。

**工单按层拆分了：所有数据模式放一张，所有 API 放另一张。**

纵向切片规则正是为避免这种失败而制定的，但本技能偶尔仍会这样拆。应在逐项确认时对每张工单问一个问题：完成后能演示什么？答不出来的工单就是横向切片。有人因此在每张工单中增加「演示路径」一行，并反馈这能推动模型采用纵向切片。

**GitHub 上的工单没有创建为规格说明工单的子工单。**

这一问题在 12 次运行和多个模型中被报告，[工单 #554 中的报告最完整](https://github.com/mattpocock/skills/issues/554)。现已修复：`to-tickets` 会将每张工单设为来源工单的子工单，GitHub 跟踪器模板也提供了命令（`gh issue create --parent <n>`，要求 `gh` 2.94+）。重新运行 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills)，即可更新旧版 `docs/agents/issue-tracker.md`。

**`Blocked by` 写进了工单正文，而不是真实的阻塞链接。**

这是同类问题，[工单 #513 中曾报告](https://github.com/mattpocock/skills/issues/513)，当时 agent 甚至声称 GitHub 完全没有原生阻塞关系。实际上有：`gh issue create --blocked-by 12,15`。由于本技能先发布阻塞其他工单的工单，创建被阻塞工单时，总能获得其阻塞工单的编号。正文文字本应是跟踪器不支持原生关系时的回退方式，而非默认方式。现在，如果关系已设为原生关系，工单模板会省略 `## Blocked by`。

**本地工单放在哪里？v1.1 说明里写的是根目录的 `tickets.md`。**

当时确实如此，这是一个缺陷。并行 agent 写入同一个共享文件还会产生竞态条件。本地模式现在按依赖顺序，在 `.scratch/<feature-slug>/issues/<NN>-<slug>.md` 下为每张工单写一个文件，与本地跟踪器模板已经描述的布局一致。`NN` 前缀是真实工单 ID，因此可以用 `/implement 03`，无须重新输入很长的标题。

**读取规格说明时总是被截断。**

很大的规格说明可能超出跟踪器工单能够完整返回的内容范围。没有本地副本可供回退，因此 agent 会消耗[工具调用](https://www.aihero.dev/ai-coding-dictionary/tool-call)，反复获取片段，却始终读不到结尾。不要在 `/to-spec` 和 `/to-tickets` 之间[清空上下文](https://www.aihero.dev/ai-coding-dictionary/clearing)或[压缩上下文](https://www.aihero.dev/ai-coding-dictionary/compaction)。在同一个上下文窗口内运行两者，agent 就无须重新获取规格说明。

**验收标准没有真正验收任何内容，有些在尚未开始工作时就已通过。**

模板要求填写标准，却没说明这些标准是否能够失败，因此会出现这种情况。常见的有三种：

- 在基线提交上就已成立的标准。
- 只有另一张工单的工作才能满足的标准。
- 只是重述请求，而非从产物推导出的标准。

纵向切片能避免其中大部分问题，因为交付新行为的切片，在基线提交上自然无法通过验收。但仍值得人工检查。对每项标准，指出哪种可观察结果能证明它不成立，并确认在实现者开始工作的提交上，该标准无法通过。

**工单已发布，实际怎样执行？**

本技能在产出工单后停止，没有自动派发模式。派发需要手动完成：查看看板，数出没有未完成阻塞工单的工单，再开启相应数量的 agent 会话。给每张工单一个全新的上下文，在工单之间清空上下文。无论在 GitHub 还是本地 Markdown 中，[implement](https://aihero.dev/skills-implement) 完成后都不能可靠地关闭工单或勾选完成状态，因此需要自行更新工单状态。

## It's working if

- 每张工单都能回答「完成后能演示什么？」，答案是行为，而不是某一层。
- 发布前，拆分方案会以编号列表交给用户，每张工单都有 `Blocked by` 一行。
- 排在最前面的工单没有阻塞工单，可以立即开始。
- 工单正文不包含文件路径或行号，原型产出的片段除外。
- 每张工单都像是一个新会话能够独立完成的工作，无须用户在场补充解释。
- 如果找到了预重构工作，它会排在前面，而不是混入功能工单中。

## Where it fits

`to-tickets` 是主构建链中的一步：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

上游的 [to-spec](https://aihero.dev/skills-to-spec) 提供已定稿的规格说明，供本技能据此切分。两者应在同一个上下文窗口内运行，中间不要清空上下文。下游的 [implement](https://aihero.dev/skills-implement) 在每个全新会话中构建一张工单，用 [tdd](https://aihero.dev/skills-tdd) 驱动测试，并以 [code-review](https://aihero.dev/skills-code-review) 收尾。[implement-spec](https://aihero.dev/skills-implement-spec) 是另一条下游路径：它将同一组阻塞关系读为任务图，在一个集成分支上并行构建所有就绪工单。不确定适合哪个技能或流程时，由 [ask-matt](https://aihero.dev/skills-ask-matt) 提供路由建议。
