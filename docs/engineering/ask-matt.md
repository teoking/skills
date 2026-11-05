## What it does

`ask-matt` 是本仓库技能的路由入口。描述当前情况，例如有想法却不知如何开始、收到一堆缺陷报告，或某个[会话](https://www.aihero.dev/ai-coding-dictionary/session)持续太久，它就会指出适合的技能或技能序列，以及其中哪些位置需要人工决策。

它推荐后就停止，不开展访谈、不编写[规格说明](https://www.aihero.dev/ai-coding-dictionary/spec)，也不启动刚刚提到的技能。交付的是下一步该输入什么，由用户亲自输入。它会先读取目标技能的 `SKILL.md`，再说明该技能的行为或建议跳过某一步；这不等于执行目标技能的业务流程。它也是本仓库技能的手工地图，不会扫描已安装的技能，因此不会把用户自写或从其他作者处安装的技能纳入路由。

## When to reach for it

输入 `/ask-matt` 主动调用；agent 不会自行调用它。

| 当前情况 | 路由返回什么 |
| --- | --- |
| 有想法，却不知从哪里开始 | 主流程入口，以及工作是否小到可以跳过规格说明 |
| 收到其他人提交的缺陷和请求 | [triage](https://aihero.dev/skills-triage) 接入路径，以及为什么自己生成的[工单](https://www.aihero.dev/ai-coding-dictionary/ticket)不应走分诊路径 |
| 两项技能看起来可以互换 | 两者的边界，通常由一个具体判断条件决定，而非个人喜好。选择 [grill-me](https://aihero.dev/skills-grill-me) 还是 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，看是否在工作目录中；选择 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 还是 [wayfinder](https://aihero.dev/skills-wayfinder)，看工作能否在一个会话中容纳 |
| 会话很长，需要决定如何处理[上下文](https://www.aihero.dev/ai-coding-dictionary/context) | 阶段边界五种选择的有序决策树 |
| 已经选好技能 | 没有额外帮助，直接调用那项技能即可 |

## Prerequisites

路由会指出技能，但不安装技能。它推荐的技能必须已经安装，建议才能执行；它只了解本仓库中正式推广的技能。

依赖工单跟踪器的路径（`triage`、`to-spec`、`to-tickets`、`implement`）假定 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 已经在仓库中配置好工单跟踪器。即使配置尚未完成，路由也会推荐这些路径。

## 关注流程，而非单项技能

这个技能的引导词是**流程（flow）**：一条*穿过*多项技能的路径，而不是单项技能。描述情况后，路由会把工作定位到流程中的某一步。这不同于「这里有一项匹配关键词的技能」。共有五类路径，技能正文对它们有完整说明：

- **主流程**，从想法到交付。访谈、规格说明、工单、实现（逐张处理工单，或用 [implement-spec](https://aihero.dev/skills-implement-spec) 并行处理整个任务图）、审查，最后用 [retro](https://aihero.dev/skills-retro) 把实现过程中学到的内容反馈到 agent 的环境中。主流程有两个分支：如果某个问题必须由可运行代码来回答，就绕行原型；如果实现跨越多个会话，才值得承担拆成规格说明和工单的成本。
- **接入路径**，从某种情况产生工作，再汇入主流程：收到缺陷报告、某处故障，或工作方向太模糊、规模太大，一个会话容纳不下。
- **代码库健康**，维护而非功能开发。[improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 调查代码中的深化机会，每个机会都可以作为新想法重新进入主流程。
- **独立技能**，不属于任何流程，可单独使用：原型、问卷、研究。
- **底层词汇层**，当问题出在用词而非流程时，其他技能会调用的两项参考技能。

## 阶段边界

另一个关键概念是**阶段边界**。阶段是会话中的一段工作，例如[访谈](https://www.aihero.dev/ai-coding-dictionary/grilling)、实现或 QA；两个阶段之间的边界，是唯一适合回答「如何处理这份上下文」的位置。阶段中途不需要做这个决策：继续，或把剩余工作拆给[子代理](https://www.aihero.dev/ai-coding-dictionary/subagent)。

| 选择 | 何时采用 |
| --- | --- |
| **继续** | 下一阶段需要原样保留当前阶段的内容，或[智能区](https://www.aihero.dev/ai-coding-dictionary/smart-zone)还有足够空间（当前最先进模型约为 150k tokens）。只有这个选择能把会话保留为[一手资料](https://www.aihero.dev/ai-coding-dictionary/primary-source)，所以先判断能否继续，排除后再考虑其他选择 |
| **`/clear`** | 之前的内容都可以丢弃。成本最低；原会话仍可恢复，但如果误清了相关上下文，仅靠重读差异无法恢复背后的原因 |
| **[handoff](https://aihero.dev/skills-handoff)** | 有内容需要转移：切换到新[宿主](https://www.aihero.dev/ai-coding-dictionary/harness)、进入新目录、交给同事，或在阶段中途分出旁支任务 |
| **子代理** | 任务范围足够明确，用户可以[离开键盘](https://www.aihero.dev/ai-coding-dictionary/afk)，无须持续引导 |
| **`/compact`** | 以上均不适用。它是默认选择，决策树经常落到这里 |

其中两个选项经常被误解，所以路由给出的是顺序，而不仅是列表：

- `/handoff` 看起来像在[上下文窗口](https://www.aihero.dev/ai-coding-dictionary/context-window)之间转移工作的通用方法，其实不是。它提供的只是可移植性。
- `/compact` 位于决策树末尾，而非首位，因为前四种选择都成本更低或更精确。

## Common questions

**没有一份按正确顺序排列的技能列表吗？**

一直有人希望 README 中提供这样的列表。这个技能就是那份列表。如果静态表写成 `wayfinder → to-spec → to-tickets → implement → code-review → retro`，对大多数情况都会错。重要的是分支：是否有代码库、实现是否跨会话、问题能否靠对话解决。代价是路由靠人工维护，因此会落后于仓库。`/grilling` 发布很久后，路由才提到它。

**它告诉我，一半技能都没安装。**

这是已知且尚未修复的问题。路由经过的大多数技能设置了 `disable-model-invocation: true`，因此宿主不会把它们放进注入 agent 上下文的技能列表。agent 把这个列表误当成完整清单，便报告这些技能缺失。在一个已有报告的会话中，它宣称整个规格说明和工单流程都不存在，改走不带包装入口的 `/grilling` 和 `/tdd`。既有问题记录中，插件的 27 项技能有 16 项带这个标记，因此这是常见情况，而非边缘情况。这些技能其实已经安装。仍可输入斜杠命令，或检查 `.claude-plugin/plugin.json`，它才是已包含技能的权威清单。

**它描述的技能行为，实际技能并没有。**

这也是已有报告中真实且尚未修复的执行问题：路由依据自己的一行摘要回答，而不是读取目标技能。一份详细报告记录了同一会话中的三次实例，其中一次只依据「把讨论转成规格说明」这句摘要，就建议跳过 [to-spec](https://aihero.dev/skills-to-spec)。路由从未打开 `to-spec/SKILL.md`。每次都等到用户反驳后才核实，没有主动核实。那次跳过 `to-spec` 漏掉了实际的接缝检查，随后生成的工单低估了工作量。当前 `SKILL.md` 已要求：说明目标技能的行为或建议跳步前，必须先读取该技能的 `SKILL.md`。如果执行中没有这样做，应要求它先打开文件。地图完全未覆盖的问题也一样，例如是否使用[计划模式](https://www.aihero.dev/ai-coding-dictionary/agent-mode)：这种回答是[模型](https://www.aihero.dev/ai-coding-dictionary/model)的推断，而非这里记录的规则。

**为什么写成叙述，而不是编号清单？**

这个意见有道理。一张尚未关闭的工单认为，大部分路由是确定性的，叙述形式让人难以扫读。可以要求压缩形式：「只给我顺序」就会得到技能序列。叙述承载的是条件：分支、需要人工决策的位置，以及步骤之间何时清空或压缩上下文。扁平清单恰好会丢掉这些信息。

**它能为我自己的技能或其他作者的技能做路由吗？**

不能。已有三个独立提案希望路由读取本地 `skills/` 目录，再从所有已安装技能中推荐。`ask-matt` 不是这种工具。它是某一组技能的手工地图，不了解用户自写或从其他来源安装的技能。

**它让我修改 SKILL.md。**

这个建议往往正确，但修改很难保留。有人问如何让 [implement](https://aihero.dev/skills-implement) 关闭工单，得到的建议是在技能中加一行，马上就发现了问题：`npx skills update` 会覆盖该文件，而插件安装内容是只读的。把长期行为约定写进自己的 `CLAUDE.md` 或 `AGENTS.md`，或在调用时说明。提示中的改动不会被更新覆盖。已有用户通过这种方式让流程面向 Linear 而非 GitHub，或询问哪些未关闭工单可以并行处理。

**它提到了我没有的技能，或漏掉了我已有的技能。**

先检查变更日志中是否有重命名，再判断技能是否消失：

- `writing-great-skills` 改名为 [writing-for-agents](https://aihero.dev/skills-writing-for-agents)，没有别名。
- `to-prd` 改名为 [to-spec](https://aihero.dev/skills-to-spec)。
- `pathfinder` 改名为 [wayfinder](https://aihero.dev/skills-wayfinder)。
- `ubiquitous-language`、`design-an-interface`、`qa` 和 `request-refactor-plan` 四项技能已停用，能力并入其他技能。

如果它漏掉已安装的技能，就是前面提到的路由维护滞后。

## It's working if

- 最后指出该输入什么，就此停止，而不是自行开始业务工作。
- 推荐的路径说明哪里应清空或压缩上下文、哪里需要用户审查，而不只是列出技能名。
- 两项技能相近时，指出该选哪项，以及另一项为什么不适合当前情况。
- 每条关于其他技能行为的断言，都能在执行记录中看到先读取该技能 `SKILL.md` 的过程。
- 返回的建议能对应当前实际情况，而不是最接近的泛化场景。

## Where it fits

[ask-matt](https://aihero.dev/skills-ask-matt) 是覆盖整组技能的**独立路由**，从来不是链条中的一步。它指向每条链，其他说明页链接回这里，因此不必各自重画全图。通常从这里进入 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，也就是主流程入口；或进入 [triage](https://aihero.dev/skills-triage)，也就是处理外部送入工作、而非自己发起工作的接入路径。

它是所描述技能的[二手资料](https://www.aihero.dev/ai-coding-dictionary/secondary-source)。路由与某份 `SKILL.md` 不一致时，以 `SKILL.md` 为准。
