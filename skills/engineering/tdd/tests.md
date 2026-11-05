# 好测试与差测试

## 好测试

**集成式测试**：通过真实接口测试，而非 mock 内部组件。

```typescript
// 好：测试可观察的行为
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

特点：

- 测试用户／调用方关心的行为
- 只使用公开 API
- 能够经受内部重构
- 描述做了什么，而非如何做到
- 每个测试包含一个逻辑断言

## 差测试

**测试实现细节**：与内部结构耦合。

```typescript
// 差：测试实现细节
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

警示信号：

- mock 内部协作者
- 测试私有方法
- 对调用次数／顺序作断言
- 重构未改变行为，测试却失败
- 测试名称描述如何做到，而非做了什么
- 通过接口之外的手段验证，而非使用接口

```typescript
// 差：绕过接口验证
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// 好：通过接口验证
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

**同义反复的测试**：期望值重复了实现逻辑，因此测试在构造上必然通过。

```typescript
// 差：以与代码相同的方式重新计算期望值
test("calculateTotal sums line items", () => {
  const items = [{ price: 10 }, { price: 5 }];
  const expected = items.reduce((sum, i) => sum + i.price, 0);
  expect(calculateTotal(items)).toBe(expected);
});

// 好：期望值是独立的、已知正确的字面量
test("calculateTotal sums line items", () => {
  expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
});
```
