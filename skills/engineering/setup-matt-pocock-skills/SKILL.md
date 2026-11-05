---
name: setup-matt-pocock-skills
description: "为本仓库配置工程技能所需的工单跟踪器、分诊标签词汇和领域文档布局。在首次使用其他工程技能前运行一次。"
disable-model-invocation: true
---

# 配置 Matt Pocock 技能

为每个仓库创建工程技能所依赖的配置框架：

- **工单跟踪器（issue tracker）**：工单存放在哪里（默认使用 GitHub，也内置支持本地 Markdown）。
- **分诊标签**：五种标准分诊角色所用的标签字符串。
- **领域文档**：`GLOSSARY.md` 和架构决策记录（ADR）存放在哪里，以及使用这些文档时的读取规则。

这是提示驱动的技能，不是确定性脚本。先探索，再展示发现，与用户确认后才写入。

本 fork 的输出偏好：默认用简体中文提问、解释和交付；用户指定其他语言时遵从用户。代码、命令、路径、工具名、技术标识以及约定的模板字段遵循目标项目约定。

## 流程

### 1. 探索

检查当前仓库，了解初始状态。读取已有内容，不要凭空假设：

- `git remote -v` 和 `.git/config`：这是 GitHub 仓库吗？具体是哪一个？
- 仓库根目录的 `AGENTS.md` 和 `CLAUDE.md`：是否有任一文件？其中是否已有 `## Agent skills` 章节？
- 仓库根目录的 `GLOSSARY.md` 和 `GLOSSARY-MAP.md`，以及旧版 `CONTEXT.md` / `CONTEXT-MAP.md`。若存在旧版文件，提议使用 `git mv` 将它改为对应的 `GLOSSARY` 文件名，并修改 `docs/agents/domain.md` 中引用的这些名称。
- `docs/adr/` 及所有 `src/*/docs/adr/` 目录。
- `docs/agents/`：是否已有本技能之前生成的文件？
- `.scratch/`：这说明可能已经在使用本地 Markdown 工单跟踪约定。
- 是否已安装 `triage` 技能？（本技能旁边有 `triage` 技能目录，或可用技能列表中有 `triage`。）这决定是否执行 B 部分。
- monorepo 的迹象：存在 `pnpm-workspace.yaml`、`package.json` 中有 `workspaces` 字段，或 `packages/*` 已有内容且包含自己的 `src/`。这些只会出现在真正的大型多包仓库中；没有这些迹象就采用 single-context，几乎所有仓库都属于这种情况。

### 2. 展示发现并提问

总结哪些内容已有、哪些仍缺失。然后依次处理各部分：完成一个部分，收到一个回答，再进入下一个部分。

每个部分先给出推荐答案，让用户用一个词就能接受。只有确实存在不同选择时，才给出一句解释；若探索已经确定了结论，就跳过该部分（未安装 `triage` 时跳过 B 部分，没有 monorepo 迹象时跳过 C 部分）。

**A 部分：工单跟踪器。**

> 解释：「工单跟踪器」是本仓库存放工单的地方。`to-tickets`、`triage` 和 `to-spec` 等技能会从中读取和写入内容。它们需要知道应该调用 `gh issue create`、在 `.scratch/` 下写入 Markdown 文件，还是遵循用户描述的其他流程。选择本仓库实际用于跟踪工作的地方。

默认立场：这些技能是为 GitHub 设计的。如果 `git remote` 指向 GitHub，就推荐 GitHub。如果 `git remote` 指向 GitLab（`gitlab.com` 或自托管主机），就推荐 GitLab。否则（或用户另有偏好时），提供以下选项：

- **GitHub**：工单存放在本仓库的 GitHub Issues 中（使用 `gh` CLI）。
- **GitLab**：工单存放在本仓库的 GitLab Issues 中（使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI）。
- **本地 Markdown**：工单以文件形式存放在本仓库的 `.scratch/<feature>/` 下（适合个人项目或没有远端的仓库）。
- **其他**（Jira、Linear 等）：请用户用一段话描述流程；本技能会将其记录为自由格式的说明文字。

将选择记录在 `docs/agents/issue-tracker.md` 中。GitHub 和 GitLab 模板包含 `PRs as a request surface`（将 PR 作为请求入口）标志，默认**关闭**。保持关闭，也不要主动询问：想把外部 PR 纳入分诊队列的用户，可以稍后在文件中修改该标志。

