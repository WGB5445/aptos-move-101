# 3.3 引用和可变引用

## 引用概述

在 Move 语言中，引用（References）是一种强大的工具，允许我们在不获取值的所有权的情况下访问和操作数据。引用提供了安全的内存访问机制，防止悬空指针和数据竞争。

在前面的教程中，你也应该也看到了 `&` 和 `&mut` 的用法，这就是不可变引用和可变引用

### 🔗 引用的类型

Move 语言支持两种类型的引用：

1. **不可变引用** (`&T`) - 只读访问
2. **可变引用** (`&mut T`) - 读写访问

## 不可变引用 (&T)

不可变引用允许你只读访问数据，不能修改被引用的值。

### 基本语法

```rust
let ref = &value;           // 创建不可变引用
let field_ref = &obj.field; // 字段引用
```

### 示例代码

```rust
#[test]
public fun test_immutable_references() {
    let number = 42;
    let number_ref = &number;  // 创建不可变引用
    
    // 通过解引用访问值
    assert!(*number_ref == 42, 100);
    
    // number_ref 是只读的，不能修改
    // *number_ref = 50; // 这会导致编译错误
}
```

## 可变引用 (&mut T)

可变引用允许你读取和修改被引用的数据。

### 基本语法

```move
let mut_ref = &mut value;           // 创建可变引用
let field_mut_ref = &mut obj.field; // 字段可变引用
```

### 示例代码

```rust
#[test]
public fun test_mutable_references() {
    let number = 42;
    let number_mut_ref = &mut number;  // 创建可变引用
    
    // 读取值
    assert!(*number_mut_ref == 42, 200);
    
    // 修改值
    *number_mut_ref = 100;
    assert!(*number_mut_ref == 100, 201);
}
```

## 结构体字段引用

可以创建指向结构体特定字段的引用。

### 字段不可变引用

```rust
public fun get_name(person: &Person): &String {
    &person.name  // 返回字段的不可变引用
}
```

### 字段可变引用

```rust
public fun update_age(person: &mut Person, new_age: u8) {
    person.age = new_age;  // 直接修改字段
    // 或使用引用
    let age_ref = &mut person.age;
    *age_ref = new_age;
}
```

## 引用规则和限制

### 1. 借用规则

Move 遵循严格的借用规则，确保内存安全：

- **规则1**：在任何给定时间，对于任何值，要么有一个可变引用，要么有多个不可变引用
- **规则2**：引用必须始终有效（不能悬空）

### 2. 生命周期

```rust
public fun reference_lifetime_example() {
    let number = 42;
    let ref1 = &number;      // 创建不可变引用
    let ref2 = &number;      // 可以有多个不可变引用
    
    // let mut_ref = &mut number; // 错误！不能同时有可变和不可变引用
    
    assert!(*ref1 == 42, 300);
    assert!(*ref2 == 42, 301);
}
```

### 3. 可变性传播

```rust
struct SomeStruct has key, store {
    field: u64,
}

public fun mutability_propagation(data: &mut SomeStruct, new_value: u64) {
    let field_ref = &mut data.field;  // 继承可变性
    *field_ref = new_value;
}
```

## 函数参数中的引用

### 传递引用

```rust
// 接受不可变引用
public fun read_only_function(data: &SomeStruct): u64 {
    data.some_field
}

// 接受可变引用
public fun modify_function(data: &mut SomeStruct) {
    data.some_field = 100;
}
```

### 返回引用

```rust
// 返回不可变引用
public fun get_field_ref(data: &SomeStruct): &u64 {
    &data.some_field
}

// 返回可变引用
public fun get_field_mut_ref(data: &mut SomeStruct): &mut u64 {
    &mut data.some_field
}
```

## 引用和所有权

### 移动 vs 借用

