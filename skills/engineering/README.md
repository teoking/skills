# Engineering

Skills I use daily for code work.

## User-invoked

Reachable only when you type them (Claude Code: `disable-model-invocation: true`; Codex: `policy.allow_implicit_invocation: false` in `agents/openai.yaml`).

- **[ask-matt](./ask-matt/SKILL.md)**：流程导航：根据当前情况推荐本仓库中的技能或流程，不代为启动工作。
- **[grill-with-docs](./grill-with-docs/SKILL.md)**：需求访谈与文档：逐轮澄清想法，同时明确领域术语并及时更新 `GLOSSARY.md` 和 ADR。
- **[triage](./triage/SKILL.md)**: Move issues through a state machine of triage roles.
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)**: 代码库架构改进：扫描模块深化机会，生成可视化 HTML 报告，再围绕用户选中的候选方案逐轮访谈。
- **[setup-matt-pocock-skills](./setup-matt-pocock-skills/SKILL.md)**：首次配置：为当前仓库配置工单跟踪器、分诊标签和领域文档布局，首次使用工程流程前运行。
- **[to-spec](./to-spec/SKILL.md)**：规格说明：综合已有讨论，不重新访谈；确认测试接缝后生成规格说明并发布到工单跟踪器。
- **[to-tickets](./to-tickets/SKILL.md)**：工单拆分：将计划、规格说明或讨论拆成曳光弹工单，明确阻塞关系；本地每单一文件，在线优先使用原生阻塞链接。
- **[implement](./implement/SKILL.md)**：单项实现：按规格说明或工单实现，尽可能在预先约定的接缝上使用 `tdd`，经 `code-review` 审查后提交当前分支。
- **[implement-spec](./implement-spec/SKILL.md)**：整体实现：把工单作为任务图，跨可执行前沿并行调度实现子代理，将整份规格说明汇入集成分支后统一审查。
- **[wayfinder](./wayfinder/SKILL.md)**: Plan a huge chunk of work (more than one agent session can hold) as a shared map of decision tickets on the issue tracker, resolved one at a time until the way to the destination is clear.
- **[retro](./retro/SKILL.md)**：会话复盘：按严重程度提出 agent 环境改进，包括导航、自动检查、代码标准、引导文件和工具。

## Model-invoked

Model- or user-reachable (rich trigger phrasing so the model can reach for them).

- **[prototype](./prototype/SKILL.md)**：原型探索：用一次性代码回答设计问题；逻辑分支生成可分享的单个 HTML 文件，UI 分支在同一路由切换多种明显不同的方案。

- **[diagnosing-bugs](./diagnosing-bugs/SKILL.md)**: 故障诊断：建立能捕获具体缺陷的反馈循环，依次最小化、验证假设、增加观测、修复并回归检查。
- **[research](./research/SKILL.md)**: Investigate a question against high-trust primary sources and capture the findings as a cited Markdown file in the repo, run as a background agent.
- **[tdd](./tdd/SKILL.md)**：测试驱动开发：在约定接缝上逐个纵向切片运行红灯 → 绿灯循环，重构留到审查阶段。
- **[domain-modeling](./domain-modeling/SKILL.md)**：领域建模：对照术语表质疑含混定义，用边界场景检验关系，并及时维护 `GLOSSARY.md` 和符合条件的 ADR。
- **[codebase-design](./codebase-design/SKILL.md)**：深模块设计：共享模块、接口、深度和接缝等词汇，使复杂行为集中在小接口之后，并通过该接口测试。
- **[code-review](./code-review/SKILL.md)**：代码审查：从固定基点分别审查 **Standards（代码标准）** 与 **Spec（规格说明）**，由相互独立的并行子代理执行。
- **[pr](./pr/SKILL.md)**：PR 正文：用最小可视化说明变更，提供前后验证证据，并判断合并是单向门还是双向门及其影响范围。
- **[wizard](./wizard/SKILL.md)**: Generate an interactive bash wizard that walks a human through steps only they can perform: provisioning infrastructure, setting up credentials or CI secrets, walking an unfamiliar third-party dashboard, or running a one-off migration or cutover.
