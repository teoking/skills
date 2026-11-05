## What it does

`writing-for-agents`（技能与指令编写）指导你编写 [agent](https://www.aihero.dev/ai-coding-dictionary/agent) 阅读的文档：[技能](https://www.aihero.dev/ai-coding-dictionary/skill)、`AGENTS.md`、`CLAUDE.md`、[规格说明](https://www.aihero.dev/ai-coding-dictionary/spec)、运行时提示、README，以及通过指针读取的材料。格式不同，写作方法相同。目标是稳定执行过程，而不是让每次输出相同。

它默认通过删除而非增加解释来修正。让 agent 为另一个 agent 编写指令时，大量文字往往在解释[模型](https://www.aihero.dev/ai-coding-dictionary/model)已经知道的内容。核心检验是**无效指令（no-op）**：删掉一句话是否会改变 agent 的行为？不会改变的整句删除，会改变的保留；无效指令消耗[上下文](https://www.aihero.dev/ai-coding-dictionary/context)，却不改变行为。因此，这份参考既适用于空白文件，也适用于已有文档。默认以简体中文提问、解释和交付，用户指定其他语言时遵从用户，英文技能标识、配置字段、命令与代码保持准确。

几乎所有方法都不限于技能。仅技能所需的机制，包括前置元数据（frontmatter）、模型调用与用户调用的选择、路由技能，放在配套的 `SKILL-MECHANICS.md` 中，只有正在编写技能时才读取。

## When to reach for it

输入 `/writing-for-agents`，或由 agent 在创建或编辑技能、修改 `AGENTS.md` 或 `CLAUDE.md` 时自主调用，例如「帮我写一个技能」「改进 agent 指令」。显式调用语法由[宿主](https://www.aihero.dev/ai-coding-dictionary/harness)决定。给普通读者写文章不属于自动触发范围。

- 其他供 agent 阅读的材料也可以手动使用这份参考，包括文档、规格说明、[工单](https://www.aihero.dev/ai-coding-dictionary/ticket)、系统提示、[AFK 提示](https://www.aihero.dev/ai-coding-dictionary/afk)及其他运行时提示。判断只需一个问题：agent 会读它吗？无论材料是由指针引用、用户粘贴，还是放在仓库中，都适用。
- 要调查代码库包含什么并澄清需求，选择 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)。本参考解决文档如何表达，而不负责调查文档应知道哪些事实。

## 两类负担

- **上下文负担（context load）**：始终加载的材料占用 agent 的[上下文窗口](https://www.aihero.dev/ai-coding-dictionary/context-window)，例如 `AGENTS.md` 中的一行或技能描述。无论是否触发，每个[轮次](https://www.aihero.dev/ai-coding-dictionary/turn)都消耗 [token](https://www.aihero.dev/ai-coding-dictionary/token) 与注意力。
- **认知负担（cognitive load）**：你记住文档及使用时机的成本。不要一概追求最小化，这是保留人的自主权的代价；人的判断有价值时，值得投入。

从两类负担看，拆分或合并、内联或披露、提供指针或直接放入上下文，都是同一个取舍在不同位置的体现。

## 写作杠杆

- **[上下文指针](https://www.aihero.dev/ai-coding-dictionary/context-pointer)**：留在上下文中，指出上下文之外的材料并说明何时读取。技能描述和 `AGENTS.md` 中指向文档的一行文字是同一类对象；决定读取是否可靠的是措辞，而非目标内容。
- **信息层级**：正文按需要的紧迫程度安排为文件内步骤、文件内参考、通过指针读取的外置参考。**[渐进披露](https://www.aihero.dev/ai-coding-dictionary/progressive-disclosure)**把材料沿层级下移，保持顶层易读。每条分支都需要的内容留在正文，只有部分分支需要的内容按需披露。
- **完成条件**：每一步的完成边界有多清晰、要求有多强，以及要求带来的**调查投入（legwork）**。这些是抵御**提前结束（premature completion）**的机制。
- **引导词（leading words）**：用模型预训练中已有的紧凑概念锚定行为，例如紧凑（tight）、红灯（red）、曳光弹（tracer bullet）。它在正文中引导执行，在指针中触发调用。
- **修剪**：逐句应用唯一事实来源、相关性和无效指令检验，对抗**重复（duplication）**、**沉积（sediment）**和**蔓延（sprawl）**。

本 fork 翻译描述、正文和显示名称，但保留 `name`、目录名、配置字段、路径、可执行内容及约定的模板字段。中文显示名称不产生中文命令别名，调用策略也不会因翻译自动改变。

## Common questions

**`writing-great-skills` 去哪里了？**

v1.1 将它重命名为 `writing-for-agents`，因为它适用于多种 agent 文档。在改名前，用户就已将它用于 `AGENTS.md`、文档、规格说明、工单和运行时提示。结构、引导词和修剪适用于 agent 阅读的任何文本。没有旧名称别名，引用和安装应使用新标识。

**「Writing for agents」是让 agent 来写吗？**

恰好相反：你是作者，agent 是读者。难点在于读者已经读过大量材料，额外解释容易浪费篇幅，精确表达才是核心。

**不能直接让 agent 帮我写吗？**

可以，但它会生成冗长的内容。若不加引导，模型会解释自己已经知道的内容，不会自主应用无效指令检验或使用引导词。用这份参考审查草稿，它的大部分价值来自这轮审查。

**让 agent 精简文档，结果把功能删了怎么办？**

被要求「精简」的 agent 会优化长度，因为长度是它能直接观察的指标。应检查行为而不只是长度：逐句判断删除后是否改变行为，用真实任务验证分歧，而非靠争论决定。去掉无效指令时删除整句，不只是缩短措辞；保留流程条件、引用和边界。

**怎么知道已经完成？**

文档实际有效，而且再也找不到重复、沉积或无效指令时才算完成。没有自动化评测，需要手动运行文档，用失败模式的术语诊断问题。文档行为不符合预期时，先明确是哪一种失败模式，再针对它修正。

**内容放 `CLAUDE.md` 还是单独文件？**

看愿意承担哪类负担。`CLAUDE.md` 在每个[会话](https://www.aihero.dev/ai-coding-dictionary/session)中无条件加载；指针后的材料在触发前只承担指针本身的成本。仅十次会话中一次需要的材料，在其他九次中仍会消耗上下文负担。仅少数任务需要的参考适合外置，但指针必须明确说明何时读取。

**每换一个模型，都要重写文档吗？**

通常不需要，而且过度适配某一个模型会带来新问题。为新模型更新文档时，通常只需再做一轮无效指令检查，而不是重写。

**我的技能只对当初用于编写它的那个任务有效。**

常见方法是先完成一次任务，再让 agent 把过程写成技能；这容易过度拟合那次运行，使示例过于具体。把该次运行保留为证据，然后有意识地泛化：剔除只属于那个仓库和那些文件的内容，面向整类任务编写。

**英语不是我的母语，会失去引导词的优势吗？**

不会。这份参考会帮助你找到能用最少 token 承载最多行为的词。

## It's working if

- 文档越改越短，剩下的内容少得出乎意料，但真实任务中的必要步骤、边界和完成条件仍然有效。
- 没有以任何形式重复陈述同一含义，修改时不用在多处追着改。重复是文档未经过测试最可靠的信号。
- 仅特定分支需要的参考放在指针后按需读取，主要步骤仍清晰可见。
- 你能指出某个引导词如何在多个位置改变 agent 的执行，而不只是觉得措辞漂亮。

## Where it fits

这是随时可用的独立参考，服务于整个技能库，而非某个单独技能。本库的每个技能都使用它编写；其他技能生成的文档，包括 `GLOSSARY.md`、架构决策记录（ADR）、规格说明和工单，只要 agent 需要阅读，也在适用范围内。唯一直接调用它的技能是 [retro](https://aihero.dev/skills-retro)，会在建议修改任何引导文件或技能之前加载它。不确定流程时，由 [ask-matt](https://aihero.dev/skills-ask-matt) 提供路线。
