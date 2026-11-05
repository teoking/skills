## What it does

`grilling`（需求澄清）通过逐轮访谈，在任何人采取行动之前检验计划、决策或想法，把问题组织为**设计树（design tree）**：每个决策都会分出依赖它的后续决策。访谈逐分支展开，直到没有未明说的假设。默认使用简体中文，用户可以指定其他语言；技能标识仍为 `grilling`。

它既不是每次只问一个问题，也不是一次问完所有问题。每轮只问**前沿（frontier）**中的问题，即前置决策都已明确的问题。它会询问整个前沿，然后等待回答；依赖本轮答案的问题留到下一轮。回答确定决策后，前沿向外推进，下一轮再询问新解锁的问题。十三个问题通常约分三轮，而非十三轮。前沿为空后，在你确认双方理解一致之前，它不应据此开始执行。

## When to reach for it

输入 `/grilling`，或由 [agent](https://www.aihero.dev/ai-coding-dictionary/agent) 在任务适合时自主调用。你可以说「帮我把需求问清楚」「挑战一下这个方案」或「通过提问找出遗漏」。它是访谈技能家族中唯一模型可调用的[技能](https://www.aihero.dev/ai-coding-dictionary/skill)，通常由你已手动启动的其他技能调用，不必经常直接输入它的名称。显式调用的语法由[宿主](https://www.aihero.dev/ai-coding-dictionary/harness)决定。

直接选择它得到纯访谈；需要更多功能时，按情况选择：

| 当前情况 | 选择 |
| --- | --- |
| 不在工作目录中 | [grill-me](https://aihero.dev/skills-grill-me)：相同的[会话](https://www.aihero.dev/ai-coding-dictionary/session)，但入口仅由用户启动 |
| 在工作目录中，希望同步记录术语和决策 | [grill-with-docs](https://aihero.dev/skills-grill-with-docs)：相同的会话，同时写入 `GLOSSARY.md` 和架构决策记录（ADR） |
| 工作规模大到单次会话无法容纳 | [wayfinder](https://aihero.dev/skills-wayfinder)：先绘制地图，再在决策[工单](https://www.aihero.dev/ai-coding-dictionary/ticket)中运行访谈 |
| 仅靠讨论无法确定外观或使用感受 | [prototype](https://aihero.dev/skills-prototype)：先构建可抛弃的版本，再回来讨论 |
| 自编技能需要访谈 | 让它通过 Skill 工具调用 `grilling`，而非另写一套访谈流程 |

`grill-me` 和 `grill-with-docs` 仍然只能由用户启动，中文描述不会改变其调用限制。

## 轮次、前沿与决策归属

设计树描述决策及其依赖；前沿包含前置决策均已确定的决策；一轮就是完整提出并完整回答一个前沿。

每个问题都有编号、标题和推荐答案，用 `❓` 和 `➡️` 分隔，相邻问题之间有水平线。措辞应使「是」表示接受推荐答案，可以按编号回答，例如「1 是，2 选第二项，3 否，原因是……」。格式有一个已知问题：推荐答案有时反对问题本身的措辞，导致接受推荐反而要回答「否」。遇到这种情况，应针对推荐答案作答，并明确说明。

事实由 agent 查询，决策由你作出。需要[环境](https://www.aihero.dev/ai-coding-dictionary/environment)事实时，技能要求派[子代理](https://www.aihero.dev/ai-coding-dictionary/subagent)调查；无依赖的问题继续提问，依赖调查结果的问题等待。agent 必须等待你的决策，自行回答决策问题就违反了技能要求。前沿为空表示访谈问题已处理完；在采取行动之前，agent 仍必须等待你确认双方理解一致。

前沿依靠[模型](https://www.aihero.dev/ai-coding-dictionary/model)判断，并非从图中计算得出，可能误把有依赖的两个问题放到一轮。此时只能明确指出依赖，在下一轮重新打开受影响的分支。

## 本页与包装入口的分工

本页解释访谈机制；包装技能的页面回答与使用场景有关的问题。

| 问题 | 说明页 |
| --- | --- |
| 设计树、前沿、轮次、问题格式、事实与决策的区别 | 本页 |
| 访谈应持续多久、仅靠讨论无法回答的问题怎么办、如何避免一味赞同 | [grill-me](https://aihero.dev/skills-grill-me) |
| `GLOSSARY.md` 写什么、什么应成为 ADR | [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |

本 fork 保留子代理流程与包装技能的 Skill 工具调用约定，没有实现 pi 或 ChatGPT 的宿主适配。缺少能力时应明确报告限制，不能把读取了文件当成完整流程已经验证。可先直接选择 `grilling` 验证访谈部分，再单独记录所需适配。中文显示名称不是中文命令别名。

## Common questions

**可以一次只问一个问题吗？**

可以，而且不少用户这样做。在全局 `CLAUDE.md` 中加入以下指令：

```
开展 grilling 访谈时，每次只问一个问题。
```

默认仍是每轮整个前沿，但并非人人都偏好这种方式。阅读较慢、使用第二语言，或借助顺序提问保持专注的用户反馈，一次一个问题更适合他们。这是受支持的选择，不是变通办法。

**`/batch-grill-me` 去哪里了？**

并入了本技能。按轮次提问曾短暂作为独立技能发布，随后移入 `grilling`，因此依赖它的 `grill-me`、`grill-with-docs`、`triage` 和 `wayfinder` 同时获得了这种方式。没有可安装的 `batch-grill-me`，也没有单独的顺序提问技能；上面的 `CLAUDE.md` 指令用于恢复一次一个问题。

**一轮问完，会不会漏掉先前回答本应引出的新问题？**

这是对轮次提问最常见的质疑，前沿就是对此的回答。一轮只包含彼此不依赖的问题，因此按此规则，同轮的回答不会使另一个问题失效。回答仍会改变后续问题，因为 agent 每次都重新确定下一轮前沿。它确实有损失，但远少于「一次问完所有问题」所暗示的程度；限制见上文对前沿判断的说明。

**它问完就开始写代码了，正常吗？**

不正常。前沿为空还不等于你已确认理解一致，这正是确认关卡要防止的问题。能力较弱或速度优先的模型仍可能跳过这一关。用户尤其在低推理投入或非前沿模型上报告了这种情况：模型把「持续访谈直到达成共同理解」简化为几个问题和一份提纲。你可以要求它先总结待确认的理解；可靠的修正是在自己的 `AGENTS.md` 或 `CLAUDE.md` 中明确要求未经许可不得实现。

**它没有问我，而是回答了自己的问题。**

这是本次运行的错误，也是正文区分事实与决策的原因。当另一个技能调用 `grilling` 来解决工单时尤其容易发生：agent 把该任务视为继续推进的许可。它不能把自己的推荐答案当成你的决策。同一限制也解释了为什么没有异步模式。有人请求过读取 GitHub 工单、发布一份集中决策备忘录的变体，但那应是另一个技能，因为无人回答的访谈产出的是 agent 的意见，而不是你的意见。

**可以限制问题数量吗？**

不能，固定上限被有意排除在范围之外。有的计划需要三个问题，有的需要五十个；固定上限要么截断复杂情况，要么在简单情况下显得任意。预期的控制方式是用自然语言要求结束，或停止并接受计划的当前状态。本次中文化没有加入「每轮最多三个问题」等新限制。访谈过长时，通常应缩小范围，分别讨论各部分。

**只安装 `grill-me` 就够了吗？**

不够。它是一个极短的包装技能，整个正文就是通过 Skill 工具调用 `grilling`，因此也需要安装 `grilling`；`grill-with-docs` 还依赖 [domain-modeling](https://aihero.dev/skills-domain-modeling)。安装整套技能可避免缺失依赖；选择性安装需要保留依赖。

**`grill-with-docs` 运行了，却没有加载 `grilling`。**

原文记录了这个尚未修复的问题，用户在多种宿主和模型上都报告过。仅提及另一个技能不一定可靠地使其加载，而 `grill-with-docs` 依赖两个技能。明显信号是一次问完所有问题、没有推荐答案，说明模型在即兴访谈，而非运行本技能。直接询问 agent 是否加载了 `grilling` 和 `domain-modeling`，通常可以恢复。它的规定仍是两次独立的 Skill 工具调用，每次一个技能。

## It's working if

- 每轮问题都有编号，推荐答案单独放在 `➡️` 行；你能按编号回答整轮。默认问题与推荐答案使用简体中文，用户指定其他语言时遵从用户。
- 本轮的问题无需猜测尚未回答的前置问题。
- 后续轮次会提出第一轮尚不能提出的问题。
- agent 自己查事实，包括读取文件、派子代理，而非询问自己能查到的内容；决策则等待你作出。
- 独立调查不会阻塞整轮，只有依赖调查结果的问题等待。
- 它最后总结理解并等待你的确认，而不是自行开始实现。
- 问题数量保持充分，轮次数量仍然较少。

## Where it fits

这是可复用的访谈基础技能，不是需要单独安排的链式步骤：访谈方法只有这一处权威来源，其他技能需要访谈时调用它，而非另造一套。[grill-me](https://aihero.dev/skills-grill-me) 和 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 是两个手动入口；后者是主交付链的起点，位于 [to-spec](https://aihero.dev/skills-to-spec) 之前。

[wayfinder](https://aihero.dev/skills-wayfinder) 用它解决决策工单，[triage](https://aihero.dev/skills-triage) 用它把模糊报告澄清到可处理，[improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 在你选定深化候选后用它遍历设计树。不确定从哪里开始时，手动选择 [ask-matt](https://aihero.dev/skills-ask-matt) 查看路线。
