# 3.1 基本数据类型

## Move 的基本数据类型

Move 是一种静态类型语言，所有变量和表达式都有明确的类型。了解基本数据类型是编写 Move 程序的基础。

## 整数类型

### 无符号整数

Move 提供了多种无符号整数类型，用于表示不同范围的整数值：

```move
module my_addr::integer_types {
    use std::debug;
    
    #[test]
    public fun demonstrate_integers() {
        // u8: 8位无符号整数 (0 到 255)
        let small_number: u8 = 255;
        debug::print(&small_number);
        
        // u16: 16位无符号整数 (0 到 65535)
        let medium_number: u16 = 65535;
        debug::print(&medium_number);
        
        // u32: 32位无符号整数 (0 到 4,294,967,295)
        let large_number: u32 = 4294967295;
        debug::print(&large_number);
        
        // u64: 64位无符号整数 (0 到 18,446,744,073,709,551,615)
        let huge_number: u64 = 18446744073709551615;
        debug::print(&huge_number);
        
        // u128: 128位无符号整数
        let massive_number: u128 = 340282366920938463463374607431768211455;
        debug::print(&massive_number);
        
        // u256: 256位无符号整数
        let enormous_number: u256 = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
        debug::print(&enormous_number);
    }
    
    // 整数运算示例
    #[test]
    public fun arithmetic_operations() {
        let a: u64 = 10;
        let b: u64 = 3;
        
        // 加法
        let sum = a + b;
        debug::print(&sum); // 13
        assert!(sum == 13, 100);
        
        // 减法
        let difference = a - b;
        debug::print(&difference); // 7
        assert!(difference == 7, 101);
        
        // 乘法
        let product = a * b;
        debug::print(&product); // 30
        assert!(product == 30, 102);
        
        // 除法（整数除法）
        let quotient = a / b;
        debug::print(&quotient); // 3
        assert!(quotient == 3, 103);
        
        // 取余
        let remainder = a % b;
        debug::print(&remainder); // 1
        assert!(remainder == 1, 104);
    }
    
    // 整数比较
    #[test]
    public fun comparison_operations() {
        let a: u64 = 10;
        let b: u64 = 5;
        
        let is_equal = a == b;        // false
        let is_not_equal = a != b;    // true
        let is_greater = a > b;       // true
        let is_less = a < b;          // false
        let is_greater_equal = a >= b; // true
        let is_less_equal = a <= b;   // false

        debug::print(&is_equal);
        debug::print(&is_not_equal);
        debug::print(&is_greater);
        debug::print(&is_less);
        debug::print(&is_greater_equal);
        debug::print(&is_less_equal);

        assert!(is_equal == false, 200);
        assert!(is_not_equal == true, 201);
        assert!(is_greater == true, 202);
        assert!(is_less == false, 203);
        assert!(is_greater_equal == true, 204);
        assert!(is_less_equal == false, 205);
    }
}
```

### 整数类型选择指南

| 类型 | 范围 | 用途 |
|------|------|------|
| `u8` | 0-255 | 小数值、状态标志 |
| `u16` | 0-65535 | 中等数值 |
| `u32` | 0-4,294,967,295 | 一般用途 |
| `u64` | 0-18,446,744,073,709,551,615 | **推荐使用** |
| `u128` | 极大数值 | 金融计算、大数运算 |
| `u256` | 极大数值 | 密码学、精确计算 |

## 布尔类型

布尔类型用于表示逻辑值：

```move
module my_addr::boolean_types {
    use std::debug;
    
    #[test]
    public fun demonstrate_booleans() {
        // 布尔字面量
        let true_value: bool = true;
        let false_value: bool = false;
        debug::print(&true_value);
        debug::print(&false_value);
        assert!(true_value == true, 300);
        assert!(false_value == false, 301);

        // 布尔运算
        let a = true;
        let b = false;

        let and_result = a && b;  // false
        let or_result = a || b;   // true
        let not_result = !a;      // false
        debug::print(&and_result);
        debug::print(&or_result);
        debug::print(&not_result);
        assert!(and_result == false, 302);
        assert!(or_result == true, 303);
        assert!(not_result == false, 304);

        // 条件表达式
        let condition = 10 > 5;
        let result = if (condition) { true } else { false };
        debug::print(&result);
        assert!(result == true, 305);
    }
    
    // 布尔函数示例
    public fun is_even(number: u64): bool {
        number % 2 == 0
    }
    
    public fun is_positive(number: u64): bool {
        number > 0
    }
    
    public fun is_in_range(value: u64, min: u64, max: u64): bool {
        value >= min && value <= max
    }
}
```

