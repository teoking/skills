# Issue tracker: GitLab

本仓库的工单和规格说明（spec）存放为 GitLab 工单。所有操作均使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI。

## Conventions

- **创建工单**：`glab issue create --title "..." --description "..."`。多行描述使用 heredoc。传入 `--description -` 可打开编辑器。
- **读取工单**：`glab issue view <number> --comments`。使用 `-F json` 获取机器可读输出。
- **列出工单**：`glab issue list -O json`，配合适当的 `--label` 筛选条件。
- **评论工单**：`glab issue note <number> --message "..."`。GitLab 将评论称为「notes」。
- **添加 / 移除标签**：`glab issue update <number> --label "..."` / `--unlabel "..."`。多个标签可以用逗号分隔，也可以重复传入标志。
- **关闭**：`glab issue close <number>`。`glab issue close` 不接受关闭评论，因此先用 `glab issue note <number> --message "..."` 发布说明，再关闭工单。
- **合并请求**：GitLab 将 PR 称为「merge requests」。使用 `glab mr create`、`glab mr view`、`glab mr note` 等命令，其形式与 `gh pr ...` 相同，但用 `mr` 替代 `pr`，用 `note`/`--message` 替代 `comment`/`--body`。

根据 `git remote -v` 推断仓库；在克隆目录内运行时，`glab` 会自动完成这项判断。

## Merge requests as a triage surface

**MRs as a request surface: no.** _（如果本仓库把外部合并请求当作功能请求，将其设为 `yes`；`/triage` 会读取此标志。）_

设为 `yes` 时，MR 使用与工单相同的标签和状态，操作改用对应的 `glab mr` 命令：

- **读取 MR**：`glab mr view <number> --comments`；差异使用 `glab mr diff <number>`。
- **列出待分诊的外部 MR**：执行 `glab mr list -O json`，然后只保留作者不是项目成员或所有者的 MR（即贡献者的 MR，而不是维护者正在进行的工作）。
- **评论 / 添加或移除标签 / 关闭**：`glab mr note`、`glab mr update --label`/`--unlabel`、`glab mr close`。

与 GitHub 不同，GitLab 分别为工单和 MR 编号，因此只要知道维护者指的是哪一种入口，`#42` 就没有歧义。

## When a skill says "publish to the issue tracker"

创建一个 GitLab 工单。

## When a skill says "fetch the relevant ticket"

运行 `glab issue view <number> --comments`。

## Wayfinding operations

供 `/wayfinder` 使用。**地图**是一个工单，每项工作对应一个**子工单**。

- **地图**：一个带有 `wayfinder:map` 标签的工单，正文包含 Notes / Decisions-so-far / Fog。使用 `glab issue create --label wayfinder:map`。（在提供原生 epic 的 GitLab 套餐中，也可以用 epic 存放地图；带标签的工单适用于所有套餐。）
- **子工单**：在描述顶部写入 `Part of #<map>`，关联到地图（`glab issue create --linked-issues <map> --link-type relates_to`），并带有 `wayfinder:<type>` 标签（`research`/`prototype`/`grilling`/`task`）。领取后，将工单指派给负责推进的开发者。
- **阻塞关系（blocking edges）**：使用 GitLab 的**原生阻塞链接**，这是标准的、可在界面中看到的表示方式。将 `/blocked_by #<n>` 快捷操作作为评论发布，以添加关系（`glab issue note <child> --message "/blocked_by #<blocker>"`）。原生阻塞链接是 Premium/Ultimate 套餐的功能；在免费套餐中（或该功能不可用时），退回到在描述顶部写一行 `Blocked by: #<n>, #<n>`。所有阻塞工单都关闭后，该工单才解除阻塞。
- **前沿（frontier）查询**：前沿是阻塞工单均已完成的可执行工单集合。使用 `glab api projects/:id/issues/<map>/links` 列出地图的子工单，保留带有 `wayfinder:<type>` 标签且未关闭的工单；排除仍有未关闭阻塞工单的项：原生 `blocked_by` 链接指向未关闭的工单（`glab api projects/:id/issues/<child-iid>/links`），或 `Blocked by` 行中有未关闭工单；也排除已有受理人的项。选择地图顺序中的第一项。
- **领取**：`glab issue update <n> --assignee @me`，这是会话的第一次写入操作。
- **解决**：执行 `glab issue note <n> --message "<answer>"`，再执行 `glab issue close <n>`，然后向地图的 Decisions-so-far 追加上下文指针（context pointer，摘要加链接）。
