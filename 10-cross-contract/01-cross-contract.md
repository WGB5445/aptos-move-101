# 10.1 跨合约导入与调用

## Move 跨模块/合约调用基础

### 导入其他模块
```rust
module my_addr::import_example {
    use 0x1::coin;
    // ...示例代码...
}
```

### 跨模块调用函数
```rust
module my_addr::call_example {
    use 0x1::coin;
    public fun call_coin(): u64 {
        coin::balance_of(@0x1)
    }
}
```

## 跨合约调用的注意事项
- 访问控制
- 能力（abilities）
- 依赖管理

## 小结
跨合约调用是 Move 合约协作的基础。
