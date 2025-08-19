# 1.3 第一个 Aptos Move 程序

## 创建 Hello World 程序

让我们从最经典的 "Hello World" 程序开始，了解 Aptos Move 的基本语法结构。

### 项目结构

首先创建一个新的 Aptos Move 项目：

```bash
# 创建项目
mkdir 01-hello_blockchain
cd 01-hello_blockchain
aptos move init --name hello-blockchain  --template hello-blockchain
```
这将创建一个名为 `01-hello_blockchain` 的目录，包含以下结构：

```01-hello_blockchain/
├── Move.toml
├── .gitignore
├── sources
│   └── hello_blockchain.move
└── tests

### 查看第一个模块

在 `sources/` 目录下打开 `hello_blockchain.move` 文件：

```rust
module hello_blockchain::message {
    use std::error;
    use std::signer;
    use std::string;
    use aptos_framework::event;
    #[test_only]
    use std::debug;

    //:!:>resource
    struct MessageHolder has key {
        message: string::String,
    }
    //<:!:resource

    #[event]
    struct MessageChange has drop, store {
        account: address,
        from_message: string::String,
        to_message: string::String,
    }

    /// There is no message present
    const ENO_MESSAGE: u64 = 0;

    #[view]
    public fun get_message(addr: address): string::String acquires MessageHolder {
        assert!(exists<MessageHolder>(addr), error::not_found(ENO_MESSAGE));
        borrow_global<MessageHolder>(addr).message
    }

    public entry fun set_message(account: signer, message: string::String)
    acquires MessageHolder {
        let account_addr = signer::address_of(&account);
        if (!exists<MessageHolder>(account_addr)) {
            move_to(&account, MessageHolder {
                message,
            })
        } else {
            let old_message_holder = borrow_global_mut<MessageHolder>(account_addr);
            let from_message = old_message_holder.message;
            event::emit(MessageChange {
                account: account_addr,
                from_message,
                to_message: copy message,
            });
            old_message_holder.message = message;
        }
    }

