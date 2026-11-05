## What it does

`setup-matt-pocock-skills` 回答一个仓库的三个问题：[工单](https://www.aihero.dev/ai-coding-dictionary/ticket)存放在哪里、分诊标签叫什么，以及领域文档放在哪里。它把答案记录为 `docs/agents/` 下的 Markdown 文件。

只有这些文件因仓库而异，技能本身在各处都相同。技能运行时会读取 `docs/agents/issue-tracker.md` 并遵循其中的说明。因此，这套技能不绑定 GitHub，也不需要修改技能文件来切换工单跟踪器。调用时提出「将技能连接到自定义工单跟踪器」，就可以使用任何能通过程序连接的跟踪器，无需修改技能。

这是提示驱动的技能，不是确定性脚本。它读取 `git remote`、`CLAUDE.md` 和 `GLOSSARY.md`，根据发现提出建议，等待用户确认后才写入任何内容。

## When to reach for it

输入 `/setup-matt-pocock-skills` 主动调用；[agent](https://www.aihero.dev/ai-coding-dictionary/agent) 不会自行调用。它的元数据有意禁止模型调用，因此其他技能也不能代为启动它。

每个仓库配置一次，在首次使用其他工程技能前调用。如果 [triage](https://aihero.dev/skills-triage)、[to-spec](https://aihero.dev/skills-to-spec)、[to-tickets](https://aihero.dev/skills-to-tickets) 或 [wayfinder](https://aihero.dev/skills-wayfinder) 开始猜测工单该放在哪里，或使用跟踪器中不存在的标签，就说明仓库尚未配置。也可以在项目进行到一半时运行；技能会读取已有内容，不会丢失之前的工作。

## Prerequisites

它写入当前运行所在的仓库：

| 写入内容 | 位置 |
| --- | --- |
| `issue-tracker.md` | `docs/agents/` |
| `domain.md` | `docs/agents/` |
| `triage-labels.md` | `docs/agents/`，仅在已安装 `triage` 技能时写入 |
| `## Agent skills` 区块 | 优先写入已有的 `CLAUDE.md`；否则写入已有的 `AGENTS.md`；若都不存在，询问用户创建哪一个 |

这些内容都以 Markdown 文件提交到仓库。没有用户级或全局模式；配置保存在仓库中，每个仓库都有自己的副本。

若选择 GitHub 或 GitLab，需要对应 CLI 能访问目标项目；技能会先验证项目可访问，无法验证时停止并说明缺失条件。

## 三项决策

每个部分先给出推荐答案；探索已经回答的问题会跳过。大多数运行只需确认两次。

| 决策 | 建议内容 | 何时提问 |
| --- | --- | --- |
| **工单跟踪器** | 与 `git remote` 匹配的跟踪器 | 始终提问，因为这是实际需要选择的事项 |
| **分诊标签** | 保留五个标准名称（`needs-triage`、`needs-info`、`ready-for-agent`、`ready-for-human`、`wontfix`） | 仅在已安装 `triage` 技能时提问 |
| **领域文档** | single-context：根目录的一个 `GLOSSARY.md` 加 `docs/adr/` | 仅在发现 monorepo 迹象时提问，此时会提供 multi-context 的 `GLOSSARY-MAP.md` 选项 |

工单跟踪器选项：

| 选项 | 工单存放位置 | 所需条件 |
| --- | --- | --- |
| **GitHub** | 本仓库的 GitHub Issues | `gh` CLI |
| **GitLab** | 本仓库的 GitLab Issues | `glab` CLI |
| **本地 Markdown** | 本仓库 `.scratch/<feature>/` 下的文件 | 无，甚至不需要远端 |
| **其他** | 用户指定的位置 | 用户用一段话描述流程 |

前三项都有随技能提供的模板，可直接使用。本地 Markdown 是完整选项，不是回退方案；技能支持没有远端的个人项目。但如果使用 GitHub，就不要使用本地 Markdown：它们是替代关系，只选一种。

「其他」也是完整选项，Jira、Linear、Azure DevOps 和 Beads 都通过它接入。用户描述流程，技能将说明文字记录在 `docs/agents/issue-tracker.md` 中，下游技能按说明执行。已有用户实现了基于 [MCP](https://www.aihero.dev/ai-coding-dictionary/mcp) 的 Jira 变体、形式类似 `gh` 的 Gitea CLI，以及手工搭建的本地看板。

## Common questions

**必须使用 GitHub 吗？**

不必。GitHub、GitLab 和 `.scratch/` 下的本地 Markdown 都有现成模板，其他跟踪器走「其他」路径即可。这是被问得最多的问题，常见原话包括：*"hard locked to github"*、*"can I use GitLab / Jira"*、*"what about Azure DevOps"*。答案始终相同：由配置选择跟踪器，而不是由技能固定。

**更新技能后，需要重新运行配置吗？**

v1.1 之后对此的直接答复是需要。技能自己的结束提示则较为宽松：只在切换跟踪器或从头重新配置时才需要再运行。这两种说法都有理由。种子模板会随版本变化，因此旧版本生成的 `docs/agents/issue-tracker.md` 可能与现在读取它的技能不再一致。如果下游技能的行为与文档描述不同，重新运行配置即可，成本很低。

**它写入了 `CLAUDE.md`，但我使用的是 Codex。**

这是一个已知且尚未解决的缺口。文件选择规则是「如果 `CLAUDE.md` 存在就编辑它，否则编辑 `AGENTS.md`」。它检查的是文件是否存在，而不是当前运行的[宿主](https://www.aihero.dev/ai-coding-dictionary/harness)。如果仓库留有 Claude Code 的 `CLAUDE.md`，技能就会把 `## Agent skills` 区块写入 Codex 不会读取的文件。用户有两种绕过方法：

- 手动把区块移到 `AGENTS.md`。
- 以 `AGENTS.md` 为权威文件，让 `CLAUDE.md` 只保留一行指向它的说明。

如果两个文件都不存在，技能会询问要创建哪一个，而不是自行选择。这曾让期待技能自行决定的用户感到困惑。

**它没有创建我的分诊标签。**

标签文件与标签创建是两件事。`docs/agents/triage-labels.md` 是一张*映射表*，告诉 `/triage` 跟踪器中的哪些字符串对应五种标准角色。按技能正文的要求，已安装 `triage`、完成 B 部分且选择 GitHub 或 GitLab 时，配置还会通过 `gh label create` / `glab label create` 创建所有配置中缺失的标签；未安装 `triage` 时，标签配置和标签文件都会省略。在全新的 GitHub 仓库中，标签可能尚不存在；用户不止一次将标签缺失报告为缺陷。需要区分以下情况：

- 如果跟踪器已使用标准名称，映射表就是同名映射，无需配置替代名称。这是预期的常见情况，不是遗漏步骤；若某个配置的标签尚不存在，仍应按上述条件创建。
- 本技能也不负责创建 [wayfinder](https://aihero.dev/skills-wayfinder) 的 `wayfinder:map` 和 `wayfinder:<type>` 标签。`gh issue create --label <missing>` 会失败，而不会创建标签。在 GitHub 仓库中首次运行 wayfinder 前，需手动创建这些标签。

**能在这里配置其他技能的行为吗（[grilling](https://www.aihero.dev/ai-coding-dictionary/grilling) 的节奏、问题格式、语气）？**

不能。它只配置三项内容：跟踪器、标签和文档布局。用户曾希望将这里作为个人偏好的配置入口，但技能保留自身明确的行为取舍，不接受个人配置。偏好应作为普通指令写入 `CLAUDE.md`；所有技能都会读取这些指令。

**能把配置放在 `~/.claude` 中，而不是提交到每个仓库吗？**

目前不能。一位在多个仓库使用这些技能的用户对此提出了请求，该请求仍未关闭，但当前没有用户级模式。每个仓库都保存自己的 `docs/agents/`。

**用一个技能配置其他技能，不奇怪吗？**

一项长期存在的质疑认为确实如此，原话是：*"having a skill to set up the other skill does not feel right to me: that means the LLM is configuring its own skills."* 这个取舍确实存在。没有配置步骤，每个操作工单的技能都需要保存一份跟踪器指令。输出是可阅读、可编辑的 Markdown，这限制了风险。可以逐一阅读生成的文件并手动修改。日常调整应直接编辑文件，而不是再运行一次配置。

## It's working if

- `docs/agents/issue-tracker.md` 和 `docs/agents/domain.md` 已存在；如果已安装 `triage`，还应有 `triage-labels.md`。
- 宿主读取的指令文件中出现 `## Agent skills` 章节，每个配置文件都有一行摘要和指向它的引用。
- 推荐的跟踪器与使用的远端一致，标签字符串与跟踪器中已有的标签一致。
- 此后，`/to-tickets` 发布时不再询问工单存放在哪里，`/triage` 会使用标签而不是自创标签。
- 技能文件本身没有变化。如果配置过程编辑了 `SKILL.md`，就说明出了问题。

## Where it fits

`setup-matt-pocock-skills` 是工程流程的**首次配置**，是其他步骤默认已经满足的前置条件，而不是流程链中的一步。与它相邻的是读取配置的技能：

- [triage](https://aihero.dev/skills-triage) 使用这里记录的标签词汇。
- [to-spec](https://aihero.dev/skills-to-spec) 和 [to-tickets](https://aihero.dev/skills-to-tickets) 向这里指定的跟踪器发布内容。
- [wayfinder](https://aihero.dev/skills-wayfinder) 读取同一个跟踪器文件的「Wayfinding operations」章节，了解如何存放地图和子工单。

[domain-modeling](https://aihero.dev/skills-domain-modeling) 随后按配置记录的布局填充领域文档。它只在术语或决策确定时创建 `GLOSSARY.md` 和架构决策记录（ADR），因此配置完成后仓库仍没有领域文档是正常情况。要判断下一步使用哪个技能，可通过 [ask-matt](https://aihero.dev/skills-ask-matt) 查看整套技能的路由。
