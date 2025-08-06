# 9.1 枚举类型（Enum）

## Move 的枚举实现

Move 没有原生 enum，但可以用 sum type（联合体）模式实现。

### 枚举的定义与使用
```move
module my_addr::enum_example {
    struct MyEnum has copy, drop, store {
        tag: u8, // 0: A, 1: B
        value_a: u64,
        value_b: bool,
    }
    // ...示例代码...
}
```

## 枚举的常见用法
- 状态机
- 错误码
- 事件类型

## 小结
枚举模式让 Move 代码更具表达力。
