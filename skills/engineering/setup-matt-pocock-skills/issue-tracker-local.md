# Issue tracker: Local Markdown

本仓库的工单和规格说明（spec）以 Markdown 文件形式存放在 `.scratch/` 中。

## Conventions

- 每个功能使用一个目录：`.scratch/<feature-slug>/`。
- 规格说明位于 `.scratch/<feature-slug>/spec.md`。
- 实现工单按每个工单一个文件存放在 `.scratch/<feature-slug>/issues/<NN>-<slug>.md`，从 `01` 开始编号，绝不合并成一个工单文件。
- 分诊状态记录在每个工单文件靠近顶部的 `Status:` 行中（角色字符串见 `triage-labels.md`）。
- 评论和对话历史追加到文件底部的 `## Comments` 标题下。

## When a skill says "publish to the issue tracker"

在 `.scratch/<feature-slug>/` 下创建新文件（必要时创建目录）。

## When a skill says "fetch the relevant ticket"

读取所引用路径上的文件。用户通常会直接提供路径或工单编号。

## Wayfinding operations

供 `/wayfinder` 使用。**地图**是一个文件，每个工单各有一个**子文件**。

- **地图**：`.scratch/<effort>/map.md`（正文包含 Notes / Decisions-so-far / Fog）。
- **子工单**：`.scratch/<effort>/issues/NN-<slug>.md`，从 `01` 开始编号，正文写明问题。`Type:` 行记录工单类型（`research`/`prototype`/`grilling`/`task`）；`Status:` 行记录 `claimed`/`resolved`。
- **阻塞关系（blocking edges）**：在靠近顶部的位置写一行 `Blocked by: NN, NN`。该行列出的每个文件都为 `resolved` 时，工单才解除阻塞。
- **前沿（frontier）**：前沿是阻塞工单均已完成的可执行工单集合。扫描 `.scratch/<effort>/issues/`，寻找未完成、未被阻塞且未领取的文件；选择编号最小的一项。
- **领取**：在开展任何工作前，设置 `Status: claimed` 并保存。
- **解决**：在 `## Answer` 标题下追加答案，设置 `Status: resolved`，然后向 `map.md` 中地图的 Decisions-so-far 追加上下文指针（context pointer，摘要加链接）。
