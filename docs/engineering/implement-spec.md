## What it does

`implement-spec` 接收一份[规格说明](https://www.aihero.dev/ai-coding-dictionary/spec) 及其[工单](https://www.aihero.dev/ai-coding-dictionary/ticket)，在一次运行中完成整份实现。负责协调的 [agent](https://www.aihero.dev/ai-coding-dictionary/agent) 将每张工单交给独立 git worktree 中的[实现子代理](https://www.aihero.dev/ai-coding-dictionary/subagent)，将完成的分支合入一个**集成分支（integration branch）**，对结果运行 [code-review](https://aihero.dev/skills-code-review)，并按跟踪器的方式结束工作。

它将工单视为**任务图（task graph）**，而非列表。阻塞关系决定哪些工单可以开始，因此任一时刻都有一个**前沿（frontier）**：阻塞工单均已完成的可执行工单集合。在本次实现中，阻塞工单的工作合入集成分支后，后续工单即可进入前沿；前沿上的工单尽可能并发运行。这与逐张处理工单不同。决定节奏的是任务图的结构，而非工单在跟踪器上的排列顺序。

## When to reach for it

需要输入 `/implement-spec` 主动调用，agent 不会自行调用它，其他技能也不能代为调用。

| 当前情况 | 应使用 |
| --- | --- |
| 规格说明已拆成带阻塞关系的工单，希望在一次运行中完成 | `/implement-spec` |
| 希望在自己的[上下文窗口](https://www.aihero.dev/ai-coding-dictionary/context-window) 中每次处理一张工单，并在工单之间[清空上下文](https://www.aihero.dev/ai-coding-dictionary/clearing) | [implement](https://aihero.dev/skills-implement) |
| 规格说明尚未拆成工单 | 先使用 [to-tickets](https://aihero.dev/skills-to-tickets) |
| 规模较小，没有实质性的任务图 | 直接使用 [implement](https://aihero.dev/skills-implement) |

## Prerequisites

- **工单跟踪器。**技能从 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 配置的跟踪器读取工单，并在其中结束工作。如果尚未提供跟踪器，它会要求用户先运行配置技能，而不是猜测。
- **带阻塞关系的工单**，如 [to-tickets](https://aihero.dev/skills-to-tickets) 的产出。没有阻塞关系时，任务图就是平的，所有工单都会同时开始。
- **支持子代理和独立 git worktree 的[宿主](https://www.aihero.dev/ai-coding-dictionary/harness)。**在可行时，技能让实现子代理在后台运行。这项技能是为并发处理工单而设计的；如果宿主只能逐个运行子代理，就失去了相对于逐张运行 `implement` 的并发优势。

## 集成分支

所有工作都合入一个分支。每个实现子代理的 worktree 必须基于集成分支；如果不是，则在开始前重置到该分支。实现使用 [tdd](https://aihero.dev/skills-tdd)，每轮完成一个红灯／绿灯（red/green）切片。报告完成前，再将集成分支的最新提交合入自己的分支，以减少分支偏离；这并不保证后续合并一定能够快进，也不保证没有冲突。

是否创建拉取请求，由跟踪器的结束方式和用户要求决定：

| 条件 | 运行的结束方式 |
| --- | --- |
| 跟踪器通过 PR 结束工作，或用户要求 PR | 首次合并后创建草稿 PR，标记它将关闭规格说明和工单；结束时将 PR 标记为可供审查，工单的实际关闭仍取决于跟踪器后续的 PR 流程 |
| 不满足上述条件 | 按跟踪器的结束方式解决每张工单，并报告集成分支；使用本地 Markdown 跟踪器时可以完全离线完成 |

实现子代理通过[上下文指针](https://www.aihero.dev/ai-coding-dictionary/context-pointer) 与协调者沟通，指向规格说明、工单、共享探索笔记和先前提交，而不是粘贴摘要。这使每个子代理的提示保持精简，也让协调者的窗口有空间容纳任务图。

## Common questions

**与自行逐张工单运行 `/implement` 有什么不同？**

这正是该技能要解决的问题。在它发布之前，用户不断编写自己的版本。一名用户表达的需求是「subagents implement the tickets」，而不是「to individually create new session and tell them to implement a ticket one by one, when a spec may contain over 5 tickets.」也就是让子代理实现工单，省去对可能超过 5 张工单的规格说明逐张创建会话、派发工作的操作。使用 `implement` 时，用户是调度者：每张工单一个[会话](https://www.aihero.dev/ai-coding-dictionary/session)，会话之间清空上下文，并自行跟踪哪些工单已解除阻塞。`implement-spec` 将这个任务交给一个协调会话。代价是不会在每张工单完成时逐一查看，而是在最后审查集成分支。开始时，清空上下文，输入 `/implement-spec` 并附上指向规格说明的指针（工单编号或文件路径）。如果修改很小，没有实质性的任务图，直接使用 `implement`。

**必须使用 GitHub 吗？我希望只做到集成分支。**

现在不必了。一名喜欢测试版的用户提出过这样的意见：「it creates a PR at the end, which requires an online repository like GitHub. I wish it could do the same work offline and stop at the branch where all the work is merged.」也就是希望离线完成同样的工作，停在汇总所有修改的分支，而不是必须在 GitHub 等在线仓库上创建 PR。现在，工作会汇总到集成分支。只有已配置跟踪器通过 PR 结束工作，或用户要求时，才会创建 PR。因此，使用本地 Markdown 跟踪器时，运行以所有工单解决、所有工作合入集成分支结束。

**审查和修复循环持续了几个小时，或不断「修复」尚未实现的工单。**

在技能规定的时机之外运行 `code-review`，会导致这两种情况。它将代码与整份规格说明比较，所以只有所有工单都已合入后，审查才有意义。如果在实现中途运行，每张尚未实现的工单都会被当作失败。agent 随后实现该工单，又触发新一轮审查。技能在最后运行一次 `code-review`，将所有发现交给一个修复子代理，但尚未明确修复之后何时停止。一名用户报告过一个包含 5 张工单的功能：「the review and fix loop took roughly four hours」。如果看到第二次全面审查开始，可以要求它针对已修复的问题进行聚焦检查，然后停止。这是使用建议，不是技能正文已有的停止条件。应预期第一次审查会发现真实问题；实现产出仍是需要通过审查完善的草稿，不应直接发布。

**它会像 implement 一样使用 tdd 吗？**

现在会，但最初不会。使用测试版的用户发现「the implementer subagents don't inherit the /tdd directive」，即实现子代理不会继承 `/tdd` 指令，因此从单张工单扩展到整份规格说明时，红灯／绿灯循环就中断了。现在，每个实现子代理都使用 `tdd` 实现工单。不过，协调流程仍没有像 `implement` 会话那样与用户交互约定接缝的步骤，而 `tdd` 本身仍禁止在未确认的接缝处编写测试。因此，应在规格说明或工单中明确约定测试接缝。

**两个并行实现子代理修改了同一个文件，或给同一个概念起了不同名称。**

worktree 不会消除冲突，只是将冲突推迟到合并时。根据工单文字写出的阻塞关系，是对各工单可能修改哪些文件的推测；两张涉及「代码库不同部分」的工单，仍可能共享消息目录、配置注册表或类型。每个实现子代理只看到自己的工单和共享笔记，看不到另一方正在进行的工作。因此，一名用户的 Web 和移动端工单为同一个字符串分别使用了 `blockedSince` 和 `blockedOn`。当前沿上的两张工单会修改同一个共享文件时，可以采用以下方式：

- 增加阻塞关系，使两张工单顺序执行。
- 在探索笔记中明确每张工单新增对象的确切名称。

**阻塞工单已经合入，但被阻塞的工单始终不启动。**

这是 GitHub 上的已知问题。跟踪器的 blocked-by 计数只有在阻塞工单*关闭*时才会减少，而工单通常要等 PR 合并才关闭，也就是整个运行结束时。跟踪器适合提供初始任务图，但在运行中会滞后。可以要求协调者自行跟踪哪些工单已经合入集成分支，并据此计算前沿。

**它能替代 Sandcastle 或 AFK 脚本吗？**

不能。随着技能开始承担实现工作，有用户问过：「is Sandcastle still relevant? Your skills now seem to be able to handle implementation as well.」`implement-spec` 让 agent 在一个宿主会话中负责协调，无需额外基础设施，并允许用户观察和引导。对于真正的 [AFK](https://www.aihero.dev/ai-coding-dictionary/afk) 工作，确定性循环（[Sandcastle](https://github.com/mattpocock/sandcastle)、shell 脚本或 CI 任务）更快、更便宜，也更可靠，因为协调决策不由 agent 作出。

**工单的关键测试在 worktree 中被跳过，却报告绿灯。**

worktree 只包含 git 跟踪的内容。读取被 git 忽略的测试夹具、本地数据库或凭据的测试，在那里可能悄悄跳过。如果工单的验证依赖未跟踪的内容，应要求协调者在主检出目录中运行该验证。

## It's working if

- 任务图和宿主允许时，多个实现子代理同时运行，而不是逐个执行。
- 一张工单的最后一个阻塞工单合入集成分支后，它就开始执行，而不是等到整个运行结束。
- 每张工单的执行记录都显示 `tdd` 正在运行，失败测试先于实现代码出现。
- 实现子代理报告完成前，已将集成分支的最新提交合入自己的分支；后续合并如有冲突，会明确暴露，而不是混入错误结果。
- 所有工作汇总在一个分支上；无需 PR 时，各工单按跟踪器规则解决；需要 PR 时，草稿 PR 在最后变为可供审查。

## Where it fits

`implement-spec` 是主流程中的实现步骤，是逐张工单运行 [implement](https://aihero.dev/skills-implement) 的并行替代方式：

```txt
grill-with-docs → to-spec → to-tickets → implement-spec → retro
```

相邻技能是 [to-tickets](https://aihero.dev/skills-to-tickets)，它声明阻塞关系，供 `implement-spec` 读取为任务图；以及 [code-review](https://aihero.dev/skills-code-review)，它在结束前审查集成分支。不确定自己处于哪条流程时，[ask-matt](https://aihero.dev/skills-ask-matt) 是整个技能集合的路由入口。
