# 2.1 Module 概念与结构

## 什么是 Module？

在 Move 中，**Module（模块）** 是代码组织的基本单位。模块类似于其他编程语言中的类或包，它封装了相关的函数、结构体和常量。

### Module 的核心概念

#### 1. 命名空间
```rust
module my_addr::math {
    // 模块内容
}
```
- `my_addr`：地址（Address），类似于包名
- `math`：模块名
- `my_addr::math`：完整的模块标识符

#### 2. 封装性
- 模块内的代码可以访问模块内的所有内容
- 其他模块只能访问被标记为 `public` 的内容
- 提供了良好的封装和抽象

#### 3. 可重用性
- 模块可以被其他模块导入和使用
- 支持模块的组合和扩展

## Module 的基本结构

### 完整的模块示例

```rust
module my_addr::bank {
    use std::signer;
    use std::debug;
    
    // 错误码常量
    const EINSUFFICIENT_BALANCE: u64 = 1;
    const EINVALID_AMOUNT: u64 = 2;
    
    // 结构体定义
    struct Account has key {
        balance: u64,
        owner: address,
    }
    
    // 事件结构体
    #[event]
    struct DepositEvent has drop, store {
        account: address,
        amount: u64,
    }
    
    // 公共函数
    public fun create_account(account: &signer) {
        let account_addr = signer::address_of(account);
        move_to(account, Account {
            balance: 0,
            owner: account_addr,
        });
        debug::print(&b"Account created for: ");
        debug::print(&account_addr);
    }
    
    // 公共函数
    public fun deposit(account: &signer, amount: u64) acquires Account {
        assert!(amount > 0, EINVALID_AMOUNT);
        
        let account_addr = signer::address_of(account);
        let account_ref = &mut Account[account_addr];
        account_ref.balance += amount;
        
        debug::print(&b"Deposited: ");
        debug::print(&amount);
    }
    
    // 公共函数
    public fun withdraw(account: &signer, amount: u64): u64 acquires Account {
        assert!(amount > 0, EINVALID_AMOUNT);
        
        let account_addr = signer::address_of(account);
        let account_ref = &mut Account[account_addr];
        
        assert!(account_ref.balance >= amount, EINSUFFICIENT_BALANCE);
        account_ref.balance -= amount;
        
        debug::print(&b"Withdrawn: ");
        debug::print(&amount);
        amount
    }
    
    // 公共函数
    public fun get_balance(account_addr: address): u64 acquires Account{
        let account = &Account[account_addr];
        account.balance
    }
    
    // 私有函数（只能在模块内部调用）
    fun validate_amount(amount: u64): bool {
        amount > 0
    }
}
```

## Module 的组成部分

### 1. 模块声明
```rust
module <address>::<module_name> {
    // 模块内容
}
```

### 2. 导入语句
```rust
use std::signer;      // 导入标准库模块
use my_addr::math;    // 导入自定义模块
```

### 3. 常量定义

常量定义只能定义基础类型变量

const `<name>: <type> = <value>;`

```rust
const ERROR_CODE: u64 = 1;
const MAX_BALANCE: u64 = 1000000;
```

### 4. 结构体定义
```rust
struct MyStruct has key, store {
    field1: u64,
    field2: vector<u8>,
}
```

### 5. 函数定义
```rust
public fun public_function() {
    // 公共函数
}

fun private_function() {
    // 私有函数
}
```

## Module 的访问控制

### 访问修饰符

#### 1. public
```rust
public fun public_function() {
    // 可以被其他模块调用
}
```

#### 2. 默认（私有）
```rust
fun private_function() {
    // 只能在模块内部调用
}
```

#### 3. public(friend)

需要在模块声明中指定友元模块

```rust
public(friend) fun friend_function() {
    // 只能被友元模块调用
}
```

#### 4. public(package)

无需声明 Friend 模块，当前包内可以直接访问

```
public (package) fun package_function() {
    // 只能被同一包内的模块调用
}
```

### 访问控制示例

```rust
module my_addr::access_control {
    use std::debug;
    
    // 友元模块
    friend my_addr::other_module;
    
    // 公共函数 - 任何模块都可以调用
    public fun public_function() {
        debug::print(&b"This is public");
    }
    
    // 私有函数 - 只能在模块内部调用
    fun private_function() {
        debug::print(&b"This is private");
    }
    
    // 公共函数调用私有函数
    public fun call_private() {
        private_function(); // 可以调用私有函数
    }

    // 友元函数 - 只能被指定模块调用
    public(friend) fun friend_function() {
        debug::print(&b"This is a friend function");
    }

    // 包内函数 - 只能被同一包内的模块调用
    public(package) fun package_function() {
        debug::print(&b"This is a package function");
    }
}

// 另一个模块
module my_addr::other_module {
    use my_addr::access_control;
    
    fun test_access() {
        access_control::public_function(); // ✅ 可以调用
        // access_control::private_function(); // ❌ 不能调用私有函数
        access_control::call_private(); // ✅ 可以调用
    }
}
```

