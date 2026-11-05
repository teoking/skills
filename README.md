<p>
  <a href="https://www.aihero.dev/s/skills-newsletter">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skills-repo-dark_2x.png">
      <source media="(prefers-color-scheme: light)" srcset="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png">
      <img alt="Skills" src="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png" width="369">
    </picture>
  </a>
</p>

# Skills For Real Engineers

[中文版本：codingrock](https://github.com/teoking/skills/tree/codingrock)

My agent skills that I use every day to do real engineering - not vibe coding.

Developing real applications is hard. Approaches like GSD, BMAD, and Spec-Kit try to help by owning the process. But while doing so, they take away your control and make bugs in the process hard to resolve.

These skills are designed to be small, easy to adapt, and composable. They work with any model. They're based on decades of engineering experience. Hack around with them. Make them your own. Enjoy.

If you want to keep up with changes to these skills, and any new ones I create, you can join ~60,000 other devs on my newsletter:

[Sign Up To The Newsletter](https://www.aihero.dev/s/skills-newsletter)

## 中文入口

本地中文维护范围已覆盖「想法到交付」主流程、首次配置及共享参考，并保留此前的故障诊断和代码库架构改进。默认用简体中文交互，英文技能标识、命令、路径和调用策略保持稳定；未列入中文范围的技能仍保留上游正文。范围、安装来源、翻译基线和验收清单见[中文维护指南](./LOCALIZATION.md)。下方安装命令只获取 `git@github.com:teoking/skills.git` 的 `codingrock` 分支中已推送的提交，不包含本地未提交或未推送的修改；`main` 与上游一致，未做中文优化。

主流程从需求访谈开始，按问题和构建规模选择分支：

- 需要可运行答案：用 `handoff` 转到独立会话制作 `prototype`，再将结论交接回来。
- 跨会话构建：`grill-with-docs` → `to-spec` → `to-tickets` → 逐工单 `implement` 或整份规格说明 `implement-spec` → `retro`。
- 当前会话即可完成：`grill-with-docs` → `implement` → `retro`。

实现阶段使用 `tdd` 和 `code-review`；写 PR 时使用 `pr`。技能之间的调用仍遵循原有策略，中文化不增加自动执行能力。

### User-invoked（仅用户主动调用）

| 中文名称 | 技能标识 | 用途 |
| --- | --- | --- |
| 流程导航 | [ask-matt](./skills/engineering/ask-matt/SKILL.md) | 根据当前情况推荐下一步，不代为启动工作 |
| 首次配置 | [setup-matt-pocock-skills](./skills/engineering/setup-matt-pocock-skills/SKILL.md) | 配置工单跟踪器、分诊标签和领域文档布局 |
| 需求访谈与文档 | [grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md) | 在工作目录中澄清想法，及时维护术语表和 ADR |
| 无状态需求访谈 | [grill-me](./skills/productivity/grill-me/SKILL.md) | 无工作目录时使用的访谈入口，不保存本地文档 |
| 上下文交接 | [handoff](./skills/productivity/handoff/SKILL.md) | 将可携带的交接文档写入系统临时目录 |
| 规格说明 | [to-spec](./skills/engineering/to-spec/SKILL.md) | 综合已有讨论，不重新访谈；确认测试接缝后发布 |
| 工单拆分 | [to-tickets](./skills/engineering/to-tickets/SKILL.md) | 拆成曳光弹工单，明确阻塞关系并等待用户批准 |
| 单项实现 | [implement](./skills/engineering/implement/SKILL.md) | 按规格说明或工单实现，审查后提交当前分支 |
| 整体实现 | [implement-spec](./skills/engineering/implement-spec/SKILL.md) | 按任务图调度子代理，将整份规格说明实现到集成分支 |
| 会话复盘 | [retro](./skills/engineering/retro/SKILL.md) | 回顾会话并提出环境改进建议，等待用户选择候选项 |
| 代码库架构改进 | [improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md) | 扫描深化机会，先生成中文 HTML 报告，再围绕所选候选方案访谈 |

### Model-invoked（模型或用户均可调用）

| 中文名称 | 技能标识 | 可以这样说 |
| --- | --- | --- |
| 需求澄清 | [grilling](./skills/productivity/grilling/SKILL.md) | 帮我把需求问清楚，挑战一下方案中的假设 |
| 领域建模 | [domain-modeling](./skills/engineering/domain-modeling/SKILL.md) | 检查这些术语是否混用了不同概念，并记录已明确的定义 |
| 原型探索 | [prototype](./skills/engineering/prototype/SKILL.md) | 做一个一次性原型，验证这个状态模型是否合理 |
| 测试驱动开发 | [tdd](./skills/engineering/tdd/SKILL.md) | 在约定接缝上先写失败测试，再逐个纵向切片实现 |
| 深模块设计 | [codebase-design](./skills/engineering/codebase-design/SKILL.md) | 帮我评估模块接口和接缝，让复杂行为集中在小接口之后 |
| 代码审查 | [code-review](./skills/engineering/code-review/SKILL.md) | 从指定提交起，分别审查代码标准和规格说明符合程度 |
| PR 正文 | [pr](./skills/engineering/pr/SKILL.md) | 写 PR 说明，展示变更、前后证据和合并风险 |
| 技能与指令编写 | [writing-for-agents](./skills/productivity/writing-for-agents/SKILL.md) | 帮我改进这个技能的触发条件和完成标准 |
| 故障诊断 | [diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md) | 帮我排查这个偶发 bug，并验证修复 |

中文显示名称不创建中文命令别名；显式调用方式由宿主决定。

## Installation (30-second setup)

先配置 GitHub SSH 访问。以下命令固定安装 `codingrock` 分支已推送的提交；已有上游副本时，先通过宿主的插件管理器移除，再启用本 fork，避免同名技能重复。

插件安装使用本 fork 的 marketplace。 [skills.sh](https://skills.sh) copies editable files into your project, and you update them by hand. Pick one per agent, because installing both gives you every skill twice.

### 1. Get the skills

<details>
<summary><strong>Claude Code</strong></summary>

```bash
claude plugin marketplace add "git@github.com:teoking/skills.git#codingrock"
claude plugin install mattpocock-skills@teoking
```

使用本 fork 的 `teoking` marketplace；更新方式以宿主的插件设置为准。

</details>

<details>
<summary><strong>Codex</strong></summary>

```bash
codex plugin marketplace add git@github.com:teoking/skills.git --ref codingrock
codex plugin add mattpocock-skills@teoking
```

使用本 fork 的 `teoking` marketplace；更新方式以宿主的插件设置为准。

</details>

<details>
<summary><strong>GitHub Copilot</strong> (CLI and VS Code)</summary>

```bash
git clone --branch codingrock --single-branch git@github.com:teoking/skills.git skills-codingrock
copilot plugin marketplace add ./skills-codingrock
copilot plugin install mattpocock-skills@teoking
```

保留 `skills-codingrock` 检出目录。更新时先运行 `git -C skills-codingrock pull --ff-only`，再通过宿主插件管理器更新插件；本地来源不会自行拉取远端分支。

In VS Code, run **Chat: Install Plugin From Source** and enter `git@github.com:teoking/skills.git#codingrock`.

</details>

<details>
<summary><strong>Gemini CLI</strong> (manual updates)</summary>

```bash
git clone --branch codingrock --single-branch git@github.com:teoking/skills.git skills-codingrock
gemini skills install ./skills-codingrock/skills/engineering
gemini skills install ./skills-codingrock/skills/productivity
```

更新时先运行 `git -C skills-codingrock pull --ff-only`，再重复两条 `gemini skills install` 命令。已有检出目录时跳过 clone，并确认其分支为 `codingrock`。

</details>

<details>
<summary><strong>Any other agent, or editable files</strong> (manual updates)</summary>

```bash
npx skills@latest add "git@github.com:teoking/skills.git#codingrock" -a <agent>  # cursor, opencode, devin, windsurf, amp, pi; omit -a to choose
```

When the installer asks which skills to take, include `setup-matt-pocock-skills`. To update, re-run the same `add` command with `#codingrock`, preserving the branch selection and picking up new skills.

</details>

### 2. Run `/setup-matt-pocock-skills`

在每个仓库首次使用工程流程前，由用户主动运行一次。它先探索现有配置，再确认并写入：

- 工单跟踪器：优先推荐远端对应的 GitHub 或 GitLab，也支持本地文件和用户描述的其他工作方式。
- 分诊标签：仅在安装了 `triage` 时询问是否保留默认标签，再按需要记录替代名称。
- 领域文档布局：默认写入单上下文布局；只有发现 monorepo 特征时才询问是否采用多上下文布局。

### 3. Bam - you're ready to go.

## Why These Skills Exist

I built these skills as a way to fix common failure modes I see with Claude Code, Codex, and other coding agents.

### #1: The Agent Didn't Do What I Want

> "No-one knows exactly what they want"
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**The Problem**. The most common failure mode in software development is misalignment. You think the dev knows what you want. Then you see what they've built - and you realize it didn't understand you at all.

This is just the same in the AI age. There is a communication gap between you and the agent. The fix for this is a **grilling session** - getting the agent to ask you detailed questions about what you're building.

**The Fix** is to use:

- [`/grill-me`](./skills/productivity/grill-me/SKILL.md)：没有工作目录时使用，不保存本地文档。
- [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md)：在工作目录中使用，同样开展访谈，并及时维护领域术语和 ADR。

These are my most popular skills. They help you align with the agent before you get started, and think deeply about the change you're making. Use them _every_ time you want to make a change.

### #2: The Agent Is Way Too Verbose

> With a ubiquitous language, conversations among developers and expressions of the code are all derived from the same domain model.
>
> Eric Evans, [Domain-Driven-Design](https://www.amazon.co.uk/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215)

**The Problem**: At the start of a project, devs and the people they're building the software for (the domain experts) are usually speaking different languages.

I felt the same tension with my agents. Agents are usually dropped into a project and asked to figure out the jargon as they go. So they use 20 words where 1 will do.

**The Fix** for this is a shared language. It's a document that helps agents decode the jargon used in the project.

<details>
<summary>
Example
</summary>

Here's an example [glossary](https://github.com/mattpocock/course-video-manager/blob/076a5a7a182db0fe1e62971dd7a68bcadf010f1c/CONTEXT.md) (still named `CONTEXT.md` at that pinned commit, from before the skills renamed the convention), from my `course-video-manager` repo. Which one is easier to read?

- **BEFORE**: "There's a problem when a lesson inside a section of a course is made 'real' (i.e. given a spot in the file system)"
- **AFTER**: "There's a problem with the materialization cascade"

This concision pays off session after session.

</details>

This is built into [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md). It's a grilling session, but that helps you build a shared language with the AI, and document hard-to-explain decisions in ADR's.

It's hard to explain how powerful this is. It might be the single coolest technique in this repo. Try it, and see.

> [!TIP]
> A shared language has many other benefits than reducing verbosity:
>
> - **Variables, functions and files are named consistently**, using the shared language
> - As a result, the **codebase is easier to navigate** for the agent
> - The agent also **spends fewer tokens on thinking**, because it has access to a more concise language

### #3: The Code Doesn't Work

> "Always take small, deliberate steps. The rate of feedback is your speed limit. Never take on a task that’s too big."
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**The Problem**: Let's say that you and the agent are aligned on what to build. What happens when the agent _still_ produces crap?

It's time to look at your feedback loops. Without feedback on how the code it produces actually runs, the agent will be flying blind.

**The Fix**: You need the usual tranche of feedback loops: static types, browser access, and automated tests.

自动测试使用红灯 → 绿灯循环：agent 先写失败测试，再编写使测试通过的最少代码，逐个纵向切片获得反馈。`tdd` 将重构留到审查阶段，不把它作为红灯 → 绿灯实现循环的一部分。

I've built a **[`/tdd`](./skills/engineering/tdd/SKILL.md) skill** you can slot into any project. It encourages red-green-refactor and gives the agent plenty of guidance on what makes good and bad tests.

For debugging, I've also built a **[`/diagnosing-bugs`](./skills/engineering/diagnosing-bugs/SKILL.md)** skill that wraps best debugging practices into a disciplined loop, gated phase by phase.

### #4: We Built A Ball Of Mud

> "Invest in the design of the system _every day_."
>
> Kent Beck, [Extreme Programming Explained](https://www.amazon.co.uk/Extreme-Programming-Explained-Embrace-Change/dp/0321278658)

> "The best modules are deep. They allow a lot of functionality to be accessed through a simple interface."
>
> John Ousterhout, [A Philosophy Of Software Design](https://www.amazon.co.uk/Philosophy-Software-Design-2nd/dp/173210221X)

**The Problem**: Most apps built with agents are complex and hard to change. Because agents can radically speed up coding, they also accelerate software entropy. Codebases get more complex at an unprecedented rate.

**The Fix** for this is a radical new approach to AI-powered development: caring about the design of the code.

This is built in to every layer of these skills:

- [`/to-spec`](./skills/engineering/to-spec/SKILL.md) 综合已有讨论，不重新访谈；生成规格说明前与用户确认测试接缝。

And crucially, [`/improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) surveys a codebase for deepening opportunities and hands you the candidates. I recommend running it on your codebase once every few days. It is a survey, not a rescue: on a genuinely old codebase it will find real candidates, but it won't untangle the mud for you.

### Summary

Software engineering fundamentals matter more than ever. These skills are my best effort at condensing these fundamentals into repeatable practices, to help you ship the best apps of your career. Enjoy.

## Reference

These split on one axis: who can invoke them. **User-invoked** skills are reachable only when you type them (e.g. `/grill-me`); their job is to orchestrate. **Model-invoked** skills can be invoked by you _or_ reached for automatically by the agent when the task fits; they hold the reusable discipline. A user-invoked skill may invoke model-invoked skills, but never another user-invoked one.

### Engineering

Skills I use daily for code work.

**User-invoked**

- **[ask-matt](./skills/engineering/ask-matt/SKILL.md)**：流程导航：根据当前情况推荐本仓库中的技能或流程，不代为启动工作。
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)**：需求访谈与文档：逐轮澄清想法，同时明确领域术语并及时更新 `GLOSSARY.md` 和 ADR。
- **[triage](./skills/engineering/triage/SKILL.md)**: Move issues through a state machine of triage roles.
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)**: 代码库架构改进：扫描模块深化机会，生成可视化 HTML 报告，再围绕用户选中的候选方案逐轮访谈。
- **[setup-matt-pocock-skills](./skills/engineering/setup-matt-pocock-skills/SKILL.md)**：首次配置：为当前仓库配置工单跟踪器、分诊标签和领域文档布局，首次使用工程流程前运行。
- **[to-spec](./skills/engineering/to-spec/SKILL.md)**：规格说明：综合已有讨论，不重新访谈；确认测试接缝后生成规格说明并发布到工单跟踪器。
- **[to-tickets](./skills/engineering/to-tickets/SKILL.md)**：工单拆分：将计划、规格说明或讨论拆成曳光弹工单，明确阻塞关系；本地每单一文件，在线优先使用原生阻塞链接。
- **[implement](./skills/engineering/implement/SKILL.md)**：单项实现：按规格说明或工单实现，尽可能在预先约定的接缝上使用 `tdd`，经 `code-review` 审查后提交当前分支。
- **[implement-spec](./skills/engineering/implement-spec/SKILL.md)**：整体实现：把工单作为任务图，跨可执行前沿并行调度实现子代理，将整份规格说明汇入集成分支后统一审查。
- **[wayfinder](./skills/engineering/wayfinder/SKILL.md)**: Plan a huge chunk of work, more than one agent session can hold, as a shared map of decision tickets on the issue tracker, and resolve them one at a time until the way to the destination is clear.
- **[retro](./skills/engineering/retro/SKILL.md)**：会话复盘：按严重程度提出 agent 环境改进，包括导航、自动检查、代码标准、引导文件和工具。

**Model-invoked**

- **[prototype](./skills/engineering/prototype/SKILL.md)**：原型探索：用一次性代码回答设计问题；逻辑分支生成可分享的单个 HTML 文件，UI 分支在同一路由切换多种明显不同的方案。
- **[diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md)**: 故障诊断：建立能捕获具体缺陷的反馈循环，依次最小化、验证假设、增加观测、修复并回归检查。
- **[research](./skills/engineering/research/SKILL.md)**: Investigate a question against high-trust primary sources and capture the findings as a cited Markdown file in the repo, run as a background agent.
- **[tdd](./skills/engineering/tdd/SKILL.md)**：测试驱动开发：在约定接缝上逐个纵向切片运行红灯 → 绿灯循环，重构留到审查阶段。
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)**：领域建模：对照术语表质疑含混定义，用边界场景检验关系，并及时维护 `GLOSSARY.md` 和符合条件的 ADR。
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)**：深模块设计：共享模块、接口、深度和接缝等词汇，使复杂行为集中在小接口之后，并通过该接口测试。
- **[code-review](./skills/engineering/code-review/SKILL.md)**：代码审查：从固定基点分别审查 **Standards（代码标准）** 与 **Spec（规格说明）**，由相互独立的并行子代理执行。
- **[pr](./skills/engineering/pr/SKILL.md)**：PR 正文：用最小可视化说明变更，提供前后验证证据，并判断合并是单向门还是双向门及其影响范围。
- **[wizard](./skills/engineering/wizard/SKILL.md)**: Generate an interactive bash wizard that walks a human through steps only they can perform: provisioning infrastructure, setting up credentials or CI secrets, walking an unfamiliar third-party dashboard, or running a one-off migration or cutover.

### Productivity

General workflow tools, not code-specific.

**User-invoked**

- **[grill-me](./skills/productivity/grill-me/SKILL.md)**：无状态需求访谈：围绕计划或设计持续提问，直到设计树的所有分支都明确。
- **[handoff](./skills/productivity/handoff/SKILL.md)**：上下文交接：综合当前讨论，将脱敏后的交接文档写入系统临时目录，供新 agent 接续工作。
- **[teach](./skills/productivity/teach/SKILL.md)**: Teach the user a new skill or concept over multiple sessions, using the current directory as a stateful teaching workspace.
- **[to-questionnaire](./skills/productivity/to-questionnaire/SKILL.md)**: Turn a decision you can't answer alone into a Markdown questionnaire for the one person who can, filled in async, or together over a meeting. It grills you about the send (who it's for, what you need back), not the subject.
- **[wait-what](./skills/productivity/wait-what/SKILL.md)**: Fire this the moment a message doesn't land. The agent re-pitches it with the context you're missing, in plain English, using your `GLOSSARY.md` vocabulary.

**Model-invoked**

- **[grilling](./skills/productivity/grilling/SKILL.md)**: 需求澄清：按设计树逐轮提问，查明事实、等待用户决策，直到双方确认理解一致。
- **[writing-for-agents](./skills/productivity/writing-for-agents/SKILL.md)**: 技能与指令编写：面向 agent 编写技能、AGENTS.md / CLAUDE.md 与按需读取的参考文档。