## 地址类型

地址类型用于表示区块链上的账户地址：

```move
module my_addr::address_types {
    use std::debug;
    use std::signer;
    
    #[test(account = @0x1234)]
    public fun demonstrate_addresses(account: &signer) {
        // 获取签名者地址
        let account_addr = signer::address_of(account);
        debug::print(&account_addr);
        assert!(account_addr == @0x1234, 400);

        // 地址字面量
        let my_address: address = @0x1234;
        let std_address: address = @0x1;
        debug::print(&my_address);
        debug::print(&std_address);
        assert!(my_address == @0x1234, 401);
        assert!(std_address == @0x1, 402);

        // 地址比较
        let is_my_address = account_addr == my_address;
        debug::print(&is_my_address);
        assert!(is_my_address == true, 403);
    }
    
    // 地址验证函数
    public fun is_valid_address(addr: address): bool {
        // 检查地址是否为零地址
        addr != @0x0
    }
    
    public fun is_my_address(addr: address): bool {
        addr == @0x1234
    }
}
```

## 向量类型

向量是 Move 中的动态数组：

```move
module my_addr::vector_types {
    use std::debug;
    use std::vector;
    
    #[test]
    public fun demonstrate_vectors() {
        // 创建空向量
        let empty_vector: vector<u64> = vector::empty<u64>();
        assert!(empty_vector.length() == 0, 500);

        // 创建带初始值的向量
        let numbers: vector<u64> = vector[1, 2, 3, 4, 5];
        assert!(numbers.length() == 5, 501);

        // 添加元素
        numbers.push_back(6);
        assert!(numbers.length() == 6, 502);

        // 获取向量长度
        let length = numbers.length();
        debug::print(&length); // 6
        assert!(length == 6, 503);

        // 访问元素
        let first = numbers[0];
        let last = numbers[length - 1];
        debug::print(&first); // 1
        debug::print(&last);  // 6
        assert!(first == 1, 504);
        assert!(last == 6, 505);

        // 修改元素
        let mut_ref = numbers.borrow_mut(0);
        *mut_ref = 10;
        assert!(numbers[0] == 10, 506);

        // 删除元素
        let removed = numbers.pop_back();
        debug::print(&removed); // 6
        assert!(removed == 6, 507);
        assert!(numbers.length() == 5, 508);

        // 检查向量是否为空
        let is_empty = numbers.is_empty();
        debug::print(&is_empty); // false
        assert!(is_empty == false, 509);

        // 反转向量
        numbers.reverse();
        debug::print(&numbers); // [5, 4, 3, 2, 10]
        assert!(numbers == vector[5, 4, 3, 2, 10], 510);

        // 过滤向量
        let filtered_numbers = numbers.filter(|x| *x > 2);
        debug::print(&filtered_numbers); // [5, 4, 3, 10]
        assert!(filtered_numbers == vector[5, 4, 3, 10], 511);

        // 映射向量
        let mapped_numbers = numbers.map(|x| x * 2);
        debug::print(&mapped_numbers); // [10, 8, 6, 4, 20]
        assert!(mapped_numbers == vector[10, 8, 6, 4, 20], 512);

        // 折叠向量
        let sum = numbers.fold(0, |acc, x| acc + x);
        debug::print(&sum); // 24
        assert!(sum == 24, 513);

    }
}
```

## 字节向量（字符串）

在 Move 中，字符串实际上是字节向量：

```move
module my_addr::string_types {
    use std::debug;
    use std::string;
    
    #[test]
    public fun demonstrate_strings() {
        // 使用 std::string 处理字符串
        let hello = string::utf8(b"Hello, Move!");
        let empty = string::utf8(b"");
        debug::print(&hello);
        debug::print(&empty);
        assert!(hello.length() == 12, 600);
        assert!(empty.length() == 0, 601);

        // 字符串长度
        let length = hello.length();
        debug::print(&length); // 12
        assert!(length == 12, 602);

        // 子字符串查找
        let move_str = string::utf8(b"Move");
        let move_index = hello.index_of(&move_str);
        debug::print(&move_index); // 7
        assert!(move_index == 7, 603);

        // 字符串连接
        let hello_str = string::utf8(b" Hello");
        hello_str.append_utf8(b" World!");
        debug::print(&hello_str); // "Hello World!"
        assert!(hello_str == string::utf8(b" Hello World!"), 604);
    }
}
```

