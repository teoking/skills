## What it does

`code-review` 从两个轴审查 `HEAD` 与指定固定基点之间的差异。基点可以是提交、分支、标签、`main` 或 `HEAD~5`。**Standards（编码标准）**检查代码是否遵循仓库的编码方式，**Spec（规格说明）**检查代码是否实现了来源工单或[规格说明](https://www.aihero.dev/ai-coding-dictionary/spec)的要求。每个轴都在独立的[子代理](https://www.aihero.dev/ai-coding-dictionary/subagent)中执行，彼此看不到对方的推理。

本技能绝不合并两个轴，也不跨轴重新排序。报告以*各轴内部*最严重的问题结束，不跨轴选出一个最严重的问题。变更可以通过一个轴，却未通过另一个：遵循所有约定但实现了错误内容的代码，会通过 Standards，却无法通过 Spec；完全实现[工单](https://www.aihero.dev/ai-coding-dictionary/ticket)要求但违反仓库约定的代码则相反。混合结论会让通过的轴掩盖未通过的轴。

## When to reach for it

输入 `/code-review` 主动调用；当请求审查分支、PR、进行中的工作，或「自 X 以来」的变更时，agent 也可以自动调用。

| 当前情况 | 选择 |
| --- | --- |
| 已有差异，想知道是否*实现得正确*，以及是否*实现了正确的内容* | `code-review` |
| 想查找差异中的缺陷，例如空值路径、竞态或差一错误 | Claude Code 自带的审查，而不是本技能，见下文的名称冲突说明 |
| 尚未编写代码，希望先写测试再实现 | [tdd](https://aihero.dev/skills-tdd) |
| 需要实现整份规格说明，并包含审查 | [implement](https://aihero.dev/skills-implement)，它会调用本技能 |
| 整个代码库的架构已经偏移，而不只是某次差异 | [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) |
| 某处出了故障，但原因不明 | [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs) |

必须提供固定基点。若未提供，技能会询问，而不是猜测。派出任何子代理之前，它会检查引用能否解析、差异是否非空。因此，分支名输入错误会直接暴露，而不是进入两个子代理后才失败。

## Prerequisites

Standards 轴不要求事先准备标准文件。它会读取仓库已有文档，例如 `CODING_STANDARDS.md`、`CONTRIBUTING.md`，即使仓库没有相关文档，内置基线也仍然适用。

Spec 轴需要存在且能找到的规格说明。来源按以下优先顺序确定：

1. 提交消息中的工单引用，例如 `#123`、`Closes #45` 或 GitLab `!67`，通过工单跟踪器文档获取。
2. 通过参数传入的路径。
3. `docs/`、`specs/` 或 `.scratch/` 中与分支名或功能名匹配的规格说明文件。
4. 询问用户。

通过工单引用获取内容依赖工单跟踪器文档，该文档由 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 生成。若尚未提供工单跟踪器信息，技能会提示用户运行 `/setup-matt-pocock-skills`；直接提供文件路径则不需要通过跟踪器获取规格说明。若完全没有规格说明，技能会跳过 Spec 子代理，报告「没有可用的规格说明」，而不是编造需求。

## 两个审查轴

| | Standards（编码标准） | Spec（规格说明） |
| --- | --- | --- |
| 问题 | 是否实现得正确？ | 是否实现了正确的内容？ |
| 读取 | 仓库文档中的标准，加上代码异味基线 | 来源工单或规格说明 |
| 报告 | 违反文档标准的事项（可以是硬性违规），以及异味（始终需要判断） | 缺失或部分实现的需求、范围蔓延、实现错误的需求 |
| 每项发现引用 | 标准文件及规则，或异味名称及差异片段 | 规格说明中的对应行 |

这种设计避免了通用审查技能不了解项目标准的问题。通用技能会把代码库中有意为之的做法当作问题，却漏掉代码库依赖的不变量。因此，仓库自身的文档是 Standards 轴的[一手资料](https://www.aihero.dev/ai-coding-dictionary/primary-source)，且**仓库标准始终优先**。

**代码异味基线（smell baseline）**的优先级低于仓库标准，包含 Fowler《Refactoring》第 3 章中的十二种异味：Mysterious Name（含糊命名）、Duplicated Code（重复代码）、Feature Envy（依恋其他对象的数据）、Data Clumps（数据泥团）、Primitive Obsession（基本类型偏执）、Repeated Switches（重复的条件分支）、Shotgun Surgery（霰弹式修改）、Divergent Change（发散式变化）、Speculative Generality（臆测的通用性）、Message Chains（消息链）、Middle Man（中间人）、Refused Bequest（拒绝继承的馈赠）。每一种都是带名称的启发式判断，例如「可能存在 Feature Envy」，绝不是硬性违规。每种异味都说明了是什么以及如何修复，因此发现会附带修复方向，而不只是指出问题。Standards 轴会跳过 linter 已经强制检查的事项。本地化基线中的英文说明页曾将这条规则表述为适用于两个轴，但技能正文只在 Standards 提示词中明确规定，未对 Spec 作同一要求；不能据此保证 Spec 也会跳过。

## Common questions

**它与 Claude Code 自带的 `/code-review` 冲突，怎么办？**

这是本技能被报告最多的问题，尚未修复。Claude Code 自带的 `/code-review` 用途不同：它查找差异中的缺陷，本技能则检查规格说明符合性和仓库标准。安装本技能库后，其中一个会占据入口，具体取决于安装方式：

- **插件 marketplace 安装。** 每个技能都有 `mattpocock-skills:` 前缀，而自带技能会难以通过不带前缀的名称访问。
- **普通技能安装。** 本地文件优先，本技能会遮蔽自带技能。

这种遮蔽现象可以说是 Claude Code [宿主](https://www.aihero.dev/ai-coding-dictionary/harness)的问题，因为技能作者应当可以自由命名技能。处理方式有两种：

- **完全移除 Claude Code 自带的技能。** 这能节省大量[上下文](https://www.aihero.dev/ai-coding-dictionary/context)，名称冲突也就不再重要。
- **重命名本地副本。** `npx skills update` 会撤销对前置元数据的修改或目录重命名。用户报告的持久解决办法是将技能 fork 为新名称，并从受管理集合中移除 `code-review`。记录 fork 所依据的提交，以便手动同步。

**子代理不断再次调用 `/code-review`，并派出更多 agent。**

这是已知且尚未解决的缺陷。多人在不止一种宿主中复现过。Standards 和 Spec 提示词没有禁止委派，因此子代理可能再次发现本技能，并再次派出子代理。有报告称 agent 数量超过 50。有人在 fork 中采用的修复是在两个子代理的任务说明末尾各加一句：「Do not invoke `/code-review` or spawn additional agents: perform this review directly.」也有人倾向于在宿主层处理，让所有技能都继承这一防护。当前发布的技能尚未采用这两种办法。若无人值守运行，应留意 agent 数量。

**应该在编写代码的同一个会话中运行吗？**

更推荐新建[会话](https://www.aihero.dev/ai-coding-dictionary/session)。一位读者的说法是：「Same context reviewing itself isn't review, it's confirmation bias with a slash command.」在编写代码的会话中审查，agent 的上下文保留着所有影响实现的假设，独立审查者则不会有这些上下文。这也是有人希望 [implement](https://aihero.dev/skills-implement) 不包含内置审查步骤的原因，因为该步骤在刚刚生成差异的会话内执行。独立审查的方式是在干净会话中自行调用 `/code-review`。

**每个工单后审查，还是最后统一审查？**

两种方式都可行，技能不会代为决定：

- **逐工单审查。** 每次差异较小，Spec 轴有一份明确的规格说明可供核对；`implement` 使用这种方式。
- **在分支末尾统一审查。** 可以发现逐工单审查各自遗漏的工单间交互问题。

若不确定，先逐工单审查，最后再以分支起点为基点进行一次审查。

**发现的问题可信吗？**

不能未经核对就相信。子代理输出是假设，不是证据。有团队报告了 12 处基于文字的审查未发现的破坏性变更。技能会原样汇总两份报告，或仅作轻微整理，不会逐项回到文件中验证。因此，发现可能引用错误位置，或夸大影响。采取行动前，读取每项发现的引用。技能要求每项发现都附带引用：标准规则、异味及其差异片段，或规格说明中的对应行；这些引用让发现可以核查。

**为什么每次运行都会发现新问题？**

每次修复都会增加待审查的新代码，而 Standards 轴中需要判断的部分在不同运行中会产生不同结果。一位读者描述了这样的循环：「/code-review and /improve-code-architecture always find new stuff every time. I implement fixes, rerun these skills, and again and again.」技能不保证收敛。将一次审查视为线索清单，处理那些有规则引用支持的事项，然后停止。不要循环运行，直到报告完全干净，因为它不会达到这种状态。

**会审查尚未提交的工作吗？**

不会。它比较的是 `<fixed-point>...HEAD`。三个点的形式从合并基点开始计算，不包含暂存区和工作区的变更。若 `implement` 尚未生成中间提交，审查就看不到即将进入下一次提交的工作。先提交，再审查，然后修改提交或补充修复提交。

## It's working if

- 无效引用或空差异会在派出任何子代理之前阻止流程启动。
- 报告在 `## Standards` 和 `## Spec` 下分别呈现，而不是合并成一张清单。
- 每项 Standards 发现都指出仓库文件中的规则，或十二种异味之一，并引用相关差异片段；每项 Spec 发现都引用规格说明中的对应行。
- 结尾摘要给出各轴内部最严重的问题，不跨轴选出一个最严重的问题。
- 没有规格说明时，Spec 部分会明确说明，而不是列出从代码推测的需求。

## Where it fits

`code-review` 是构建链靠近末尾的审查步骤：`grill-with-docs → to-spec → to-tickets → implement → code-review → retro`。也可独立用于指定的任何分支或 PR。

- [implement](https://aihero.dev/skills-implement) 是最紧密的相邻技能：它负责实现，并在提交前调用本技能进行收尾审查。[implement-spec](https://aihero.dev/skills-implement-spec) 则对整个集成分支执行一次同样的审查。
- [retro](https://aihero.dev/skills-retro) 随后复盘并提出调整建议。如果会话表明审查漏掉了某类错误，`retro` 会建议增加检查或 `CODING_STANDARDS.md` 规则，供 Standards 轴读取。
- [pr](https://aihero.dev/skills-pr) 在经过审查的工作准备提交 PR 时编写正文。
- [to-spec](https://aihero.dev/skills-to-spec) 和 [to-tickets](https://aihero.dev/skills-to-tickets) 生成 Spec 轴用来核对的文档，因此规格说明含糊时，该轴的结论也会含糊。
- [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 面向整个代码库，与本技能只检查一次差异相对应。

不确定当前情况该选哪个技能时，[ask-matt](https://aihero.dev/skills-ask-matt) 可在整个技能集合中提供路由建议。
