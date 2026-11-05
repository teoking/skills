## What it does

`pr` 定义 PR 正文的结构：用 **Summary** 展示变更，用 **Evidence** 证明变更有效，用 **Merge Danger** 判断合并风险。它是格式参考，不是工作流程；不会推送分支、创建 PR，或决定 PR 包含什么内容，只告诉 [agent](https://www.aihero.dev/ai-coding-dictionary/agent) 编写正文时应采用什么结构。

摘要是可视化视图，而不是一段文字。默认的 PR 正文用文字描述差异，本技能则选择能讲清关键点的**最小视图**，例如伪代码、调用树、组件树、文件树、Mermaid 图或适合主题的差异展示，并让周围文字保持简短。审查者已经打开了差异，正文应让他们在细读前先看清变更的结构。

## When to reach for it

输入 `/pr` 主动调用；agent 编写 PR 正文时也可以自动调用。

| 当前情况 | 选择 |
| --- | --- |
| 分支已准备好，需要一份便于审查者扫读的正文 | `pr` |
| 代码已写好，但尚未审查 | 先用 [code-review](https://aihero.dev/skills-code-review)，再用 `pr` |
| PR 已创建，开始收到审查评论 | 当前技能集合尚无对应技能；`pr` 只编写正文 |

## 模板结构

包含三个章节，顺序如下：

- **Summary**：一个或多个小型可视化视图，每个都放在它所支持的简短文字旁边。通常使用一个，有时几个，很少全部使用。只保留审查者需要的调用、文件、props 和边界。
- **Evidence**：展示前后对比。当变更是视觉变化，且[环境](https://www.aihero.dev/ai-coding-dictionary/environment)具备截图能力时，截图是最强证据。否则，用伪代码展示同一个测试在变更前失败、变更后通过的情况，或展示发生变化的控制台输出。
- **Merge Danger**：说明变更是**单向门（one-way door）**还是**双向门（two-way door）**，以及它的**影响范围（blast radius）**。双向门容易逆转；单向门则不容易，例如破坏性迁移、移除公开 API 或难以逆转的决策。影响范围指出变更出错时哪些地方可能受损，例如布局偏移、API 使用方或移动端响应式布局。

判断是哪种门是本技能的核心概念。它把「是否可以安全合并」从直觉变成明确陈述，让审查者能够提出异议，也告诉他们应在哪里投入[人工审查](https://www.aihero.dev/ai-coding-dictionary/human-review)精力：

- **影响范围小的双向门：** 可以快速浏览。
- **单向门：** 应仔细阅读。

## Common questions

**能相信 agent 自己对单向门或双向门的判断吗？**

不能盲信，这正是把判断写出来的意义。编写变更的 agent 也在给自己的变更评级，因此当它声称「双向门、影响范围小」时，尤其要怀疑。差异也常常无法体现变更是否可逆。一位用户说过：「rolling back a commit won't unsend a batch of emails」。通过功能开关控制的发布，也只有在首次按新格式写入之前才保持可逆。技能给 agent 的是定义，即破坏性操作和难以逆转的决策属于单向门，而不是检查清单，因此 Merge Danger 一项最值得仔细核对。两件事有帮助：

- 确保 agent 看到的是[工单](https://www.aihero.dev/ai-coding-dictionary/ticket)或[规格说明](https://www.aihero.dev/ai-coding-dictionary/spec)，而不只是差异。
- 把仓库中始终视为单向门的变更，例如 schema 迁移、任何向外发送或删除内容的操作，记录在 agent 做判断前会读取的位置。

**它会代为创建 PR 吗？**

不会。`pr` 只负责正文。相关技能的边界如下：

- [implement](https://aihero.dev/skills-implement) 以提交到当前分支结束。创建 PR 的技能或选项，例如 `/to-pr`，或让 `implement` 创建 PR 而不是提交，仍是尚未实现的提议。一位用户的解决办法是在本地用一句话覆盖 `implement` 的要求，让它创建 PR。
- [implement-spec](https://aihero.dev/skills-implement-spec) 是例外：当工单跟踪器通过 PR 完成工作，或用户要求创建 PR 时，它会创建草稿 PR。

因为 `pr` 可由模型调用，当用户要求 agent 创建 PR 时，agent 会用本技能的结构编写正文；创建动作本身不属于 `pr`。

**会不会又生成一大堆文字和图？**

本技能就是为避免这种情况设计的，但仍可能发生。用户对 agent 编写的 PR 正文有一致的抱怨：「a long summary but all I need to know is what changed, how it was verified, what could break, and whether it's safe to merge.」技能要求省略开场白、文字简短，并选择最小视图，通常一个，很少全部使用。若仍得到一大堆图，说明 agent 没有遵循要求。若正文庞大是因为差异本身庞大，问题在于 PR 的规模；`pr` 不会代为拆分 PR。

**仓库已有 PR 模板，哪一份优先？**

默认没有哪一份优先。`pr` 有自己的模板，不会查找 `.github/pull_request_template.md` 或类似文件。已有多位用户要求技能采用仓库模板。若不作处理，agent 就会面对针对同一文档的两套竞争指令。应在仓库的 agent 文档中明确安排，例如填写仓库模板，并在其中放入 Summary、Evidence 和 Merge Danger。

**输出是 HTML 吗？为什么 Mermaid 图没有渲染？**

输出是 Markdown 格式的 PR 正文，不是 HTML 页面。GitHub 和 GitLab 会在 PR 描述中渲染 Mermaid 代码块，但终端不会，因此 agent 在本地展示时，看起来仍是原始文本。使用 CLI 宿主的用户曾通过 ASCII Mermaid 渲染器，或让 agent 为 PR 附加 HTML 版本来解决。Mermaid 只是六种视图之一；调用树、文件树和适合主题的差异展示在各处都能以相同方式阅读。

**它能整理收到的审查评论吗？**

不能。它编写正文后就停止。用户曾多次希望有一种方式分诊其他开发者或审查机器人给出的评论，判断哪些值得处理、哪些并非问题。本技能不做这件事。

**PR 变化后，它会持续更新正文吗？**

不会。它只在某个时间点编写正文；PR 在审查期间发生变化，就会使正文过时。较大变更后，请 agent 重写正文。此时 agent 再次编写 PR 正文，会使用同样的结构。

**变更没有 UI，Evidence 中放什么？**

使用截图以外的证据。只有视觉变更时，截图才是最强证据。迁移、后台任务或重构应展示同一个测试在变更前失败、变更后通过的情况，或发生变化的控制台输出。单独写「Tests are green」只是一个断言，不是前后对比。

**它能标注正文由 LLM 编写吗？**

本技能不会自行标注。一位用户的做法是在仓库的 agent 文档中设置长期指令，要求 agent 编写的每个工单、评论和 PR 都以披露说明结束。这条规则应属于仓库，从而覆盖 agent 发布的所有内容，而不是只放在某一种文档的模板中。

## It's working if

- 在打开差异之前，仅看 Summary 的可视化视图就能知道 PR 改了什么。
- 正文没有开场白，直接从 Summary 标题开始。
- Evidence 展示前后对比，而不只是声称测试通过。
- 每个 PR 都说明是哪种门及其影响范围；遇到单向门时，审查者会放慢速度仔细核查。

## Where it fits

当构建成果通过 PR 交付时，`pr` 位于审查与复盘之间：`to-spec → to-tickets → implement → code-review → pr → retro`。它可由模型调用，因此 agent 在这条链之外编写 PR 正文时，也可以自行调用。

- [code-review](https://aihero.dev/skills-code-review) 在它之前执行，因为 PR 正文应描述已审查过的差异。
- [implement](https://aihero.dev/skills-implement) 生成正文所描述的提交。

不确定当前情况该选哪个技能时，[ask-matt](https://aihero.dev/skills-ask-matt) 可在整个技能集合中提供路由建议。