## 类型转换

Move 是强类型语言，但支持一些隐式和显式类型转换：

```move
module my_addr::type_conversion {
    use std::debug;
    
    #[test]
    public fun demonstrate_conversions() {
        // 显式转换（小类型到大类型）
        let small: u8 = 255;

        let medium: u16 = (small as u16);  // u8 -> u16
        let large: u32 = (medium as u32);  // u16 -> u32
        let huge: u64 = (large as u64);    // u32 -> u64

        assert!(medium == 255, 700);
        assert!(large == 255, 701);
        assert!(huge == 255, 702);

        // 显式转换（大类型到小类型）
        let big_number: u64 = 255;
        let small_number: u8 = (big_number as u8);
        debug::print(&small_number); // 255
        assert!(small_number == 255, 703);
    }

    #[test]
    #[expected_failure]
    fun error_handling() {
        // 尝试将一个大类型转换为小类型，Move 会报错
        let large_value: u64 = 300;
        let small_value: u8 = (large_value as u8); // 在此处发生错误
        debug::print(&small_value); // 44
    }
}
```

## 类型推断

Move 支持类型推断，编译器可以自动推断变量类型：

```move
module my_addr::type_inference {
    use std::debug;
    
    public fun demonstrate_inference() {
        // 类型推断
        let number = 42;           // 推断为 u64
        let flag = true;           // 推断为 bool
        let text = b"Hello";       // 推断为 vector<u8>
        let list = vector[1, 2, 3]; // 推断为 vector<u64>
        
        // 显式类型声明
        let explicit_number: u64 = 42;
        let explicit_flag: bool = true;
        
        debug::print(&number);
        debug::print(&flag);
        debug::print(&text);
        debug::print(&list);
    }
}
```

## 常见错误和最佳实践

### 1. 整数溢出和下溢
Move 会在运行时检查整数溢出和下溢，如果发生会自动 abort：

```move
module my_addr::overflow_example {
    use std::debug;
    
    #[test]
    public fun test_normal_operations() {
        // 正常的运算不会溢出
        let a: u64 = 100;
        let b: u64 = 200;
        let sum = a + b;
        debug::print(&sum); // 300
        assert!(sum == 300, 100);
        
        let product = a * b;
        debug::print(&product); // 20000
        assert!(product == 20000, 101);
    }
    
    #[test]
    #[expected_failure] // 预期这个测试会失败
    public fun test_overflow() {
        // 这会导致溢出，Move 会自动 abort
        let max_val: u64 = 18446744073709551615; // u64 最大值
        let _overflow = max_val + 1; // 溢出，程序会 abort
    }
    
    #[test]
    #[expected_failure] // 预期这个测试会失败
    public fun test_underflow() {
        // 这会导致下溢，Move 会自动 abort
        let zero: u64 = 0;
        let _underflow = zero - 1; // 下溢，程序会 abort
    }
    
    #[test]
    #[expected_failure] // 预期这个测试会失败
    public fun test_division_by_zero() {
        // 除零错误，Move 会自动 abort
        let a: u64 = 10;
        let _result = a / 0; // 除零，程序会 abort
    }
}
```

### 2. 类型选择指南
```move
module my_addr::type_guidelines {
    // ✅ 推荐：使用 u64 作为默认整数类型
    public fun calculate_total(items: vector<u64>): u64 {
        // 实现
        0
    }
    
    // ✅ 推荐：使用 vector<u8> 表示字符串
    public fun process_name(name: vector<u8>): vector<u8> {
        // 实现
        name
    }
    
    // ✅ 推荐：使用 bool 表示状态
    public fun is_valid(value: u64): bool {
        value > 0
    }
}
```
## 小结

通过本章的学习，我们掌握了：

1. **整数类型**：u8, u16, u32, u64, u128, u256 的使用和选择
2. **布尔类型**：逻辑运算和条件判断
3. **地址类型**：区块链地址的表示和操作
4. **向量类型**：动态数组的创建和操作
5. **字符串类型**：字节向量的字符串处理
6. **类型转换**：安全和不安全的类型转换
7. **类型推断**：让编译器自动推断类型
8. **最佳实践**：避免溢出、选择合适的类型

这些基本数据类型是 Move 编程的基础，掌握它们将帮助我们更好地理解和编写 Move 程序。

---

**下一节**：[3.2 结构体 (Struct)](./02-structs.md) 