```rust
public fun ownership_vs_borrowing() {
    let data = SomeStruct { field: 42 };
    
    // 移动所有权
    let owned = data;  // data 不再可用
    
    // 借用（创建引用）
    let data2 = SomeStruct { field: 100 };
    let borrowed = &data2;  // data2 仍然可用
    
    // 可以继续使用 data2
    let field_value = data2.field;
}
```

### 借用检查器

Move 的借用检查器在编译时验证所有引用使用的安全性：

```rust
public fun borrow_checker_example() {
    let value = 42;
    let ref1 = &value;
    
    // 这是安全的
    let ref2 = &value;
    assert!(*ref1 == *ref2, 400);
    
    // 创建可变引用会结束所有不可变引用的生命周期
    let mut_ref = &mut value;
    *mut_ref = 100;
    
    // ref1 和 ref2 在这里不再有效
}
```

## 实际应用示例

### 1. 数据验证

```rust
public fun validate_person(person: &Person): bool {
    person.age > 0 && !person.name.is_empty()
}
```

### 2. 条件修改

```rust
public fun conditional_update(person: &mut Person, condition: bool) {
    if (condition) {
        person.age = person.age + 1;
    }
}
```

### 3. 嵌套结构体访问

```rust
public fun access_nested_field(company: &Company): &String {
    &company.ceo.person.name
}

public fun update_nested_field(company: &mut Company, new_name: String) {
    company.ceo.person.name = new_name;
}
```

## 常见模式

### 1. 可选字段处理

```rust
public fun process_optional_field(data: &SomeStruct) {
    if (data.optional_field.is_some()) {
        let value = & data.optional_field;
        // 处理值
    }
}
```

### 2. 引用链

```rust
public fun reference_chain(data: &mut ComplexStruct) {
    let level1 = &mut data.level1;
    let level2 = &mut level1.level2;
    let level3 = &mut level2.level3;
    
    *level3 = new_value;
}
```

### 3. 临时引用

```rust
public fun temporary_reference(data: &mut SomeStruct) {
    {
        let temp_ref = &mut data.field;
        *temp_ref = compute_new_value();
    }  // temp_ref 的生命周期在这里结束
    
    // 可以创建新的引用
    let another_ref = &data.field;
}
```

## 性能考虑

### 引用的优势

1. **节省 Gas** - 引用在运行时开销较少，gas 较低
2. **避免复制** - 大型数据结构不需要复制


## 高级主题

### 1. 引用类型推断

```rust
public fun type_inference_example() {
    let data = SomeStruct { field: 42 };
    let ref_data = &data;  // 类型自动推断为 &SomeStruct
    
    // 显式类型注解
    let explicit_ref: &SomeStruct = &data;
}
```

### 2. 泛型引用

```rust
public fun generic_reference<T>(data: &T): &T {
    data  // 返回相同的引用
}

public fun generic_mutable_reference<T>(data: &mut T) {
    // 对泛型可变引用的操作
}
```

### 3. 引用作为结构体字段

注意：Move 不允许将引用存储在结构体中，但可以作为函数参数和返回值使用。

```rust
// 这是不允许的
// struct BadStruct {
//     ref_field: &u64,  // 编译错误
// }

// 正确的做法是使用函数参数
public fun work_with_reference(data: &SomeStruct) {
    // 在函数作用域内使用引用
}
```

## 总结

引用是 Move 语言中的核心概念，提供了安全、高效的内存访问机制。理解引用的规则和最佳实践对于编写安全、高性能的 Move 代码至关重要。

### 关键要点

1. **安全性**：引用系统防止悬空指针和数据竞争
2. **节省 Gas**：无需复制值，节省 Gas 
3. **灵活性**：支持复杂的数据访问模式
4. **编译时检查**：所有引用安全性在编译时验证

### 下一步

在下一节中，我们将学习 Move 语言中的函数定义和调用，以及如何在函数中有效使用引用。

---

**相关链接**：
- [Move 官方文档 - References](https://aptos.dev/move/book/references)
- [下一节：函数和方法](../04-functions/README.md)
