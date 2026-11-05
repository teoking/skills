## What it does

`implement` 实现已经决定好的工作。提供一张[工单](https://www.aihero.dev/ai-coding-dictionary/ticket)、一份[规格说明](https://www.aihero.dev/ai-coding-dictionary/spec)，或刚在对话中约定的计划，它就会编写代码，在接缝（seam）处尽可能使用 [tdd](https://aihero.dev/skills-tdd)，在实现过程中运行类型检查，最后运行 [code-review](https://aihero.dev/skills-code-review)，并提交到当前分支。

它以先前约定的工作为输入，不重新设计计划，也不重新开展需求访谈。不过，工单引用含糊时仍须提问，测试接缝也仍须确认。它的任务是将已经决定的工作变成提交。这与向一个新会话中的 [agent](https://www.aihero.dev/ai-coding-dictionary/agent) 说「构建这个」不同，后者常常在实现时重新设计工作。

## When to reach for it

需要自行输入 `/implement` 调用，agent 不会自主调用它。它设置了 `disable-model-invocation: true`，因此其他技能也不能调用它。[ask-matt](https://aihero.dev/skills-ask-matt) 或 [to-tickets](https://aihero.dev/skills-to-tickets) 中的「然后逐张工单运行 `/implement`」是给用户的指示，不是 agent 会自行执行的操作。

工作当前位于何处，决定了是否适合使用这个技能：

| 工作的状态 | 应使用 |
| --- | --- |
| 工单跟踪器中的一张工单 | `/implement #42`，每个[会话](https://www.aihero.dev/ai-coding-dictionary/session) 处理一张工单，工单之间[清空上下文](https://www.aihero.dev/ai-coding-dictionary/clearing) |
| 尚未拆分的规格说明，实现将跨越多个会话 | 先使用 [to-tickets](https://aihero.dev/skills-to-tickets)，再逐张工单运行 `/implement` |
| 规格说明，实现规模较小 | 直接针对规格说明运行 `/implement` |
| 仅存在于刚进行的对话中，且规模仍较小 | 直接在同一个窗口中运行 `/implement` |
| 尚未写在任何地方 | [grill-with-docs](https://aihero.dev/skills-grill-with-docs)；没有代码库时使用 [grill-me](https://aihero.dev/skills-grill-me) |
| 希望先写测试来实现一个具体行为，没有规格说明 | 直接使用 [tdd](https://aihero.dev/skills-tdd) |
| 已经实现，希望检查结果 | 直接使用 [code-review](https://aihero.dev/skills-code-review) |

值得特别说明同会话场景，因为技能正文的第一行并未涵盖它。`SKILL.md` 写的是「规格说明或工单」，这会促使[模型](https://www.aihero.dev/ai-coding-dictionary/model) 寻找一个并不存在的文件。如果计划只在对话中，调用时应明确说明。

## Prerequisites

`implement` 将提交写到当前分支。它不会创建分支，也不会询问。开始前，确认当前分支就是希望承载本次工作的分支。

如果工单来自 [to-tickets](https://aihero.dev/skills-to-tickets)，[setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 应已配置承载这些工单的跟踪器。`code-review` 在结束阶段读取同一配置，以找到来源规格说明。

## 实现与反馈

一次运行将约定好的工作变成代码，并在事先约定的接缝处尽可能使用 [tdd](https://aihero.dev/skills-tdd)，每次完成一个红灯／绿灯（red/green）切片。类型检查和单个测试文件提供持续反馈；完整测试套件在最后运行一次。随后进行 [code-review](https://aihero.dev/skills-code-review)，再提交到当前分支。

逐张工单使用时，一次运行处理一张工单。[to-tickets](https://aihero.dev/skills-to-tickets) 产出的工单是曳光弹（tracer bullet）式纵向切片（vertical slice），规模应能容纳在一个全新的[上下文窗口](https://www.aihero.dev/ai-coding-dictionary/context-window) 中。预期节奏是：清空上下文，实现一张工单，提交，再次清空。每张工单都自成一体，因此可以丢弃上一张工单的上下文。

## 事先约定的接缝

这个技能的核心概念是**接缝**：无需深入内部就能观察行为的公开边界。测试应位于接缝处。在代码出现之前约定接缝，测试才能长期保留；之后即使重写底层实现，也不必修改测试。

「事先约定」很重要，也是这个技能最薄弱的地方。`implement` 本身没有约定接缝的步骤。提问的是 `tdd`，它禁止在未确认的接缝处编写测试。因此，实践中应在先前的规格说明中约定，或在本次运行的第一轮交流中确认。如果两处都没有约定，运行可能退化成「直接写代码」，却没有任何提醒。在规格说明中明确写出接缝，可以避免这一点。

## Common questions

**已经完成了，但工单仍未关闭，验收标准也没有勾选。**

这是预期情况。`implement` 没有结束工单的步骤。它以提交结束，不更新工作条目。GitHub Issues 和本地 Markdown 跟踪器都是如此，因此这不是跟踪器集成故障。它也没有处理 `code-review` 审查结果或勾选来源工单中 `- [ ]` 复选框的步骤。需要自行关闭工单，并逐项核对验收标准。这在依赖链中尤其重要，因为 `to-tickets` 将前沿（frontier）定义为所有阻塞工单均已关闭的可执行工单集合。如果没有工单被关闭，后续工单就永远不会显示为解除阻塞。

**可以一次提供所有工单，或并行运行多个实例吗？**

逐张工单的推荐方式是一次 `/implement` 处理一张工单；它没有调度并行工单的步骤。要在一次运行中实现整份规格说明，使用 [implement-spec](https://aihero.dev/skills-implement-spec)：它将前沿上的每张工单交给独立 worktree 中的[子代理](https://www.aihero.dev/ai-coding-dictionary/subagent)，再将结果合入一个集成分支（integration branch）。在同一个检出目录中并排运行多个 `/implement` 会话，风险不只是缺少支持。一份实际使用报告描述了在同一天下午处理三张工单时发生的情况：一个会话的 `git commit --amend` 修改了另一个会话的提交，stash 从 `refs/stash` 消失，还有提交进入了错误分支。这些会话共享同一个工作目录、索引和 HEAD。用户会用 git worktree 来规避部分问题，但 `refs/stash` 在 worktree 之间也共享，因此 worktree 本身不能解决 stash 问题。

**可以创建拉取请求，而不是直接提交吗？**

没有内置支持。它直接提交到当前分支。一些用户认为这太急于提交，因为还没验证代码是否可用，提交就已经产生。没有配置开关，也没有 PR 模式。用户会在调用时覆盖要求（例如「提交到一个分支并创建 PR」），或修改本地技能副本。如果 agent 要编写 PR，[pr](https://aihero.dev/skills-pr) 可用于组织正文。

**`code-review` 说看不到我的修改。**

`code-review` 审查 `git diff <fixed-point>...HEAD`，不包含暂存区和工作树中的修改。`implement` 在提交之前运行审查，因此除非已经有中间提交，否则该差异中没有可审查的内容。多名用户报告过这个问题，两侧都尚未修复。可以先提交，再相对于创建分支时的固定点运行审查。这是已知问题的规避方式，不是技能当前规定的执行顺序。

另外，一些用户不希望在同一次运行中审查，因为 agent 审查自己刚写的代码时，会偏向自己的方案。在新会话中相对于固定点运行 [code-review](https://aihero.dev/skills-code-review)，是可行的替代方式。同样的偏差也是该技能将两个审查轴交给独立子代理的原因。

**一张工单消耗了 150k 个 token，是用错了吗？**

大概不是，更可能是工单太大。一次运行包含代码库探索、每个接缝的红灯／绿灯循环、完整测试套件和审查，所以一张有一定复杂度的工单消耗超过 100k 个 [token](https://www.aihero.dev/ai-coding-dictionary/token)，是常见情况，不代表哪里出了故障。应在上游解决：在 [to-tickets](https://aihero.dev/skills-to-tickets) 中合理划分工单，让每张工单都适合一个全新窗口。如果单张工单反复超出容量，应拆分它，而非提高[投入级别](https://www.aihero.dev/ai-coding-dictionary/effort)。

**在新会话中运行 `/implement #2`，却处理了完全无关的工作。**

agent 将 `#2` 解析为上下文中另一个编号列表的条目，例如待办文件或检查清单，而不是已配置跟踪器中的工单。现在，`implement` 会从工单跟踪器获取传入的引用，在开始前说明标题，并在引用含糊时提问。检查标题是否与目标工单一致；直接传入工单 URL 或 `owner/repo#2` 可以消除这种歧义。

## It's working if

- 会话开始时读取工单或规格说明，复述要实现的工作，而不是重新询问要构建什么；对含糊引用和未确认接缝的必要提问仍保留。
- 在适用 TDD 时，执行记录中能看到实际调用 `tdd` 的 Skill 工具记录，而不只是差异中出现了测试。
- 实现过程中反复运行类型检查和单个测试文件，接近结束时运行一次完整测试套件。
- 无需提醒继续，运行就完成了当前分支上的提交。
- 逐张工单使用时，差异只有一张工单的规模：贯穿各层的纵向切片，而不是混入多张工单。

## Where it fits

`implement` 是主流程中的实现步骤：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

相邻技能包括 [to-tickets](https://aihero.dev/skills-to-tickets)，它生成 `implement` 消费的工单，并声明决定执行顺序的阻塞关系；[tdd](https://aihero.dev/skills-tdd)，它在内部为每个接缝提供测试方法；以及 [code-review](https://aihero.dev/skills-code-review)，它在提交前运行。`implement` 位于规划技能之后，并信任它们。它不会重新验证输入的结构，因此，结构不佳的规划图或按横向层次拆分的工单，也会照原样实现。

正因如此，[wayfinder](https://aihero.dev/skills-wayfinder) 在 [to-spec](https://aihero.dev/skills-to-spec) 处接入主流程，而不是将规划图直接送入 `implement`。只有工作规模确实较小时，才从规划图直接转到 `implement`。

不确定自己处于哪条流程时，[ask-matt](https://aihero.dev/skills-ask-matt) 是整个技能集合的路由入口。
