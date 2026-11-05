## What it does

`retro` 回顾一次编码[会话](https://www.aihero.dev/ai-coding-dictionary/session)，建议如何改进 agent 的**[环境](https://www.aihero.dev/ai-coding-dictionary/environment)**，让下一次执行更顺利。它读取会话自身的记录，默认使用当前会话，也可指向会话日志中的某次会话；随后找出 agent 遇到困难的时刻，并按严重程度从高到低列出候选改进项。

改进对象是环境，不是代码。无论是 agent 交付的缺陷、用了 20 次[工具调用](https://www.aihero.dev/ai-coding-dictionary/tool-call)才找到的文件，还是审查者漏掉的规则，`retro` 都不会直接修复。它关注仓库环境中的哪些因素让问题得以发生，并建议用检查、指针或标准防止再次发生。它也只提出建议；在用户选择候选项之前，不作任何修改。

## When to reach for it

输入 `/retro` 主动调用，agent 不会自行调用。

在一次本不该如此困难的会话结束时使用，例如 agent 查找信息耗时过长、犯了工具本可捕获的错误，或需要却无法获取某条信息。顺利的会话可供学习的内容较少，发现通常来自困难的会话。若要评价会话产出的代码，改用 [code-review](https://aihero.dev/skills-code-review)。

## 改进建议放在哪里

每个候选项属于一个类别，类别决定建议的修复位置：

| 会话中出了什么问题 | 建议的修复方式 |
| --- | --- |
| agent 花了很长时间才找到文件或事实 | 从它已经读取的文件中添加**导航指针（navigation pointer）** |
| agent 犯了工具本可捕获的错误 | 添加**[自动检查](https://www.aihero.dev/ai-coding-dictionary/automated-check)**，例如 lint 规则、类型检查、测试、pre-commit 钩子或 CI 任务 |
| 审查者漏掉了需要判断的错误 | 在 `CODING_STANDARDS.md` 中添加供审查 agent 读取的规则 |
| `AGENTS.md` 或 `CLAUDE.md` 庞大 | 将引导指令移到编码标准或检查中 |
| 工具调用的成本相对于返回内容过高 | 精简工具，或替换工具 |
| 引导文件充满不改变行为的指令 | 删除**无效指令（no-ops）** |
| agent 需要无法访问的信息 | 扩大信息访问范围，例如将开发服务器日志同时写入文件，或提供服务的只读访问权限 |

核心概念是：编码标准由**审查者**执行，而不是实现者。实现 agent 的上下文压力最大，因为它要探索、编写代码和调试失败；审查 agent 以差异为输入，无须重新探索。因此，新规则应放在有余力应用它的审查阶段，而不是放入 [AGENTS.md](https://www.aihero.dev/ai-coding-dictionary/agents-md)；后者无论是否相关，都会加载到每次会话的[上下文窗口](https://www.aihero.dev/ai-coding-dictionary/context-window)。

形成规则建议前，`retro` 会先将违规分类。**机械性**违规，例如禁用 API、导入形式或文件位置规则，必须使用确定性检查，因为检查能报告失败，而标准文件中的一句话不能。只有 linter 无法强制执行、真正需要判断的事项，才写成文字规则。若仓库完全没有防护机制（guardrail），即既没有 pre-commit 钩子，也没有运行其 lint / typecheck / test 命令的 CI 任务，`retro` 会将这一点本身作为一项发现。

## Common questions

**它会直接写 lint 规则，还是等待同意？能让它在每次会话后自动运行吗？**

它会等待。`retro` 只提出建议，在用户选择候选项之前不作修改，因此不会自行编辑，也不会自动安装钩子。这是有意保留的边界。一位用户在经历「burned by auto-hooks that blocked good changes」后，明确要求这种行为。决定哪些事项值得成为永久检查需要判断，因此本技能保持[人工参与（human-in-the-loop）](https://www.aihero.dev/ai-coding-dictionary/human-in-the-loop)，且仅用户主动调用。有些用户确实在每次实现后运行它，但顺利会话可供学习的内容较少，每次都运行往往只会产生没人需要的规则。技能没有 dry-run 模式。建议中的检查也和其他代码一样，应先在仓库中试用，再让它阻止合并。

**lint 规则会不会越积越多？它会建议删除规则吗？**

只会处理其中一部分，这也是它最薄弱的地方。它可以建议删除文字指令，包括引导文件中的无效指令，以及 `AGENTS.md` 或 `CLAUDE.md` 中更适合放入标准或检查的引导指令。文件庞大时，它会将这些内容标为待删除项。它只根据读取的那一次会话判断，因此每项都应视为待检验的删除候选，而不是定论。它不会审计上个月建议的 lint 规则、钩子或 CI 任务。只看一次会话，无法判断规则是否已经过于频繁地触发，或背后的缺陷是否已经消失。仍需自行修剪检查；若某条规则不断对正确代码报错，就说明应删除它。

**它会不会为了填满类别而编造泛泛建议？**

这是对本技能最强烈的批评。一位用户发现：「once the job is finished, the AI tends to forget the struggles from the middle of the session and invents generic advice to satisfy the retro categories.」每个候选项都必须来自会话自身的记录，因此建议应针对那次会话。这既有收益，也有代价：它很少编造无关内容，但可能过分重视那一次会话所涉及的事情。无法追溯到具体时刻的候选项应丢弃。严重程度排序也应视为初稿，因为一个不显眼但代价高的错误，可能排在显眼却代价低的错误后面。

**会话很长，现在运行，还是新开会话？**

默认回顾当前会话。这是最理想的情况，因为遇到的困难仍在上下文窗口中。若会话已经离开[高效区（smart zone）](https://www.aihero.dev/ai-coding-dictionary/smart-zone)，可以[清空上下文](https://www.aihero.dev/ai-coding-dictionary/clearing)，再在新会话中调用 `/retro`，指向日志中的上一会话。

**agent 总犯同样的错误，应该在 `CLAUDE.md` 中加一行吗？**

通常不应该，`retro` 尤其会反对这种做法。`CLAUDE.md` 中的一行会加载到每次会话，稀释文件中其他内容的注意力权重，还会随代码变化而过时：

- **机械性错误。** 使用能报告失败的检查。
- **需要判断的错误。** 放入审查者读取的编码标准。

`AGENTS.md` 和 `CLAUDE.md` 主要用于导航指针，其他内容应尽量少放。出于同样原因，`retro` 不是[记忆系统](https://www.aihero.dev/ai-coding-dictionary/memory-system)：它不保存发生了什么，而是建议改进环境，防止错误再次发生。

**配置中提到了 `CODING_STANDARDS.md`，但仓库没有。它从哪里来？**

没有哪个技能自带此文件。会话首次发现适合审查者、需要判断的规则时，`retro` 会建议创建它。接受后，[code-review](https://aihero.dev/skills-code-review) 会读取该文件。已有的其他标准文档，例如 `CONTRIBUTING.md`，也同样适用。

**它与 `improve-codebase-architecture` 有什么不同？**

输入不同：[improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 只需要代码，寻找代码结构上的改进；`retro` 需要会话历史，改进的是 agent 工作的环境，而不是代码。两者可以一起使用，不能互相替代。

## It's working if

- 每个候选项都能追溯到会话中的具体时刻，而不是泛泛的最佳实践。
- 重复错误转化为能失败的检查，`AGENTS.md` 随时间变短，而不是变长。
- 若检查已经存在但尚未接入，建议是接入已有检查，而不是重新构建一套。
- 下一次同类任务会话能更快找到所需信息。

## Where it fits

`retro` 是主流程的最后一步，用来复盘这条流程执行得如何：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

在值得学习的一次实现结束后运行，可以留在同一会话，也可以指向那次会话的日志。顺利的实现可以跳过复盘。

- [code-review](https://aihero.dev/skills-code-review) 是 `retro` 最常提出调整建议的审查技能。新的编码标准放在其 Standards 轴会读取的位置。
- [writing-for-agents](https://aihero.dev/skills-writing-for-agents) 为 `retro` 建议修改的引导文件和技能提供写作风格指南，`retro` 会在开始前加载它。

不确定当前情况该选哪个技能时，[ask-matt](https://aihero.dev/skills-ask-matt) 可在整个技能集合中提供路由建议。
