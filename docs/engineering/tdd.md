## What it does

`tdd` 以先写测试的方式构建功能或修复缺陷：先写一个失败测试，再只写足以使它通过的代码，然后处理下一个行为。它提供让循环产出值得保留的测试的标准：什么是好测试、测试应放在哪里、mock 的用途，以及会使测试套件失去价值的三种反模式。

它不会在未事先约定的接缝（seam）处编写测试。任何测试出现之前，它都要列出拟测试的公开边界，并停下来等待确认。测试投入有限，这一步将投入用于关键路径，而不是每个边缘情况。`tdd` 也是**参考**，而非流程驱动器。它包含循环规则，由用户或 [implement](https://aihero.dev/skills-implement) 等其他入口驱动应用这些规则的[会话](https://www.aihero.dev/ai-coding-dictionary/session)。

## When to reach for it

可以输入 `/tdd`，也可以由 [agent](https://www.aihero.dev/ai-coding-dictionary/agent) 在任务适合时自主调用：先写测试再构建功能或修复缺陷、需要集成测试，或提到「red-green-refactor」时。

当有具体行为要实现，具有输入和可观察的输出，并希望测试能够经受重构时，使用它。

| 当前情况 | 应使用 |
| --- | --- |
| 行为具有明确输入和输出，例如业务逻辑、请求／响应契约、转换或验证 | `tdd` |
| 行为尚未确定 | [to-spec](https://aihero.dev/skills-to-spec)，它还会在编写代码之前约定测试接缝 |
| 问题实际上是接口形态，而不是测试 | [codebase-design](https://aihero.dev/skills-codebase-design) |
| 已有[规格说明](https://www.aihero.dev/ai-coding-dictionary/spec) 或[工单](https://www.aihero.dev/ai-coding-dictionary/ticket)，希望代为完成实现流程 | [implement](https://aihero.dev/skills-implement)，它逐张工单使用 `tdd` |
| 配置、连接、胶水代码、类型注解或直接的 CRUD 委托 | 这里没有特别适合的选择，见下方尚未解决的缺口 |

最后一行确实是个缺口。技能决定接缝*放在哪里*，但没有规则决定某次修改*是否值得*进入这个循环。如果修改没有可用于断言的独立事实来源，运行它就会得到重复实现逻辑的测试。这是从另一个方向落入技能所警示的同义反复反模式。该问题记录为[工单 #746](https://github.com/mattpocock/skills/issues/746)，在本次内容基线中仍未关闭。在解决之前，需要自行判断，或将规则写入项目的 `CLAUDE.md`。

## Prerequisites

需要安装 [codebase-design](https://aihero.dev/skills-codebase-design)。`tdd` 曾自带深模块（deep module）和接口设计笔记，v1.0 删除了这些内容，改用共享技能；现在 `tdd` 使用它的接口设计术语。没有其他专属前置要求：这个技能是[无状态的](https://www.aihero.dev/ai-coding-dictionary/stateless)，没有自身专属的文件产物。

## 循环及其测试接缝

这个技能建立在三个术语之上。

**红灯／绿灯（red/green）。**先写失败测试，再只写足以使它通过的代码。不要为后续测试预先编写代码。循环没有重构阶段。该技能在 2026 年 6 月移除了重构阶段，因为 agent 几乎不执行它，而且将审查与实现放在独立会话中效果更好。重构属于 [code-review](https://aihero.dev/skills-code-review)。

**纵向切片（vertical slice）。**在一个接缝处写一个测试，再写最小实现，然后重复。第一轮是一枚**曳光弹（tracer bullet）**，端到端证明一条路径可行。相反的方式是横向切片：先写所有测试，再写所有代码。批量编写的测试验证的是*想象中的*行为，关注事物的形态，而非用户的行为，还会在理解实现之前就锁定测试结构。

**事先约定的接缝。**接缝是无需深入内部就能观察行为的公开边界。这条规则没有例外：未确认的接缝处不得编写测试。在完整流程中，接缝会更早在 [to-spec](https://aihero.dev/skills-to-spec) 阶段约定，原有说明为：「`/tdd` is told to only work at pre-agreed test seams, `/code-review` checks that only agreed-upon test seams were used.」即 `tdd` 只在事先约定的测试接缝处工作，`code-review` 检查是否只使用了约定接缝。单独调用时，`tdd` 直接向用户确认。

它要防止的三种反模式：

| 反模式 | 典型信号 |
| --- | --- |
| 与实现耦合 | 重命名内部函数时测试失败，但行为并未改变；mock 内部协作者、断言调用次数，或查询数据库来验证，而不是通过接口验证。 |
| 同义反复 | 以与代码相同的方式计算期望值，因此测试在构造上必然通过。期望值必须来自别处：已知正确的字面量、完整推导的示例或规格说明。 |
| 横向切片 | 任何实现出现之前，先加入了一批测试。 |

mock 只用于系统边界：外部 API、时间、随机性，有时也用于文件系统或数据库；数据库优先使用测试数据库。绝不 mock 自己的模块。

## Common questions

**为什么不重构？描述里写的是「red-green-refactor」。**

因为重构步骤已经移除，但描述中的触发短语没有移除。这是有意删除的：agent 几乎不执行重构步骤，而且将实现与审查放到独立会话中效果更好。结果是否仍符合教科书中的 TDD 定义，不如循环是否产出更好的代码重要。触发短语与正文不一致的问题记录为[工单 #589](https://github.com/mattpocock/skills/issues/589)，在本次内容基线中仍未关闭。因此，「red-green-refactor」仍是可触发技能的短语；实际得到的是红灯／绿灯循环，重构由 [code-review](https://aihero.dev/skills-code-review) 承担。

**它让我选择测试接缝，但我不知道该选哪个。**

这是该技能最常被报告的使用阻力（[工单 #607](https://github.com/mattpocock/skills/issues/607)）。此前的提示只列候选接缝名称，没有说明各自能捕获或遗漏什么，用户只能在标签之间选择。当前 `SKILL.md` 已要求为每个提议的接缝提供一行说明，写明能捕获什么、会遗漏什么。如果实际运行仍只列名称，应在回答前要求 agent 说明取舍，例如组件级接缝会遗漏哪些集成接缝能捕获的问题，以及后者会慢多少。这也是流程提前在 `to-spec` 中约定接缝的原因：那时能看到整个功能，而不只是一个提示。

**技能要求先红灯，它却先写实现，再写测试。**

这种情况会发生。一名用户追问[模型](https://www.aihero.dev/ai-coding-dictionary/model)，得到了少见的坦诚回答：「I knew the skill said 'one test at a time, watch it fail for the right reason'. I read it. I just defaulted to my normal habit.」指令无法保证 agent 每次都 100% 遵从；更严厉的措辞也可能限制创造性，却只带来有限收益。既有使用经验认为，即使偶尔偏离，循环仍值得运行，因为整体结果更好。这不改变技能的「先红灯，后绿灯」要求。如果某个切片必须严格遵守，应观察实际运行，而不是相信技能本身能强制执行。

**应该先写浏览器测试或端到端测试吗？**

通常不应该，但技能不会阻止。一名用户报告过，agent 先编写 Playwright 测试，然后长时间反复运行；功能尚不存在，它却得出*测试*有问题的结论。浏览器测试足够慢时，红灯／绿灯反馈循环就不再划算。可以在项目的 `CLAUDE.md` 中明确：行为实现可用之后，再编写浏览器测试。

**`/tdd` 能替代 `/implement`，或课程中的 `/do-work` 吗？**

不能。`/tdd` 记录方法；`/implement` 是简单的工作 → 反馈 → 提交循环，直接对应 `/do-work`。课程中的单个 `/do-work` 步骤现在拆到了 `/implement`、`/tdd` 和 `/code-review` 中。如果问题是针对工单该运行哪个技能，答案几乎总是 `/implement`。

**深模块和接口设计指南去了哪里？**

v1.0 将它们移入 [codebase-design](https://aihero.dev/skills-codebase-design)，并将内容通用化，让多个技能共享同一套术语。`refactoring.md` 同时移除；重构现在由 [code-review](https://aihero.dev/skills-code-review) 负责，该技能包含 Fowler 代码坏味道基线。

**它知道我的其他工单吗？**

不知道。针对单张工单运行时，它可能提出属于其他工单的工作，因为看不到完整工单图（[工单 #129](https://github.com/mattpocock/skills/issues/129)）。这不是 `tdd` 的职责。将规格说明与工单一起提供会有帮助；一开始就合理划分工单，帮助更大。

## It's working if

- 任何测试文件出现之前，它先列出拟测试的接缝及其能捕获和遗漏的内容，然后停下来等待确认。
- 一个测试出现、亮红灯、获得足以使它通过的代码，然后下一个测试才出现；不是先出现一批测试，再出现一批代码。
- 测试名称描述能力（`user can checkout with valid cart`），而非内部实现（`checkout calls paymentService.process`）。
- 断言中的期望值是可追溯到规格说明的字面量，而不是以与代码相同的方式重新计算的值。
- 重命名内部函数不会导致测试套件失败。
- mock 只出现在外部边界，例如支付 API 或时钟，绝不包裹自己的模块。

## Where it fits

`tdd` 在主流程的实现步骤内部使用，不是独立的流程步骤：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

[to-spec](https://aihero.dev/skills-to-spec) 提前约定测试接缝，[implement](https://aihero.dev/skills-implement) 逐张工单使用 `tdd`；[code-review](https://aihero.dev/skills-code-review) 在事后检查是否只使用约定接缝，并负责 `tdd` 不再执行的重构。另一个相邻技能是 [codebase-design](https://aihero.dev/skills-codebase-design)，它是 `tdd` 使用的接缝和深模块术语的共享来源。有具体行为要实现、但没有完整规格说明时，也可以单独使用 `tdd`。不确定哪个技能适合当前情况时，由 [ask-matt](https://aihero.dev/skills-ask-matt) 提供路由。