    #[test(account = @0x1)]
    public entry fun sender_can_set_message(account: signer) acquires MessageHolder {
        let msg: string::String = string::utf8(b"Running test for sender_can_set_message...");
        debug::print(&msg);

        let addr = signer::address_of(&account);
        aptos_framework::account::create_account_for_test(addr);
        set_message(account, string::utf8(b"Hello, Blockchain"));

        assert!(
            get_message(addr) == string::utf8(b"Hello, Blockchain"),
            ENO_MESSAGE
        );
    }
}
```

### 代码解析

让我们逐行分析这个简单的 Move 程序：

#### 1. 模块声明
```rust
module hello_blockchain::message {
```
- `module`：关键字，声明这是一个模块
- `hello_blockchain::message`：模块的完整名称
  - `hello_blockchain`：地址（在 Move.toml 中定义）
  - `message`：模块名称

#### 2. 导入标准库
```rust
use std::error;
use std::signer;
use std::string;
use aptos_framework::event;
#[test_only]
use std::debug;
```
- `use`：导入关键字
- `std::error`：标准库中的错误处理模块
- `std::signer`：处理签名者的模块
- `std::string`：字符串处理模块
- `aptos_framework::event`：Aptos 框架中的事件模块
- `#[test_only]`：仅在测试环境中使用的模块

#### 3. 资源定义
```rust
struct MessageHolder has key {
    message: string::String,
}
//<:!:resource

#[event]
struct MessageChange has drop, store {
    account: address,
    from_message: string::String,
    to_message: string::String,
}
```
- `struct`：定义一个结构体
- `MessageHolder`：存储消息的资源
- `has key`：具有 Key 能力，用于全局存储
- `message: string::String`：消息内容

- `#[event]`：声明这是一个事件结构体
- `MessageChange`：事件结构体，记录消息变更
- `account: address`：事件触发的账户地址
- `from_message: string::String`：变更前的消息
- `to_message: string::String`：变更后的消息

#### 4. 常量定义
```rust
const ENO_MESSAGE: u64 = 0;
```
- `const`：声明一个常量
- `ENO_MESSAGE`：表示没有消息的错误代码

#### 5. 函数定义
```rust
#[view]
public fun get_message(addr: address): string::String acquires MessageHolder 

public entry fun set_message(account: signer, message: string::String)
acquires MessageHolder 
```
- `public`：访问修饰符，表示函数可以被其他模块调用
- `fun`：关键字，声明这是一个函数
- `get_message`：函数名
- `(addr: address)`：参数列表
- `: string::String`：返回类型
- `acquires MessageHolder`：声明函数需要获取 `MessageHolder` 资源
- `{}`：函数体

- `entry`: 表示这是一个入口函数，可以从链下调用
- `account: signer`：签名者账户
- `message: string::String`：要设置的消息内容
- `acquires MessageHolder`：同样声明需要获取 `MessageHolder` 资源

#### 6. 函数实现
```rust
assert!(exists<MessageHolder>(addr), error::not_found(ENO_MESSAGE));
borrow_global<MessageHolder>(addr).message
```
- `assert!`：断言函数，检查条件是否为真
- `exists<MessageHolder>(addr)`：检查地址是否存在 `MessageHolder` 资源
- `error::not_found(ENO_MESSAGE)`：如果不存在，抛出错误
- `borrow_global<MessageHolder>(addr).message`：获取并返回消息内容

```rust
if (!exists<MessageHolder>(account_addr)) {
    move_to(&account, MessageHolder {
        message,
    })
} else {
    let old_message_holder = borrow_global_mut<MessageHolder>(account_addr);
    let from_message = old_message_holder.message;
    event::emit(MessageChange {
        account: account_addr,
        from_message,
        to_message: copy message,
    });
    old_message_holder.message = message;
}
```
- `if (!exists<MessageHolder>(account_addr))`：检查是否存在 `MessageHolder`
- `move_to(&account, MessageHolder { message })`：如果不存在，创建新的 `MessageHolder`
- `else` 分支：如果存在，获取现有的 `MessageHolder`
- `event::emit(MessageChange { ... })`：触发消息变更事件
- `old_message_holder.message = message`：更新消息内容
#### 7. 测试函数
```rust
#[test(account = @0x1)]
public entry fun sender_can_set_message(account: signer) acquires MessageHolder {
    let msg: string::String = string::utf8(b"Running test for sender_can_set_message...");
    debug::print(&msg);
    let addr = signer::address_of(&account);
    aptos_framework::account::create_account_for_test(addr);
    set_message(account, string::utf8(b"Hello, Blockchain"));
    assert!(
        get_message(addr) == string::utf8(b"Hello, Blockchain"),
        ENO_MESSAGE
    );
}
```
- `#[test(account = @0x1)]`：声明这是一个测试函数，并指定测试账户地址
- `public entry fun sender_can_set_message(account: signer)`：
- `let msg: string::String = string::utf8(b"Running test for sender_can_set_message...");`：创建测试消息
- `debug::print(&msg);`：打印调试信息
- `let addr = signer::address_of(&account);`：获取签名者地址
- `aptos_framework::account::create_account_for_test(addr);`：为测试创建账户
- `set_message(account, string::utf8(b"Hello, Blockchain"));`：设置消息
- `assert!(get_message(addr) == string::utf8(b"Hello, Blockchain"), ENO_MESSAGE);`：断言消息设置成功

### 编译和运行

#### 1. 编译项目
```bash
aptos move build --named-addresses hello_blockchain=0x1234
```

#### 2. 运行测试
```bash
aptos move test --named-addresses hello_blockchain=0x1234
```

## Move 语法要点

### 1. 注释
```rust
// 单行注释
/// 文档注释
/* 多行注释 */
```

### 2. 变量声明
```rust
let x = 10;           // 类型推断
let y: u64 = 20;      // 显式类型声明
```

### 3. 条件语句
```rust
if (condition) {
    // 代码块
} else {
    // 代码块
}
```

### 4. 循环
```rust
while (condition) {
    // 循环体
}
```

### 5. 函数调用
```rust
module_name::function_name(arg1, arg2);
```

### 6. 断言
```rust
assert!(condition, error_code);
```

## 常见错误和调试

### 调试技巧
- 使用 `debug::print()` 输出调试信息
- 在测试中使用 `assert!()` 验证结果

## 小结

通过这个简单的 Hello World 程序，我们学习了：

1. **模块结构**：如何声明和组织模块
2. **函数定义**：如何定义和调用函数
3. **测试编写**：如何为代码编写测试
4. **调试技巧**：如何使用调试输出


---

**下一节**：[2.1 Module 概念与结构](../02-modules/01-module-basics.md) 