GitHub 或 GitLab 工单跟踪器需要一个可访问的仓库。若用户选择其中之一，而没有 `git remote` 指向相应主机，先向用户获取仓库 URL 并建立连接（必要时执行 `git init`，再执行 `git remote add origin <url>`），然后才能继续。在当前目录内运行 `gh repo view` / `glab repo view` 能显示该项目时才算完成；若不能，停止并告知用户还缺少什么。

**B 部分：分诊标签词汇。** 如果未安装 `triage` 技能（探索时已确认），就完全跳过本部分；未安装的技能不需要标签。

若已安装，只问一个问题：

> 是否保留默认分诊标签？（推荐：**是**）

默认值是五种标准角色，每个标签字符串与角色名称一致：`needs-triage`、`needs-info`、`ready-for-agent`、`ready-for-human`、`wontfix`。用户回答**是**时，原样写入。只有用户回答否时，才收集替代名称；通常是因为工单跟踪器已使用其他名称（例如用 `bug:triage` 表示 `needs-triage`），这样 `triage` 就会使用已有标签，而不是创建重复标签。

**C 部分：领域文档。** 默认采用 **single-context**（仓库根目录下的一个 `GLOSSARY.md` 加 `docs/adr/`）。这适合几乎所有仓库；无需提问，直接写入该布局。

只有探索发现 monorepo 迹象时，才提供 **multi-context**（根目录的 `GLOSSARY-MAP.md` 指向各上下文的 `GLOSSARY.md` 文件）选项。然后确认用户想采用哪种布局。

### 3. 确认并调整草稿

向用户展示以下草稿：

- 要添加到所编辑的 `CLAUDE.md` / `AGENTS.md` 中的 `## Agent skills` 区块（文件选择规则见第 4 步）。
- `docs/agents/issue-tracker.md`、`docs/agents/domain.md` 和 `docs/agents/triage-labels.md` 的内容（最后一个仅在已安装 `triage` 时提供）。

写入前，让用户有机会修改草稿。

### 4. 写入

**选择要编辑的文件：**

- 如果 `CLAUDE.md` 存在，就编辑它。
- 否则，如果 `AGENTS.md` 存在，就编辑它。
- 如果两者都不存在，询问用户要创建哪一个；不要代替用户选择。

已有 `CLAUDE.md` 时绝不创建 `AGENTS.md`，反之亦然；始终编辑已有的那个文件。

若所选文件中已有 `## Agent skills` 区块，就原位更新其内容，不要追加重复区块。不要覆盖用户对周围章节所做的修改。

区块如下：

```markdown
## Agent skills

### Issue tracker

[one-line summary of where issues are tracked]。参见 `docs/agents/issue-tracker.md`。

### Triage labels

[one-line summary of the label vocabulary]。参见 `docs/agents/triage-labels.md`。

### Domain docs

[one-line summary of layout: "single-context" or "multi-context"]。参见 `docs/agents/domain.md`。
```

只有已安装 `triage` 且执行了 B 部分时，才包含 `### Triage labels` 子区块并写入 `docs/agents/triage-labels.md`。未安装时，两者都省略。

若在 GitHub 或 GitLab 上执行了 B 部分，为工单跟踪器创建配置中所有缺失的标签（`gh label create` / `glab label create`）。

然后以本技能目录中的种子模板为起点，写入文档文件：

- [issue-tracker-github.md](./issue-tracker-github.md)：GitHub 工单跟踪器。
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md)：GitLab 工单跟踪器。
- [issue-tracker-local.md](./issue-tracker-local.md)：本地 Markdown 工单跟踪器。
- [triage-labels.md](./triage-labels.md)：标签映射（仅在已安装 `triage` 时使用）。
- [domain.md](./domain.md)：领域文档读取规则及布局。

对于「其他」工单跟踪器，根据用户描述从头编写 `docs/agents/issue-tracker.md`。

### 5. 完成

告知用户配置已完成，并说明哪些工程技能将读取这些文件。提醒用户以后可以直接编辑 `docs/agents/*.md`；只有想切换工单跟踪器或从头重新配置时，才需要重新运行本技能。
