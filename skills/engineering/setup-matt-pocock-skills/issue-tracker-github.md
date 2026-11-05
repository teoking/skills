# Issue tracker: GitHub

本仓库的工单和规格说明（spec）存放为 GitHub 工单。所有操作均使用 `gh` CLI。

## Conventions

- **创建工单**：`gh issue create --title "..." --body "..."`。多行正文使用 heredoc。
- **读取工单**：`gh issue view <number> --json number,title,body,labels,comments`。
- **列出工单**：`gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'`，配合适当的 `--label` 和 `--state` 筛选条件。
- **将工单设为父工单的子工单**：使用 `gh issue create --parent <parent> ...`，或之后执行 `gh issue edit <parent> --add-sub-issue <child>`（`gh` 2.94+）。旧版 `gh` 使用 `gh api --method POST repos/<owner>/<repo>/issues/<parent>/sub_issues -F sub_issue_id=<child-db-id>`（使用数据库 ID，见下方**阻塞关系**）。若不支持子工单，在子工单正文顶部写入 `Part of #<parent>`。
- **阻塞关系（blocking edges）**：使用 GitHub 的**原生工单依赖**，这是标准的、可在界面中看到的表示方式。通过 `gh issue create --blocked-by <n>,<n> ...` 或 `gh issue edit <child> --add-blocked-by <blocker>` 添加关系（`gh` 2.94+）。旧版 `gh` 使用 `gh api --method POST repos/<owner>/<repo>/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-db-id>`，其中 `<blocker-db-id>` 是阻塞工单的数字**数据库 ID**（通过 `gh api repos/<owner>/<repo>/issues/<n> --jq .id` 获取，_不是_ `#number` 或 `node_id`）。若依赖功能不可用，则退回到在子工单正文顶部写一行 `Blocked by: #<n>, #<n>`。所有阻塞工单都关闭后，该工单才解除阻塞。
- **统计未关闭的阻塞工单**：`gh api repos/<owner>/<repo>/issues/<n> --jq .issue_dependencies_summary.blocked_by`（只统计未关闭的阻塞工单；0 表示可开始）。`gh issue view <n> --json blockedBy` 也会列出已关闭的阻塞工单，因此需要筛选：`--jq '[.blockedBy.nodes[] | select(.state == "OPEN")] | length'`。
- **评论工单**：`gh issue comment <number> --body "..."`。
- **添加 / 移除标签**：`gh issue edit <number> --add-label "..."` / `--remove-label "..."`。
- **关闭**：先用 `gh issue comment <number> --body "..."` 发布说明，再执行 `gh issue close <number>`。对于已关闭的工单，`gh issue close --comment` 会丢弃评论，但仍以退出码 0 结束。

根据 `git remote -v` 推断仓库；在克隆目录内运行时，`gh` 会自动完成这项判断。

只在用户自己的仓库中提交工单。除非用户拥有 `mattpocock/skills`（这些技能的来源仓库），否则绝不向其中提交工单。在 fork 中，`gh` 可能默认指向上游父仓库，因此每次会话首次执行 `gh issue create` 前，都要用 `gh repo view --json nameWithOwner` 检查目标；若不是用户的仓库，先向用户确认。

## Pull requests as a triage surface

**PRs as a request surface: no.** _（如果本仓库把外部 PR 当作功能请求，将其设为 `yes`；`/triage` 会读取此标志。）_

设为 `yes` 时，PR 使用与工单相同的标签和状态，操作改用对应的 `gh pr` 命令：

- **读取 PR**：先执行 `gh pr view <number>`，再执行 `gh pr view <number> --comments`（不在 TTY 中运行时，`--comments` 只输出评论，不输出正文）；差异使用 `gh pr diff <number>`。
- **列出待分诊的外部 PR**：`gh api --paginate 'repos/{owner}/{repo}/pulls?state=open' --jq '.[] | select(.author_association | IN("OWNER","MEMBER","COLLABORATOR") | not) | {number, title, author: .user.login, author_association, labels: [.labels[].name]}'`。
- **评论 / 添加或移除标签 / 关闭**：`gh pr comment`、`gh pr edit --add-label`/`--remove-label`、`gh pr close`。

GitHub 的工单和 PR 共用同一编号空间，因此单独的 `#42` 可能是任一种：先用 `gh pr view 42` 解析，不成功则改用 `gh issue view 42`。

## When a skill says "publish to the issue tracker"

创建一个 GitHub 工单。

## When a skill says "fetch the relevant ticket"

按上方**读取工单**的约定读取。

## Wayfinding operations

供 `/wayfinder` 使用。**地图**是一个工单，每项工作对应一个**子工单**。

- **地图**：一个带有 `wayfinder:map` 标签的工单，正文包含 Notes / Decisions-so-far / Fog。使用 `gh issue create --label wayfinder:map`。
- **子工单**：通过 GitHub 子工单关系关联到地图的工单（见**将工单设为父工单的子工单**）。若未启用子工单，在地图正文的任务列表中添加子工单，并在子工单正文顶部写入 `Part of #<map>`。标签为 `wayfinder:<type>`（`research`/`prototype`/`grilling`/`task`）。领取后，将工单指派给负责推进的开发者。
- **阻塞关系**：见 Conventions 中的**阻塞关系**。
- **前沿（frontier）查询**：前沿是阻塞工单均已完成的可执行工单集合。列出地图下未关闭的子工单（`gh issue list --state open`，范围限定为地图的子工单 / 任务列表），排除仍有未关闭阻塞工单的项（见**统计未关闭的阻塞工单**，或检查 `Blocked by` 行中是否有未关闭工单），也排除已有受理人的项；选择地图顺序中的第一项。
- **领取**：`gh issue edit <n> --add-assignee @me`，这是会话的第一次写入操作。
- **解决**：执行 `gh issue comment <n> --body "<answer>"`，再执行 `gh issue close <n>`，然后向地图的 Decisions-so-far 追加上下文指针（context pointer，摘要加链接）。