## Module 的组织原则

### 1. 单一职责原则

每个模块应该只负责一个特定的功能领域

```rust
// ✅ 好的设计
module my_addr::math {
    // 数学运算相关
}

module my_addr::string_utils {
    // 字符串处理相关
}

// ❌ 不好的设计
module my_addr::everything {
    // 混合了多种功能
}
```

### 2. 高内聚，低耦合

模块内部的功能应该紧密相关，模块之间的依赖应该尽量减少

```rust
// 高内聚的模块设计
module my_addr::user_management {
    struct User has key, store {
        id: u64,
        name: vector<u8>,
        email: vector<u8>,
    }
    
    public fun create_user(account: &signer, name: vector<u8>, email: vector<u8>) {
        // 用户创建逻辑
    }
    
    public fun update_user(account: &signer, name: vector<u8>) {
        // 用户更新逻辑
    }
    
    public fun delete_user(account: &signer) {
        // 用户删除逻辑
    }
}
```

### 3. 模块依赖管理

使用 `use` 语句导入其他模块

```rust
// 基础模块
module my_addr::math {
    public fun add(a: u64, b: u64): u64 { a + b }
    public fun subtract(a: u64, b: u64): u64 { a - b }
}

// 依赖基础模块的高级模块
module my_addr::calculator {
    use my_addr::math;
    
    public fun calculate(a: u64, b: u64, operation: u8): u64 {
        if (operation == 1) {
            math::add(a, b)
        } else {
            math::subtract(a, b)
        }
    }
}
```

## 模块设计模式

### 1. 工具模块模式

只使用当前函数，不需要状态或存储

```rust
module my_addr::utils {
    use std::vector;
    
    public fun find_max(numbers: vector<u64>): u64 {
        let max = 0;
        let i = 0;
        let len = vector::length(&numbers);
        
        while (i < len) {
            let current = *vector::borrow(&numbers, i);
            if (current > max) {
                max = current;
            };
            i = i + 1;
        };
        max
    }
    
    public fun reverse_string(s: vector<u8>): vector<u8> {
        let result = vector::empty<u8>();
        let i = vector::length(&s);
        
        while (i > 0) {
            i = i - 1;
            vector::push_back(&mut result, *vector::borrow(&s, i));
        };
        result
    }
}
```

### 2. 服务模块模式

提供状态和存储，通常用于管理复杂的业务逻辑

```rust
module my_addr::voting_service {
    use std::signer;
    use std::vector;
    
    struct Vote has key, store {
        proposal_id: u64,
        voter: address,
        choice: bool,
    }
    
    struct Proposal has key, store {
        id: u64,
        title: vector<u8>,
        description: vector<u8>,
        yes_votes: u64,
        no_votes: u64,
        is_active: bool,
    }
    
    public fun create_proposal(
        account: &signer,
        title: vector<u8>,
        description: vector<u8>
    ) {
        // 创建提案逻辑
    }
    
    public fun vote(
        account: &signer,
        proposal_id: u64,
        choice: bool
    ) {
        // 投票逻辑
    }
    
    public fun get_proposal_result(proposal_id: u64): (u64, u64) {
        // 获取投票结果
        (0, 0) // 占位符
    }
}
```

## 最佳实践

### 1. 命名规范
```rust
// ✅ 好的命名
module my_addr::user_management { }
module my_addr::token_contract { }
module my_addr::voting_system { }

// ❌ 不好的命名
module my_addr::user { }
module my_addr::token { }
module my_addr::vote { }
```

### 2. 文档注释

vscode 插件可以读取模块中的文档注释

```rust
module my_addr::math_utils {

    /// 计算两个数的最大公约数
    /// @param a 第一个数
    /// @param b 第二个数
    /// @return 最大公约数
    public fun gcd(a: u64, b: u64): u64 {
        if (b == 0) {
            a
        } else {
            gcd(b, a % b)
        }
    }
}
```

### 3. 错误处理

使用 `assert!()` 进行错误处理 或者 使用 abort 的方式

```rust
module my_addr::safe_math {
    const EOVERFLOW: u64 = 1;
    const EINVALID_INPUT: u64 = 2;
    
    public fun safe_add(a: u64, b: u64): u64 {
        assert!(a <= 0xFFFFFFFFFFFFFFFF - b, EOVERFLOW);
        a + b
    }

    public fun safe_div(a: u64, b: u64): u64 {
        if (a == 0) {
            abort EINVALID_INPUT;
        }
        a / b
    }
}
```

## 小结

通过本章的学习，我们了解了：

1. **Module 的概念**：Move 中代码组织的基本单位
2. **Module 的结构**：声明、导入、常量、结构体、函数
3. **访问控制**：public、private、friend、package 访问修饰符
4. **最佳实践**：命名、文档、错误处理

Module 是 Move 编程的基础，掌握好模块的设计和组织，将为后续学习更复杂的 Move 概念打下坚实基础。

---

**下一节**：[3.1 data-types](../03-data-types/01-basic-types.md) 