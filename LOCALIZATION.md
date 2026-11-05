# 中文友好改造与维护

本仓库按「小范围试点、逐步扩展」维护中文版本：中文作为已本地化技能的主要维护语言，英文标识保持稳定。其他技能暂时保留上游内容。

## 范围与来源

- 上游：[mattpocock/skills](https://github.com/mattpocock/skills)。
- 初始三技能试点的翻译基线：本地仓库提交 `03866313a2a4352408ab508e5925f828ae106b0d`，包版本 `1.3.1`。这是改造开始时的内容基线，不代表已检查上游最新版本。
- 初始依据：用户提供的 session Markdown 中的三技能试点方案。
- 初始试点日期：2026-10-27。
- `improve-codebase-architecture` 的翻译基线：本地仓库提交 `5f498f90cf12cc29567f866c346637c60c2dcf76`，包版本 `1.3.1`。本次按该提交的内容本地化，没有同步后续上游功能改动。
- 「想法到交付」主流程的翻译基线：本地仓库提交 `097bb98d25501adc45f0dc0fb8ce6f32b3371d44`，包版本 `1.3.1`。覆盖主流程的 12 个直接技能、4 个共享依赖、首次配置和路由，共 18 项；其中 `grilling` 和 `writing-for-agents` 沿用中文版本并对照初始英文基线复核。这是本地内容基线，不代表已经检查上游最新版本。
- 保留原有 `LICENSE`、归属与发布清单。没有新增或改名技能，没有改变 promoted 集合。

| 技能 | 中文范围 | 原有调用方式 |
| --- | --- | --- |
| [grilling](skills/productivity/grilling/SKILL.md) | 描述、正文、界面信息、说明页 | Model-invoked，模型或用户均可调用 |
| [diagnosing-bugs](skills/engineering/diagnosing-bugs/SKILL.md) | 描述、正文、界面信息、说明页、HITL 模板注释和提示语 | Model-invoked，模型或用户均可调用 |
| [writing-for-agents](skills/productivity/writing-for-agents/SKILL.md) | 描述、正文、`SKILL-MECHANICS.md`、界面信息、说明页 | Model-invoked，模型或用户均可调用 |
| [improve-codebase-architecture](skills/engineering/improve-codebase-architecture/SKILL.md) | 描述、正文、`HTML-REPORT.md`、报告文案、界面信息、说明页 | User-invoked，仅用户主动调用 |
| [ask-matt](skills/engineering/ask-matt/SKILL.md) | 描述、正文、`PHASE-BOUNDARIES.md`、界面信息、说明页 | User-invoked，仅用户主动调用 |
| [setup-matt-pocock-skills](skills/engineering/setup-matt-pocock-skills/SKILL.md) | 描述、正文、工单跟踪器及领域文档种子模板、界面信息、说明页 | User-invoked，仅用户主动调用 |
| [grill-with-docs](skills/engineering/grill-with-docs/SKILL.md) | 描述、正文、界面信息、说明页 | User-invoked，仅用户主动调用 |
| [grill-me](skills/productivity/grill-me/SKILL.md) | 描述、正文、界面信息、说明页 | User-invoked，仅用户主动调用 |
| [handoff](skills/productivity/handoff/SKILL.md) | 描述、参数提示、正文、界面信息、说明页 | User-invoked，仅用户主动调用 |
| [domain-modeling](skills/engineering/domain-modeling/SKILL.md) | 描述、正文、`ADR-FORMAT.md`、`GLOSSARY-FORMAT.md`、界面信息、说明页 | Model-invoked，模型或用户均可调用 |
| [prototype](skills/engineering/prototype/SKILL.md) | 描述、正文、`LOGIC.md`、`UI.md`、界面信息、说明页 | Model-invoked，模型或用户均可调用 |
| [to-spec](skills/engineering/to-spec/SKILL.md) | 描述、正文、规格说明模板、界面信息、说明页 | User-invoked，仅用户主动调用 |
| [to-tickets](skills/engineering/to-tickets/SKILL.md) | 描述、正文、本地及在线工单模板、界面信息、说明页 | User-invoked，仅用户主动调用 |
| [implement](skills/engineering/implement/SKILL.md) | 描述、正文、界面信息、说明页 | User-invoked，仅用户主动调用 |
| [implement-spec](skills/engineering/implement-spec/SKILL.md) | 描述、正文、界面信息、说明页 | User-invoked，仅用户主动调用 |
| [tdd](skills/engineering/tdd/SKILL.md) | 描述、正文、`tests.md`、`mocking.md`、界面信息、说明页 | Model-invoked，模型或用户均可调用 |
| [codebase-design](skills/engineering/codebase-design/SKILL.md) | 描述、正文、`DEEPENING.md`、`DESIGN-IT-TWICE.md`、界面信息、说明页 | Model-invoked，模型或用户均可调用 |
| [code-review](skills/engineering/code-review/SKILL.md) | 描述、正文、界面信息、说明页 | Model-invoked，模型或用户均可调用 |
| [pr](skills/engineering/pr/SKILL.md) | 描述、正文、`CREDITS.md`、界面信息、说明页；固定引用和归属保持原文 | Model-invoked，模型或用户均可调用 |
| [retro](skills/engineering/retro/SKILL.md) | 描述、正文、界面信息、说明页 | User-invoked，仅用户主动调用 |

## 主流程本地化任务

| 任务组 | 技能 | 核对重点 |
| --- | --- | --- |
| 需求访谈与领域文档 | `grill-with-docs`、`grill-me`、`grilling`、`domain-modeling` | 包装入口的调用次数、逐轮等待、领域术语及时记录、ADR 的三个条件 |
| 上下文交接与原型 | `handoff`、`prototype` | 系统临时目录、脱敏、双向交接、逻辑与 UI 分支、原型分支保留 |
| 规格说明与工单拆分 | `to-spec`、`to-tickets` | 不重新访谈、确认测试接缝、纵向切片、阻塞关系、广泛重构例外、等待批准 |
| 实现与 TDD | `implement`、`implement-spec`、`tdd` | 预先约定接缝、红灯 → 绿灯、任务图、worktree、集成分支、审查与清理 |
| 审查、PR 与复盘 | `code-review`、`pr`、`retro` | 独立双轴审查、最小可视化、前后证据、合并风险、机械错误优先自动检查 |
| 共享参考与首次配置 | `codebase-design`、`writing-for-agents`、`setup-matt-pocock-skills` | 术语定义、调用策略、GitHub/GitLab/本地分支、条件性分诊、模板字段 |
| 路由与阶段边界 | `ask-matt` | 先读技能再推荐、保留完整地图、阶段边界五项决策的顺序 |

此轮不翻译 `triage`、`wayfinder`、`research`、`wizard`、`teach`、`to-questionnaire` 和 `wait-what` 的技能正文；它们在路由中的说明已随路由翻译，流程边界不变。此前 `improve-codebase-architecture` 审查中尚未应用的建议也不在本轮修正范围。

逐项评分、修正记录、静态检查及未验证项见[主流程本地化审查记录](.agents/localization-main-flow-review.md)。评分依据来自中文技术写作规范的规则优先级，不是该规范自带的量表，也不是宿主运行评分。

## 翻译、个人偏好与宿主适配

翻译保留每一步的前置条件、完成条件、等待时机、文件引用与流程边界。关键术语首次出现附英文，便于对照。目录、`name`、配置字段、代码标识、命令和路径不翻译。

中文版本新增的输出偏好是：已本地化技能默认用简体中文提问、解释和交付，`improve-codebase-architecture` 的 HTML 报告也使用中文；用户指定其他语言时遵从用户，代码与技术标识遵循目标项目约定。这是新增的输出偏好，不是上游原文已有的要求。

主流程统一使用「规格说明（spec）」「工单（ticket）」「工单跟踪器（issue tracker）」「曳光弹（tracer bullet）」「纵向切片（vertical slice）」「阻塞关系（blocking edges）」「前沿（frontier）」和「集成分支（integration branch）」。架构词汇沿用「模块」「接口」「实现」「深度」「接缝」「适配器」「杠杆效应」和「局部性」，完整定义由 `codebase-design` 维护。

生成模板中的固定英文标题、字段、状态值和标识保留原样，如 `## Agent skills`、`## Problem Statement`、`**Status:** ready-for-agent`、ADR 状态和工单标签；模板下的说明及面向用户的提示用中文。说明页按仓库约定保留固定英文章节标题。中文显示名称和中文模板说明均不改变字段含义或 CLI 操作。

没有限制提问数量、改变诊断阶段、替换子代理、修改技能依赖调用方式，也没有改动 `grill-me` 的手动调用策略。`agents/openai.yaml` 的中文显示名称不创建中文命令别名。`improve-codebase-architecture` 保留 `disable-model-invocation: true` 和 `policy.allow_implicit_invocation: false`，不会因中文请求自动启动；报告中的推荐强度和依赖类别保留英文标识，架构术语首次出现附英文原词。

## 使用自己维护的版本

首页安装说明固定使用 `git@github.com:teoking/skills.git` 的 `codingrock` 分支（`main` 与上游一致，未做中文优化），marketplace 名为 `teoking`，插件完整名称为 `mattpocock-skills@teoking`。安装命令的权威来源为 [.agents/install-block.md](.agents/install-block.md)。安装前配置 GitHub SSH 访问；安装器只能获取已推送的提交，无法获取本地未提交的修改。上游来源与本 fork 二选一，自动更新行为以宿主设置为准。

先确认宿主实际读取的技能目录或插件来源，再让它加载本仓库中的完整技能目录。选择性加载时保留配套文件；若选用 `grill-me` 等包装入口，也要保留它们的依赖。若之前注册了未指定分支的 marketplace，通过宿主插件管理器移除旧来源后，按首页命令重新注册，并确认来源指向 `codingrock`。同一宿主的发现范围内，每个英文技能标识只保留一个有效版本，避免插件副本和本地副本重复。

仓库已有 [scripts/link-skills.sh](scripts/link-skills.sh)，面向维护者，将非 `misc/`、非 `deprecated/` 的技能链接到 `~/.claude/skills` 和 `~/.agents/skills`。它会覆盖同名条目，使用前先确认现有内容；它不配置 pi，也不代表其他 ChatGPT 环境已安装。本次没有新增、删除或重命名技能，因此未执行重新链接，也没有更改任何宿主的全局安装。

## 宿主能力边界

- `grilling` 的环境事实调查仍要求子代理；没有该能力时，记录限制，另行设计适配，不能宣称完整流程已通过。
- `improve-codebase-architecture` 的代码库探索仍要求子代理，依赖 `codebase-design`、`grilling` 和 `domain-modeling` 的 Skill 工具调用。默认报告仍通过 CDN 加载 Tailwind 和 Mermaid，浏览器需能访问这些资源；本次没有新增离线回退或自动重构。
- `grill-me` 等包装入口仍使用上游的 `Skill` 工具调用约定。宿主没有同名工具时，需要单独处理依赖加载；本次可以直接选择试点技能验证其本身。
- `diagnosing-bugs` 需要可执行的复现环境；HITL 模板还需要人工终端输入。普通对话中读到技能正文，不等于能运行测试或脚本。
- `implement-spec` 仍要求子代理调度、可写的探索笔记、独立 worktree、集成分支合并，以及工单跟踪器约定的完成方式；翻译没有增加缺少这些能力时的自动回退。
- `code-review` 仍分别派出 Standards 和 Spec 审查子代理；`prototype` 的 UI 分支仍要求浏览器截图能力，逻辑分支仍需生成可运行的 HTML。
- `setup-matt-pocock-skills` 仍需要人工确认；选择 GitHub/GitLab 时必须先验证远端项目可访问。读取其模板不等于 CLI 鉴权或远端写入已经通过。
- 实际触发、显示名称和显式调用语法取决于宿主。这里不把仓库格式检查当作 pi、ChatGPT 的运行验收。

## 上游同步流程

1. 从记录的各技能基线到选定新提交查看差异，覆盖已本地化技能目录及对应说明页，先找流程和引用变化。
2. 对照新旧正文逐项更新中文，重点核对前置条件、完成条件、调用限制和配套文件。
3. 翻译与输出语言偏好、提问节奏、宿主适配分别维护；提交时分开记录，避免更新时混淆。
4. 同步顶层和分桶索引、对应 `docs/<bucket>/<skill-name>.md`。如果用户入口或流程变化，重新检查 `ask-matt` 路由。
5. 检查 YAML、相对链接、脚本语法和 promoted 清单。只有触及插件 manifest 时才必须运行 `claude plugin validate . --strict`。
6. 用下面的场景分别验证目标宿主，记录宿主、版本、模型、实际加载路径、观察到的行为和失败原因。通过后更新本页的基线与范围。

## 中文验收场景

每个场景使用独立会话，先记录实际加载的 `SKILL.md` 路径，避免误测到上游副本。自然触发测试不提前显式加载技能；手动测试用宿主实际支持的显式选择方式。

| 技能 | 应该触发 | 容易误触发，预期不启动完整流程 | 手动调用与关键行为 |
| --- | --- | --- | --- |
| grilling | “挑战一下我的活动方案，通过提问找出遗漏。” | “只把这句话翻译成英文：帮我把需求问清楚。” | 选择 `grilling`；问题和推荐答案为中文，依赖问题留到下一轮，等待回答与最终确认 |
| diagnosing-bugs | “导出功能升级后偶发失败，请排查根因并修复。”提供可运行的最小项目 | “只解释 TypeError 是什么，不要启动诊断。” | 选择 `diagnosing-bugs`；先运行能捕获症状的命令，脱敏输出，最小化后展示假设，修复后复跑原始场景 |
| writing-for-agents | “帮我改进这个 AGENTS.md 的触发条件和完成标准。”提供草稿 | “帮我润色给客户看的活动邀请函。” | 选择 `writing-for-agents`；保留有效约束，按分支披露参考；写技能时读取 `SKILL-MECHANICS.md` |
| improve-codebase-architecture | 不自动触发，需手动选择技能 | 「看看这个仓库有哪些架构问题。」不应绕过仅用户主动调用策略 | 选择 `improve-codebase-architecture`；先按方向或近期提交热点探索，再在临时目录生成中文 HTML 报告并告知绝对路径；等待选择后才调用 `grilling`，术语与 ADR 变化交给 `domain-modeling` |

另测 `grill-me`：自然中文请求不应绕过其 `disable-model-invocation: true` 和 `allow_implicit_invocation: false`；手动选择后检查是否加载 `grilling`，不能凭包装入口名称推断依赖已执行。

另测 `improve-codebase-architecture`：用户指定英文时，报告和问题应遵从用户；默认中文报告的 `lang` 为 `zh-CN`。推荐强度标识保持 `Strong`、`Worth exploring`、`Speculative`；报告前不设计接口，探索与报告不修改业务代码。派子代理和加载依赖应在宿主执行记录中可见，不能仅凭报告内容推断已执行。

当前状态：原三项试点已完成仓库静态检查和 HITL 模板的模拟输入冒烟检查；pi 与 ChatGPT 的实际发现、中文自动触发、多轮访谈及真实缺陷修复尚待分别运行验收。`improve-codebase-architecture` 本次仅完成仓库静态检查，宿主发现、子代理探索、浏览器报告渲染和多轮架构访谈尚未运行验收。该表是可重复使用的验收清单，不是已通过的运行报告。

「想法到交付」主流程的 18 项本地化与独立只读审查已完成，最终评分为 9.4 至 10.0，全部达到至少 8 分的门槛。三个出现 7.9 分的项目均已修正并复审：`prototype` 的默认持久化范围及数据库例外、`to-tickets` 的父子关系适用模式、`code-review` 说明页与正文的排除条件冲突。YAML、调用策略、依赖、索引、模板和链接的静态检查通过；18 个说明页的 Markdown 渲染冒烟及 78 个外部 URL 的 HTTP 状态检查通过。完整分项评分、源文一致性修正、非关键意见及检查边界见[审查记录](.agents/localization-main-flow-review.md)。这些结果不代表宿主运行已验收。审查完成时，改动尚未提交或推送，本轮未更新全局安装；后续提交状态以 Git 历史为准。
