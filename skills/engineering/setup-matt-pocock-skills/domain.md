# Domain Docs

工程技能在探索代码库时，应按以下规则读取本仓库的领域文档。

## Before exploring, read these

- 仓库根目录的 **`GLOSSARY.md`**，或者
- 仓库根目录的 **`GLOSSARY-MAP.md`**（若存在）：它指向每个上下文各自的 `GLOSSARY.md`。读取与当前主题相关的每个文件。
- **`docs/adr/`**：读取涉及即将开展工作的领域的架构决策记录（ADR）。在 multi-context 仓库中，还要检查 `src/<context>/docs/adr/` 中限定于该上下文的决策。

如果其中任何文件不存在，**直接继续，不作提示**。不要指出文件缺失，也不要建议预先创建。`/domain-modeling` 技能（通过 `/grill-with-docs` 和 `/improve-codebase-architecture` 使用）会在术语或决策真正确定时按需创建这些文件。

## File structure

single-context 仓库（大多数仓库）：

```
/
├── GLOSSARY.md
├── docs/adr/
│   ├── 0001-event-sourced-orders.md
│   └── 0002-postgres-for-write-model.md
└── src/
```

multi-context 仓库（根目录存在 `GLOSSARY-MAP.md`）：

```
/
├── GLOSSARY-MAP.md
├── docs/adr/                          ← 系统范围的决策
└── src/
    ├── ordering/
    │   ├── GLOSSARY.md
    │   └── docs/adr/                  ← 特定上下文的决策
    └── billing/
        ├── GLOSSARY.md
        └── docs/adr/
```

## Use the glossary's vocabulary

输出中提到领域概念时（例如工单标题、重构提案、假设或测试名称），使用 `GLOSSARY.md` 定义的术语。不要改用术语表明确要求避免的同义词。

如果所需概念尚未收录在术语表中，这就是一个信号：要么正在自创项目并不使用的说法（应重新考虑），要么确实存在缺口（记下并留给 `/domain-modeling` 处理）。

## Flag ADR conflicts

如果输出与已有 ADR 冲突，应明确指出，而不是悄悄覆盖原决策：

> _与 ADR-0007（事件溯源订单）冲突，但值得重新讨论，因为……_
