## What it does

`codebase-design` 统一设计模块时使用的词汇：**模块（module）**、**接口（interface）**、**深度（depth）**、**接缝（seam）**、**适配器（adapter）**、**杠杆效应（leverage）**、**局部性（locality）**。它精确定义每个词，禁止使用含义宽泛的替代词（「component」「service」「API」「boundary」），并说明由这些定义得出的几个原则。

它是参考资料，不是流程。它不运行循环、不产出交付物，也不会停下来向用户提问。其他涉及设计的技能都使用它的术语。单独调用时，它只提供用语，到此为止。调用前应理解这一点。如果让一个[会话](https://www.aihero.dev/ai-coding-dictionary/session)使用没有流程、也没有停止规则的技能，然后要求「开始」，agent 就会自行编造流程。下文的问题展示了这种情况。

## When to reach for it

可以输入 `/codebase-design` 调用；设计任务适合时，agent 也可以自动调用。

已经知道要重新设计哪段代码，需要思考它的形态时使用：接缝放在哪里，接口能缩小到什么程度，提取模块是否能消除调用者的复杂性。也可用它解决设计术语含义上的分歧。

有几个相近的技能，按当前问题选择：

| 问题 | 技能 |
|---|---|
| 一个模块的形态：接口、接缝、深度 | `codebase-design` |
| *领域用语*：「account」有三种含义，两个人对「cancellation」的理解不同 | [domain-modeling](https://aihero.dev/skills-domain-modeling) |
| 尚不知道要重新设计*哪个*模块 | [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture)，通过调查寻找候选对象 |
| 想让设计受到质疑，而不只是给概念命名 | [grilling](https://aihero.dev/skills-grilling) |
| 要实现具体行为，并希望测试能经受重构 | [tdd](https://aihero.dev/skills-tdd) |

## 术语

术语表就是这个技能。它通过术语之间的关系定义每个词，并指出哪些词不应作为替代。

| 术语 | 含义 | 避免使用 |
|---|---|---|
| **模块** | 任何具有接口和实现的事物。刻意不限定规模：函数、类、包、跨层切片都可以是模块。 | unit、component、service |
| **接口** | 调用者为了正确使用模块必须知道的一切：类型签名、不变条件、顺序约束、错误模式、必需的配置和性能特征。 | API、signature |
| **深度** | 接口处的杠杆效应：调用者或测试每学习一单位接口，就能使用或检验多少行为。**深**：小接口后面封装大量行为。**浅**：接口几乎与实现一样复杂。 | 无 |
| **接缝** | Michael Feathers 的术语：可以改变行为而无须编辑该位置代码的地方。它是接口所在的*位置*。决定把接缝放在哪里，与决定后面放什么，是两项独立的决策。 | boundary |
| **适配器** | 在接缝处满足接口的具体事物。它指角色，而不是事物的种类：内存中的伪实现和 Postgres 仓库都是适配器。 | 无 |
| **杠杆效应** | 调用者从深度中获得的收益：每学习一单位接口，就能获得更多能力。 | 无 |
| **局部性** | 维护者从深度中获得的收益：变更、缺陷和验证集中在一处，因此一次修复能覆盖所有调用者。 | 无 |

这个技能*不*采用 Ousterhout 自己的定义，即实现行数与接口行数之比。这个指标会奖励给实现凑行数，因此技能改用接口处的杠杆效应来理解深度。

## 四个原则

- **深度是接口的属性，而不是实现的属性。** 深模块内部可以由可替换的小部件构成，只是调用者看不到它们。模块可以有供自身测试使用的内部接缝，以及接口处的一条外部接缝。
- **删除检验。** 想象删除模块。如果复杂性消失了，它就只是一个转发层。如果复杂性重新出现在 N 个调用者中，这个模块就在隐藏真正的复杂性。
- **接口就是测试面。** 调用者和测试跨越同一条接缝。如果想越过接口测试内部，模块的形态就不对。
- **一个适配器意味着假想接缝，两个适配器才意味着真实接缝。** 接缝两侧没有变化时，不要切出接缝。只有一个适配器的接缝只是增加了间接层。

两个配套文件进一步展开这些概念，技能按需读取，而不是一开始就全部加载。[DEEPENING.md](https://github.com/mattpocock/skills/blob/main/skills/engineering/codebase-design/DEEPENING.md) 把候选对象的依赖分成四类（in-process、local-substitutable、remote-but-owned、true-external），因为类别决定如何跨接缝测试深化后的模块。[DESIGN-IT-TWICE.md](https://github.com/mattpocock/skills/blob/main/skills/engineering/codebase-design/DESIGN-IT-TWICE.md) 并行派出[子代理](https://www.aihero.dev/ai-coding-dictionary/subagent)，为同一模块产出至少三种根本不同的接口，再按深度、局部性和接缝位置比较。

## Common questions

**在 TypeScript 中，究竟怎样构建深模块？**

这是关于这个技能最常见的问题，而技能并不回答它。它定义深模块*是什么*，却不说明如何阻止随意的导入越过接口。[工单 #458](https://github.com/mattpocock/skills/issues/458) 直接提出了这个问题，原文是：「let's say we're happy with the interface, it hides the details, etc. But how do we enforce it? I think without linting or clear guardrails, humans and LLMs alike will start making it messy over time.」讨论给出了三种选择：

- 用类或 IIFE 封装，并接受类会变得非常庞大。
- 把模块做成 monorepo 中的包，并接受 monorepo 工具带来的成本。
- 用 [dependency-cruiser](https://github.com/sverweij/dependency-cruiser) 这样的检查工具，禁止绕过接口的导入。

在这些机制中，Effect 最好，dependency-cruiser 次之。仓库的 `in-progress/` 分类下有 `setup-ts-deep-modules` 技能，规定了 `src/packages/<name>/index.ts` 约定，但它属于测试渠道，没有说明页，也不提供 lint 规则。

**让一个会话使用它之后，它消耗了 100k [token](https://www.aihero.dev/ai-coding-dictionary/token)，重新设计了根本没要求它处理的东西。**

这是已知问题，记录在[工单 #449](https://github.com/mattpocock/skills/issues/449)。这个技能可由模型调用，自称提供术语，但没有硬性停止机制阻止 agent 把它当作可执行流程。收到「resume in /codebase-design and drive the open decisions」的指示后，一个 agent 选择了技能中最接近流程的部分，即 `DESIGN-IT-TWICE.md` 中的并行子代理。它重新探索了前一个会话已经调查清楚的代码，工作了很久才提问。这个技能没有驱动流程的技能所具备的防护机制（检查点、一次一个问题、不自动推进），因为它是参考资料。临时解决方法是调用一个驱动流程的技能（`/grill-with-docs`、`/improve-codebase-architecture` 或 `/tdd`），让 `codebase-design` 只提供用语。该工单仍未关闭。

**`design-an-interface` 去哪里了？是否有 `/interface-design` 技能？**

这个技能替代了 `design-an-interface`，并接收了它的内容，没有缺失。它来自 Ousterhout 的「Design It Twice」技术，通过并行子代理生成根本不同的设计，作为 `DESIGN-IT-TWICE.md` 随此技能提供。另外，有多人希望为深模块、小接口的设计理念建立专门的 `/interface-design` 技能；这里已经覆盖该理念，没有另设技能的计划。如果是来找这两个名字中的任意一个，应该看的就是本页。

**这不就是文件结构约定，比如文件夹、barrel 文件或按功能切片吗？**

不是。这个观点多次受到质疑，技能并没有因此改变。[工单 #95](https://github.com/mattpocock/skills/issues/95) 提议用规范化的分形树文件结构来具体实现深模块；两者其实是独立的，相关说明原文是：「deep modules are about the design of the interface and accessing through a strict interface, no matter what the file system looks like. It seems perfectly possible that you could have shallow modules with this approach.」#458 中也出现了同样的问题，相关说明原文是：「I think you might be tying the concept of modules too closely to the file system. The file system can certainly be a useful hint to the shape of modules, but there's no need to use the file system in the construction of deep modules.」文件系统可以提示模块的形态，但不决定深度；术语表正是有意把**模块**定义为不受规模限制的概念。

**`tdd` 真的使用这些术语吗？**

现在使用，但很长一段时间并没有。v1.0 从 `tdd` 中删除了内联的深模块说明，改为使用这个共享技能，却没有补上替代说明所需的指针。因此，`tdd` 自行定义了「接缝」，也没有引用任何资料。现在 `tdd` 中已经有了指针；待解决的问题是接口形态而不是测试时，agent 会沿指针读取。`tdd` 仍负责作为*测试位置*的「接缝」；这个技能负责接缝后面的模块形态。

**「设计两次」模式在 Claude Code 之外也能使用吗？**

不能只凭通用技能元数据判断。`DESIGN-IT-TWICE.md` 当前要求并行派出至少 3 个子代理，但没有指定工具名。原 docs 引用的说明「spawn 3+ sub-agents in parallel using the Agent tool」提到了 Agent，这是 Claude Code 的[工具](https://www.aihero.dev/ai-coding-dictionary/tool)名；这段既有问题说明不等于当前文件要求使用同名工具。仓库也为包括 Codex 在内的其他[宿主](https://www.aihero.dev/ai-coding-dictionary/harness)提供元数据，但实际执行仍需核实宿主的并行子代理能力，不能据此认定流程已经适配。[工单 #564](https://github.com/mattpocock/skills/issues/564) 跟踪可移植性问题，原 docs 记录其尚未关闭；本轮未核实该工单的当前状态。

**可以把自己的概念加入术语表吗，比如 connascence、module secrets、[渐进披露](https://www.aihero.dev/ai-coding-dictionary/progressive-disclosure)？**

已经有人提出这些建议。[工单 #180](https://github.com/mattpocock/skills/issues/180) 加入 Parnas 的 module secrets 和 Page-Jones 的 connascence，作为一层命名体系，说明*什么*正在跨接缝泄漏，并附有可用的差异文件；[工单 #303](https://github.com/mattpocock/skills/issues/303) 提议在实现内部使用渐进披露，让公开接口具有深度的模块在内部也有结构。两者都尚未关闭，也未合并。现有术语表有意保持精简，技能本身说明了理由：目的就是统一用语；一个没人统一使用的术语，比没有这个术语更糟。

## It's working if

- 设计讨论不再使用「component」「service」「boundary」，而是使用「模块」「接口」「接缝」。
- 对于提议的模块提取，能明确判断它是否通过删除检验，而不是含糊其词。
- 提议一条接缝时，会指出第二个适配器是什么，而不只说第一个。
- 讨论接口时涵盖不变条件、顺序和错误模式，而不只是类型签名。
- 调用它不会启动一个会话。如果 agent 仅因 `/codebase-design` 就开始读取文件、提出重构，它就把参考资料误当成了驱动流程的技能。

## Where it fits

`codebase-design` 是**随时可用的独立技能**，也是工程技能底层的术语层，不是某条流程链中的步骤。它最接近的邻居是 [domain-modeling](https://aihero.dev/skills-domain-modeling)：两者提供并行的参考，后者针对*问题领域*的用语，而不是模块形态。通常会同时需要它们，因为给深模块起好名字需要兼顾两者。另一个邻居是 [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture)：它调查代码库中的深化候选对象，用本术语表描述每一个候选对象；它找到模块，再用这里的术语设计模块。不确定适合哪种技能或流程时，由 [ask-matt](https://aihero.dev/skills-ask-matt) 提供路由。
