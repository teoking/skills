## What it does

`grill-me` 从一个**粗略想法**开始，通过访谈让使用者最终能够确定并认可它。开始时不需要完整计划，因为[会话（session）](https://www.aihero.dev/ai-coding-dictionary/session)的目的就是形成计划。它按**轮次**提问，每轮覆盖整个**前沿（frontier）**，也就是所有前置条件已经确定、现在可以提出的问题集合。因此，它不会提出依赖尚未得到的回答的问题。

它是**[无状态的（stateless）](https://www.aihero.dev/ai-coding-dictionary/stateless)**。不写文件，也不留下工作区。唯一结果是使用者脑中更清晰的想法。

## When to reach for it

输入 `/grill-me` 主动调用；[agent](https://www.aihero.dev/ai-coding-dictionary/agent) 不会自行启动它。在**新对话**中开始，不要叠加在已经让 agent 写好的计划之上。

一旦有值得认真考虑的想法（功能、产品方向、业务决策或写作内容），就可以使用，不必先想清楚它涉及什么。模糊不是等待的理由，因为会话正是为了消除模糊。如果已经能准确描述要做的事，就不需要再深入访谈。

三个 grilling 技能的选择取决于眼前的情况：

- **任何主题、任何地点。**使用 `grill-me`。不需要仓库，不写文件，主题也不必与代码有关。
- **需要对照代码库。**使用 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)。它运行同样的访谈，但[有状态（stateful）](https://www.aihero.dev/ai-coding-dictionary/stateful)：会读取代码，并把得到的知识记录为 `GLOSSARY.md` 和架构决策记录（ADR）。
- **一次会话容纳不下。**使用 [wayfinder](https://aihero.dev/skills-wayfinder)。它为工作绘制地图，再在地图中开展 grilling 会话。

保持[计划模式（plan mode）](https://www.aihero.dev/ai-coding-dictionary/agent-mode)关闭。计划模式会让 agent 急于产出计划，而此时需要它继续提问。

## 这是对话，不是被动接受访谈

技能负责提问，但范围由**使用者**掌握。人们经常忽略这一点，而它决定了会话是把想法转化为决策，还是产出充满自信的无稽之谈。

典型失败模式是**被动附和**：面对 40 个问题不断回答「同意、同意、同意」，最后得到的是 agent 编写、使用者点头认可的计划。因为过程很长，看起来很有成效。但使用者并未真正作出决策，结果显得比实际更确定。

主动参与意味着引导方向。问题不够细时，要指出；范围发生偏移时，要说明；确实不知道时，就回答「不知道」。技能帮助工程师，而不取代工程师。结果质量取决于回答质量，不取决于问题数量。

相反的错误也确实存在，只是更少见：一直停留在访谈中，迟迟不开始写代码。

## 能通过访谈解决与不能通过访谈解决的问题

有些问题可以通过讨论解决，有些不行，再多访谈也得不到答案。

「一个长表单，还是分成三页？」和「这个交互应该给人什么感觉？」都**无法仅靠访谈解决**。需要先有一个可以体验的东西，才能回答。遇到这类问题时，停止访谈。用 [prototype](https://aihero.dev/skills-prototype) 构建一次性版本，体验后再回来，用一句话给出答案。

试图靠讨论解决这类问题，会让会话过长。agent 不断换一种问法，使用者不断猜测，范围也随着不确定性扩大。

## Common questions

**大概会有多少问题，怎么知道什么时候结束？**

看轮次，不看问题数量。4 轮共 46 个问题，属于普通会话。前沿为空时结束：每个分支都已讨论，没有未明说的假设。

**它问了 200 个问题。哪里出了问题？**

通常是范围太大。先让 agent 把工作拆成更小的部分，再分别深入访谈。很长的会话还会进入**[低效区（dumb zone）](https://www.aihero.dev/ai-coding-dictionary/smart-zone)**，此时[上下文窗口（context window）](https://www.aihero.dev/ai-coding-dictionary/context-window)已经足够满，问题质量开始下降。

**可以恢复成一次只问一个问题吗？**

可以。在全局 `CLAUDE.md` 中加入以下指令：

```
When grilling, ask one question at a time.
```

**确实不知道答案时怎么办？**

如实说明。「不知道」也是有效回答；答不出来的问题通常意味着该做原型，而不是继续猜测。

**编写[规格说明（spec）](https://www.aihero.dev/ai-coding-dictionary/spec)之前，要开始新会话吗？**

不要。会话的价值就在于刚刚建立的[上下文（context）](https://www.aihero.dev/ai-coding-dictionary/context)。把同一段对话直接交给 [to-spec](https://aihero.dev/skills-to-spec)。

**模型选择重要吗？**

比大多数技能更重要。Grilling 依赖[模型（model）](https://www.aihero.dev/ai-coding-dictionary/model)自身对系统会如何出问题的知识，因此应使用最好的模型。实现主要遵循上下文，使用更便宜的模型也可以。

## It's working if

- 使用者对某些内容提出异议。完全没有反对意见的会话，本来就不需要。
- 问题分几轮提出，而不是长时间一次只问一个；后续轮次明显建立在前面回答的基础上。
- 最终方向出乎意料，因为某个问题揭示了此前一直在无意识中作出的决策。
- 结束时，使用者能向未参加会话的人解释并捍卫每一项选择。

## Where it fits

`grill-me` 是**随时可用、适用于任何主题的独立技能**。无状态让它便于在不同环境中使用。不需要仓库、工作区或预先配置，也不假定想法与软件有关。人们用它讨论业务决策、写作，以及下一步该做什么：凡是独自难以想清楚的问题，都可以使用。

这种可移植性是它与 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 的唯一区别。后者运行同样的访谈，但会读取代码库进行核对，并把得到的知识记录为 `GLOSSARY.md` 和 ADR。两者底层都使用 [grilling](https://aihero.dev/skills-grilling)。`grill-me` 是不保存状态、仅由用户主动调用的入口。

如果讨论的想法最终确实属于软件，可以把同一段对话交给 [to-spec](https://aihero.dev/skills-to-spec)，继续进入构建流程（这是可选路径，而非本技能的目的）。不确定哪个流程合适时，使用 [ask-matt](https://aihero.dev/skills-ask-matt) 路由。
