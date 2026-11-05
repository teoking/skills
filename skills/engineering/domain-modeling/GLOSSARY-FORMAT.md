# GLOSSARY.md 格式

## 结构

```md
# {Context Name}

{One or two sentence description of what this context is and why it exists.}

## Language

**Order**:
{A one or two sentence description of the term}
_Avoid_: Purchase, transaction

**Invoice**:
交付后发送给客户的付款请求。
_Avoid_: Bill, payment request

**Customer**:
下订单的个人或组织。
_Avoid_: Client, buyer, account
```

`{Context Name}` 填写上下文名称；其后用一两句话说明该上下文是什么、为什么存在。每个术语的定义也用一两句话。

## 规则

- **明确取舍。**同一概念有多个用词时，选择最合适的一个，并在 `_Avoid_` 下列出其他用词。
- **保持定义紧凑。**最多一两句话。定义它是什么，而不是它做什么。
- **只收录本项目上下文特有的术语。**通用编程概念（超时、错误类型、通用辅助代码模式）不应收录，即使项目大量使用了它们。添加术语之前，先问：这是该上下文特有的概念，还是通用编程概念？只收录前者。
- 当术语自然形成不同分组时，**用子标题分组**。如果所有术语都属于同一个紧密关联的领域，平铺列表即可。

## 单上下文与多上下文（multi-context）仓库

**单上下文（大多数仓库）：**仓库根目录只有一个 `GLOSSARY.md`。

**多上下文：**仓库根目录的 `GLOSSARY-MAP.md` 列出各个上下文、它们的位置以及相互关系：

```md
# Glossary Map

## Contexts

- [Ordering](./src/ordering/GLOSSARY.md): 接收并跟踪客户订单
- [Billing](./src/billing/GLOSSARY.md): 生成发票并处理付款
- [Fulfillment](./src/fulfillment/GLOSSARY.md): 管理仓库拣货与发运

## Relationships

- **Ordering → Fulfillment**: Ordering 发出 `OrderPlaced` 事件；Fulfillment 消费这些事件以开始拣货
- **Fulfillment → Billing**: Fulfillment 发出 `ShipmentDispatched` 事件；Billing 消费这些事件以生成发票
- **Ordering ↔ Billing**: 共享 `CustomerId` 和 `Money` 类型
```

技能根据现有文件判断应采用哪种结构：

- 如果存在 `GLOSSARY-MAP.md`，读取它以查找各个上下文。
- 如果只有根目录的 `GLOSSARY.md`，则采用单上下文结构。
- 如果两者都不存在，在第一个术语确定时，按需创建根目录的 `GLOSSARY.md`。

存在多个上下文时，判断当前话题属于哪一个。如果不明确，就提问。
