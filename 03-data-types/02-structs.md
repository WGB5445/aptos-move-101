# 3.2 结构体 (Struct)

## 什么是结构体

结构体是 Move 中用于定义自定义数据类型的核心概念。它允许将多个不同类型的数据组合成一个逻辑单元，类似于其他编程语言中的类或对象。在 Move 中，结构体是构建复杂数据结构和资源的基础。

### 结构体字段的私有性

⚠️ **重要概念**：在 Move 中，结构体的所有字段都是**私有的**，这意味着：

- 结构体字段只能在**定义该结构体的模块内部**直接访问
- 其他模块无法直接读取或修改结构体的字段
- 如果需要在其他模块中访问字段，必须通过**公共函数**（getter/setter）来实现
- 这种设计确保了数据封装和模块间的清晰边界


## 结构体的定义

### 基本语法

```rust
module my_addr::struct_basics {
    use std::debug;
    
    // 定义一个简单的结构体（命名字段）
    struct Person {
        name: vector<u8>,
        age: u8,
        is_student: bool,
    }
    
    // 定义一个更复杂的结构体
    struct Account {
        address: address,
        balance: u64,
        active: bool,
    }
    
    // 包含其他结构体的结构体
    struct Company {
        name: vector<u8>,
        ceo: Person,
        employees: vector<Person>,
        founded_year: u16,
    }
    
    // 🆕 元组结构体（Tuple Struct）- 新特性
    struct Point(u64, u64) has copy, drop;
    struct Color(u8, u8, u8) has copy, drop;
    struct Pair(u64, u8) has copy, drop;
    
    // 元组结构体的使用示例
    #[test]
    public fun test_tuple_structs() {
        // 创建元组结构体
        let point = Point(10, 20);
        let red_color = Color(255, 0, 0);
        let pair = Pair(42, 1);
        
        // 访问元组结构体的字段（通过索引）
        let x = point.0;  // 第一个字段
        let y = point.1;  // 第二个字段
        
        let red = red_color.0;    // R 值
        let green = red_color.1;  // G 值
        let blue = red_color.2;   // B 值
        
        let first = pair.0;   // 第一个值
        let second = pair.1;  // 第二个值
        
        debug::print(&x);     // 10
        debug::print(&y);     // 20
        debug::print(&red);   // 255
        debug::print(&first); // 42
        
        assert!(x == 10, 100);
        assert!(y == 20, 101);
        assert!(red == 255, 102);
        assert!(green == 0, 103);
        assert!(blue == 0, 104);
        assert!(first == 42, 105);
        assert!(second == 1, 106);
    }
    
    // 🆕 结构体解构（Destructuring）
    #[test]
    public fun test_struct_destructuring() {
        // 元组结构体解构
        let point = Point(100, 200);
        let Point(x, y) = point;  // 解构赋值
        
        assert!(x == 100, 107);
        assert!(y == 200, 108);
        
        let color = Color(128, 64, 32);
        let Color(r, g, b) = color;  // 解构 RGB 值
        
        assert!(r == 128, 109);
        assert!(g == 64, 110);
        assert!(b == 32, 111);
        
        let pair = Pair(999, 5);
        let Pair(number, boolean_like) = pair;  // 解构为不同变量名
        
        assert!(number == 999, 112);
        assert!(boolean_like == 5, 113);
        
        debug::print(&x);
        debug::print(&y);
        debug::print(&r);
        debug::print(&number);
    }
}
```

### 结构体的命名规范

```rust
module my_addr::naming_conventions {
    // ✅ 必须：使用 PascalCase（首字母大写）
    struct UserProfile {
        username: vector<u8>,
        email: vector<u8>,
    }
    
    struct BankAccount {
        account_number: u64,
        balance: u64,
    }
    
    // ✅ 推荐：描述性的名称
    struct TokenMetadata {
        name: vector<u8>,
        symbol: vector<u8>,
        decimals: u8,
    }
}
```

## 创建结构体实例

### 基本创建方式

```rust
module my_addr::struct_creation {
    use std::debug;
    
    // 命名字段结构体
    // 为了方便演示，为 struct 增加 copy 和 drop 的能力
    struct Point has copy, drop{
        x: u64,
        y: u64,
    }
    
    // 为了方便演示，为 struct 增加 copy 和 drop 的能力
    struct Rectangle has copy, drop {
        top_left: Point,
        width: u64,
        height: u64,
    }
    
    // 元组结构体
    struct TuplePoint(u64, u64) has copy, drop;
    struct RGB(u8, u8, u8) has copy, drop;
    
    #[test]
    public fun test_create_structs() {
        // 创建命名字段结构体
        let origin = Point {
            x: 0,
            y: 0,
        };
        
        let point_a = Point {
            x: 10,
            y: 20,
        };
        
        // 创建包含其他结构体的结构体
        let rect = Rectangle {
            top_left: origin,
            width: 100,
            height: 50,
        };
        
        // 🆕 创建元组结构体
        let tuple_point = TuplePoint(30, 40);
        let white_color = RGB(255, 255, 255);
        
        debug::print(&point_a.x); // 10
        debug::print(&point_a.y); // 20
        debug::print(&rect.width); // 100
        debug::print(&tuple_point.0); // 30
        debug::print(&tuple_point.1); // 40
        debug::print(&white_color.0); // 255
        
        assert!(point_a.x == 10, 100);
        assert!(point_a.y == 20, 101);
        assert!(rect.width == 100, 102);
        assert!(rect.height == 50, 103);
        assert!(tuple_point.0 == 30, 104);
        assert!(tuple_point.1 == 40, 105);
        assert!(white_color.0 == 255, 106);
        assert!(white_color.1 == 255, 107);
        assert!(white_color.2 == 255, 108);
    }
    
    // 使用构造函数创建结构体
    public fun new_point(x: u64, y: u64): Point {
        Point { x, y }
    }
    
    public fun new_rectangle(x: u64, y: u64, width: u64, height: u64): Rectangle {
        Rectangle {
            top_left: new_point(x, y),
            width,
            height,
        }
    }
    
    // 🆕 元组结构体的构造函数
    public fun new_tuple_point(x: u64, y: u64): TuplePoint {
        TuplePoint(x, y)
    }
    
    public fun new_rgb_color(r: u8, g: u8, b: u8): RGB {
        RGB(r, g, b)
    }
    
    #[test]
    public fun test_constructor_functions() {
        let point = new_point(5, 15);
        let rect = new_rectangle(0, 0, 200, 100);
        
        // 🆕 使用元组结构体构造函数
        let tuple_point = new_tuple_point(50, 60);
        let blue_color = new_rgb_color(0, 0, 255);
        
        assert!(point.x == 5, 200);
        assert!(point.y == 15, 201);
        assert!(rect.top_left.x == 0, 202);
        assert!(rect.top_left.y == 0, 203);
        assert!(rect.width == 200, 204);
        assert!(rect.height == 100, 205);
        assert!(tuple_point.0 == 50, 206);
        assert!(tuple_point.1 == 60, 207);
        assert!(blue_color.2 == 255, 208); // 蓝色分量
    }
    
    // 🆕 结构体解构的进阶用法
    #[test]
    public fun test_advanced_destructuring() {
        // 命名字段结构体解构
        let point = Point { x: 75, y: 125 };
        let Point { x, y } = point;  // 命名字段解构
        
        assert!(x == 75, 209);
        assert!(y == 125, 210);
        
        // 可以使用不同的变量名
        let Point { x: coord_x, y: coord_y } = point;
        assert!(coord_x == 75, 211);
        assert!(coord_y == 125, 212);
        
        // 在函数返回值中使用解构
        let RGB(red, green, blue) = create_custom_color();
        assert!(red == 255, 214);
        assert!(green == 128, 215);
        assert!(blue == 0, 216);
        
        debug::print(&coord_x);
        debug::print(&coord_y);
    }
    
    // 返回元组结构体供解构使用
    public fun create_custom_color(): RGB {
        RGB(255, 128, 0)  // 橙色
    }
}
```

## 访问和修改结构体字段

### 字段访问权限

在 Move 中，结构体字段的访问遵循严格的私有性规则：

- ✅ **模块内部**：可以直接访问和修改字段
- ❌ **模块外部**：无法直接访问字段，需要通过公共函数

```rust
// 文件: my_module.move
module my_addr::my_module {

    // 为了方便演示，为 struct 增加 drop 的能力
    struct Person has drop{
        name: vector<u8>,
        age: u8,
    }
    
    // ✅ 在同一模块内可以直接访问字段
    public fun create_person(name: vector<u8>, age: u8): Person {
        Person { name, age }
    }
    
    // ✅ 提供公共访问器函数
    public fun get_name(person: &Person): vector<u8> {
        person.name
    }
    
    // ✅ 提供公共访问器函数
    public fun get_age(person: &Person): u8 {
        person.age
    }
    
    // ✅ 提供公共修改器函数
    public fun set_age(person: &mut Person, new_age: u8) {
        person.age = new_age;
    }
}

// 文件: other_module.move
module my_addr::other_module {
    use my_addr::my_module;
    
    public fun use_person() {
        let person = my_module::create_person(b"Alice", 25);
        
        // ❌ 编译错误！无法直接访问字段
        // let name = person.name;
        // let age = person.age;
        
        // ✅ 正确：通过公共函数访问
        let name = my_module::get_name(&person);
        let age = my_module::get_age(&person);
    }
}
```

### 字段访问

```rust
module my_addr::struct_access {
    use std::debug;
    
    // 为了方便演示，为 struct 增加 copy 和 drop 的能力
    struct Student has copy, drop{
        id: u64,
        name: vector<u8>,
        grade: u8,
        gpa: u64, // 乘以100的GPA，例如 325 表示 3.25
    }
    
    #[test]
    public fun test_field_access() {
        let student = Student {
            id: 12345,
            name: b"Alice",
            grade: 10,
            gpa: 385, // 3.85
        };
        
        // 读取字段
        let student_id = student.id;
        let student_name = student.name;
        let student_grade = student.grade;
        let student_gpa = student.gpa;
        
        debug::print(&student_id);   // 12345
        debug::print(&student_name); // b"Alice"
        debug::print(&student_grade); // 10
        debug::print(&student_gpa);  // 385
        
        assert!(student_id == 12345, 300);
        assert!(student_name == b"Alice", 301);
        assert!(student_grade == 10, 302);
        assert!(student_gpa == 385, 303);
    }
    
    #[test]
    public fun test_field_modification() {
        let student = Student {
            id: 12345,
            name: b"Bob",
            grade: 9,
            gpa: 350,
        };
        
        // 修改字段
        student.grade = 10;
        student.gpa = 375;
        
        assert!(student.grade == 10, 400);
        assert!(student.gpa == 375, 401);
        
        // 通过引用修改
        let grade_ref = &mut student.grade;
        *grade_ref = 11;
        
        let gpa_ref = &mut student.gpa;
        *gpa_ref = 390;
        
        assert!(student.grade == 11, 402);
        assert!(student.gpa == 390, 403);
    }
    
    // 🆕 字段访问与解构
    #[test]
    public fun test_field_access_with_destructuring() {
        let student = Student {
            id: 54321,
            name: b"Charlie",
            grade: 12,
            gpa: 395,
        };
        
        // 使用解构一次性获取多个字段
        let Student { id, name, grade, gpa } = student;
        
        assert!(id == 54321, 404);
        assert!(name == b"Charlie", 405);
        assert!(grade == 12, 406);
        assert!(gpa == 395, 407);
        
        // 部分解构，只获取需要的字段
        let Student { id: student_id, name: student_name, .. } = student;
        
        assert!(student_id == 54321, 408);
        assert!(student_name == b"Charlie", 409);

        debug::print(&id);
        debug::print(&name);
    }
    
}
```

### 结构体方法

在为结构体编写代码时，可以使用 self 作为参数名，使得编译器可以自动识别当前函数为结构体方法。
并可以使用 `.` 语法，使用函数 `circle.move_circle(20, 20);`

否则只能写为 `move_circle(&mut circle, 20, 20);`

```rust
module my_addr::struct_methods {
    use std::debug;
    
    // 为了方便演示，为 struct 增加 copy 和 drop 的能力
    struct Circle has copy, drop{
        center_x: u64,
        center_y: u64,
        radius: u64,
    }
    
    // 构造函数
    public fun new_circle(x: u64, y: u64, radius: u64): Circle {
        Circle {
            center_x: x,
            center_y: y,
            radius,
        }
    }
    
    // 获取圆的面积（简化计算，实际应该是 π * r²）
    public fun area(self: &Circle): u64 {
        // 简化计算：3 * r * r（近似 π）
        3 * self.radius * self.radius
    }
    
    // 获取圆的周长（简化计算，实际应该是 2 * π * r）
    public fun circumference(self: &Circle): u64 {
        // 简化计算：6 * r（近似 2π）
        6 * self.radius
    }
    
    // 移动圆心
    public fun move_circle(self: &mut Circle, new_x: u64, new_y: u64) {
        self.center_x = new_x;
        self.center_y = new_y;
    }
    
    // 缩放圆
    public fun scale_circle(self: &mut Circle, scale_factor: u64) {
        self.radius *= scale_factor;
    }
    
    // 检查点是否在圆内（简化计算）
    public fun contains_point(self: &Circle, x: u64, y: u64): bool {
        let dx = if (x > self.center_x) { 
            x - self.center_x 
        } else { 
            self.center_x - x 
        };
        let dy = if (y > self.center_y) { 
            y - self.center_y 
        } else { 
            self.center_y - y 
        };
        
        // 简化的距离计算（实际应该用勾股定理）
        dx + dy <= self.radius
    }
    
    #[test]
    public fun test_circle_methods() {
        let circle = new_circle(10, 10, 5);
        
        // 测试面积计算
        let area_val = circle.area();
        debug::print(&area_val); // 75 (3 * 5 * 5)
        assert!(area_val == 75, 500);
        
        // 测试周长计算
        let circumference_val = circle.circumference();
        debug::print(&circumference_val); // 30 (6 * 5)
        assert!(circumference_val == 30, 501);
        
        // 测试移动
        circle.move_circle(20, 20);
        assert!(circle.center_x == 20, 502);
        assert!(circle.center_y == 20, 503);
        
        // 测试缩放
        circle.scale_circle(2);
        assert!(circle.radius == 10, 504);
        
        // 测试点包含
        let contains = circle.contains_point(25, 25);
        assert!(contains == true, 505);
        
        let not_contains = circle.contains_point(35, 35);
        assert!(not_contains == false, 506);
    }
}
```

## 结构体的复制和移动

### 复制语义

```rust
module my_addr::struct_copy {
    #[test_only]
    use std::debug;
    
    // 具有 copy 能力的结构体
    struct Point has copy, drop {
        x: u64,
        y: u64,
    }
    
    // 不具有 copy 能力的结构体
    struct UniquePoint has drop {
        x: u64,
        y: u64,
        id: u64,
    }
    
    #[test]
    public fun test_copy_semantics() {
        let point1 = Point { x: 10, y: 20 };
        
        // Point 有 copy 能力，可以被复制
        let point2 = point1; // 复制
        let point3 = point1; // 再次复制
        
        // 所有三个变量都可以使用
        assert!(point1.x == 10, 600);
        assert!(point2.x == 10, 601);
        assert!(point3.x == 10, 602);
        
        debug::print(&point1);
        debug::print(&point2);
        debug::print(&point3);
    }
    
    #[test]
    public fun test_move_semantics() {
        let unique_point1 = UniquePoint { x: 5, y: 15, id: 1 };
        
        // UniquePoint 没有 copy 能力，发生移动
        let unique_point2 = unique_point1; // 移动
        // unique_point1 现在不能再使用
        
        assert!(unique_point2.x == 5, 700);
        assert!(unique_point2.y == 15, 701);
        assert!(unique_point2.id == 1, 702);
        
        debug::print(&unique_point2);
        // debug::print(&unique_point1); // 错误！unique_point1 已被移动
    }
    
    public fun clone_point(point: &Point): Point {
        Point { x: point.x, y: point.y }
    }
    
    #[test]
    public fun test_explicit_clone() {
        let original = Point { x: 100, y: 200 };
        let cloned = clone_point(&original);
        
        assert!(original.x == cloned.x, 800);
        assert!(original.y == cloned.y, 801);
        
        debug::print(&original);
        debug::print(&cloned);
    }
}
```

## 嵌套结构体

### 复杂的嵌套结构

```rust
module my_addr::nested_structs {
    #[test_only]
    use std::debug;
    use std::vector;
    
    // 为了方便演示，为 struct 增加 drop 的能力
    struct Address has drop {
        street: vector<u8>,
        city: vector<u8>,
        country: vector<u8>,
        postal_code: vector<u8>,
    }
    
    // 为了方便演示，为 struct 增加 drop 的能力
    struct Contact has drop {
        email: vector<u8>,
        phone: vector<u8>,
    }
    
    // 为了方便演示，为 struct 增加 drop 的能力
    struct Person has drop {
        name: vector<u8>,
        age: u8,
        address: Address,
        contact: Contact,
    }
    
    // 为了方便演示，为 struct 增加 drop 的能力
    struct Company has drop {
        name: vector<u8>,
        employees: vector<Person>,
        headquarters: Address,
    }
    
    // 构造函数
    public fun new_address(
        street: vector<u8>,
        city: vector<u8>,
        country: vector<u8>,
        postal_code: vector<u8>
    ): Address {
        Address { street, city, country, postal_code }
    }
    
    public fun new_contact(email: vector<u8>, phone: vector<u8>): Contact {
        Contact { email, phone }
    }
    
    public fun new_person(
        name: vector<u8>,
        age: u8,
        address: Address,
        contact: Contact
    ): Person {
        Person { name, age, address, contact }
    }
    
    public fun new_company(
        name: vector<u8>,
        headquarters: Address
    ): Company {
        Company {
            name,
            employees: vector::empty<Person>(),
            headquarters,
        }
    }
    
    // 操作方法
    public fun add_employee(self: &mut Company, person: Person) {
        self.employees.push_back(person);
    }
    
    public fun get_employee_count(self: &Company): u64 {
        self.employees.length()
    }
    
    public fun get_company_city(self: &Company): vector<u8> {
        self.headquarters.city
    }
    
    #[test]
    public fun test_nested_structs() {
        // 创建地址
        let home_address = new_address(
            b"123 Main St",
            b"New York",
            b"USA",
            b"10001"
        );
        
        let office_address = new_address(
            b"456 Business Ave",
            b"San Francisco",
            b"USA",
            b"94105"
        );
        
        // 创建联系方式
        let contact = new_contact(
            b"alice@example.com",
            b"+1-555-0123"
        );
        
        // 创建人员
        let alice = new_person(
            b"Alice Johnson",
            30,
            home_address,
            contact
        );
        
        // 创建公司
        let tech_company = new_company(
            b"Tech Innovations Inc.",
            office_address
        );
        
        // 添加员工
        tech_company.add_employee(alice);
        
        // 验证
        assert!(tech_company.get_employee_count() == 1, 900);
        assert!(tech_company.get_company_city() == b"San Francisco", 901);
        assert!(tech_company.employees[0].name == b"Alice Johnson", 902);
        assert!(tech_company.employees[0].age == 30, 903);
        assert!(tech_company.employees[0].address.city == b"New York", 904);
        
        debug::print(&tech_company.name);
        debug::print(&tech_company.get_employee_count());
    }
}
```

## 结构体的能力 (Abilities)

### 四种基本能力

```rust
module my_addr::struct_abilities {
    #[test_only]
    use std::debug;
    
    // 1. copy: 可以被复制
    struct Copyable has copy {
        value: u64,
    }
    
    // 2. drop: 可以被丢弃（销毁）
    struct Droppable has drop {
        data: vector<u8>,
    }
    
    // 3. store: 可以被存储在其他结构体中
    struct Storable has store {
        content: vector<u8>,
    }
    
    // 4. key: 可以作为全局存储的结构体
    struct Resource has key {
        id: u64,
        data: vector<u8>,
    }
    
    // 组合能力
    struct FlexibleStruct has copy, drop, store {
        name: vector<u8>,
        value: u64,
    }
    
    struct CompleteStruct has copy, drop, store, key {
        id: u64,
        name: vector<u8>,
        data: vector<u8>,
    }
    
    #[test]
    public fun test_copyable() {
        let original = Copyable { value: 42 };
        let copy1 = original; // 复制
        let copy2 = original; // 再次复制
        
        assert!(original.value == 42, 1000);
        assert!(copy1.value == 42, 1001);
        assert!(copy2.value == 42, 1002);
        
        debug::print(&original);
        debug::print(&copy1);
        debug::print(&copy2);

        // 由于 Copyable 结构体未实现了 drop 能力，所以不能进行丢弃
        // 需要手动解构结构体
        // 可以将结构体中的值赋值给变量
        let Copyable { value: _value } = original;
        // 也可以使用 _ 忽略某个值
        let Copyable { value: _ } = copy1;
        // 也可以使用 .. 忽略所有值
        let Copyable { .. } = copy2;
    }
    
    #[test]
    public fun test_droppable() {
        let droppable = Droppable { data: b"Hello" };
        assert!(droppable.data == b"Hello", 1100);
        // droppable 在函数结束时自动被丢弃
    }
    
    public fun create_flexible(): FlexibleStruct {
        FlexibleStruct {
            name: b"Flexible",
            value: 100,
        }
    }
    
    #[test]
    public fun test_flexible() {
        let flex1 = create_flexible();
        let flex2 = flex1; // copy
        let flex3 = flex1; // copy again
        
        assert!(flex1.name == b"Flexible", 1200);
        assert!(flex2.name == b"Flexible", 1201);
        assert!(flex3.name == b"Flexible", 1202);
        assert!(flex1.value == 100, 1203);
        assert!(flex2.value == 100, 1204);
        assert!(flex3.value == 100, 1205);
    }
}
```

## 泛型结构体

### 参数化结构体

```rust
module my_addr::generic_structs {
    #[test_only]
    use std::debug;
    use std::vector;
    
    // ========================================
    // 泛型结构体定义
    // ========================================
    
    // 1. 命名字段泛型结构体 - Box<T>
    // 这是一个通用的容器结构体，可以存储任意类型的值
    // 添加了 copy, drop, store 能力以便于演示和测试
    struct Box<T> has copy, drop, store {
        value: T,  // 存储任意类型的值
    }
    
    // 2. 双类型泛型结构体 - Pair<T, U>
    // 可以存储两个不同类型的值，类似于元组但使用命名字段
    struct Pair<T, U> has copy, drop, store {
        first: T,   // 第一个值
        second: U,  // 第二个值
    }
    
    // 3. 容器泛型结构体 - Container<T>
    // 一个可以存储多个同类型元素的容器
    struct Container<T> has drop, store {
        items: vector<T>,  // 使用 vector 存储多个元素
    }
    
    // 4. 元组结构体泛型 - 使用位置索引访问字段
    struct TuplePair<T, U>(T, U) has copy, drop, store;  // 二元组
    struct Triple<T, U, V>(T, U, V) has copy, drop, store;  // 三元组
    struct Wrapper<T>(T) has copy, drop, store;  // 单值包装器
    
    // 5. 带约束的泛型结构体 - Comparable<T>
    // 泛型参数 T 必须具有 copy 和 drop 能力
    struct Comparable<T: copy + drop> has copy, drop, store {
        value: T,
    }
    
    // ========================================
    // 构造函数
    // ========================================
    
    // 创建 Box 实例
    public fun new_box<T>(value: T): Box<T> {
        Box { value }
    }
    
    // 创建 Pair 实例
    public fun new_pair<T, U>(first: T, second: U): Pair<T, U> {
        Pair { first, second }
    }
    
    // 创建空的 Container 实例
    public fun new_container<T>(): Container<T> {
        Container { items: vector::empty<T>() }
    }
    
    // 创建元组结构体实例
    public fun new_tuple_pair<T, U>(first: T, second: U): TuplePair<T, U> {
        TuplePair(first, second)
    }
    
    public fun new_triple<T, U, V>(first: T, second: U, third: V): Triple<T, U, V> {
        Triple(first, second, third)
    }
    
    public fun new_wrapper<T>(value: T): Wrapper<T> {
        Wrapper(value)
    }
    
    // ========================================
    // 访问和操作方法
    // ========================================
    
    // Box 相关操作
    public fun get_box_value<T>(self: &Box<T>): &T {
        &self.value  // 返回对内部值的引用
    }
    
    public fun set_box_value<T: drop>(self: &mut Box<T>, value: T) {
        self.value = value;  // 设置新的值
    }
    
    // Pair 相关操作
    public fun get_first<T, U>(self: &Pair<T, U>): &T {
        &self.first  // 获取第一个值
    }
    
    public fun get_second<T, U>(self: &Pair<T, U>): &U {
        &self.second  // 获取第二个值
    }
    
    // 元组结构体访问方法 - 使用位置索引
    public fun get_tuple_first<T, U>(self: &TuplePair<T, U>): &T {
        &self.0  // 访问第一个元素（索引 0）
    }
    
    public fun get_tuple_second<T, U>(self: &TuplePair<T, U>): &U {
        &self.1  // 访问第二个元素（索引 1）
    }
    
    public fun get_wrapper_value<T>(self: &Wrapper<T>): &T {
        &self.0  // 访问包装的值
    }
    
    // Container 相关操作
    public fun add_item<T>(self: &mut Container<T>, item: T) {
        self.items.push_back(item);  // 向容器添加元素
    }
    
    public fun get_item_count<T>(self: &Container<T>): u64 {
        self.items.length()  // 获取容器中元素的数量
    }
    
    public fun get_item<T>(self: &Container<T>, index: u64): &T {
        &self.items[index]  // 根据索引获取元素
    }
    
    // ========================================
    // 测试函数
    // ========================================
    
    #[test]
    public fun test_generic_box() {
        // 测试不同类型的 Box 结构体
        
        // 1. 数字盒子 - 存储 u64 类型
        let number_box = new_box<u64>(42);
        assert!(*number_box.get_box_value() == 42, 1300);
        
        // 修改盒子中的值
        number_box.set_box_value(100);
        assert!(*number_box.get_box_value() == 100, 1301);
        
        // 2. 字符串盒子 - 存储 vector<u8> 类型
        let string_box = new_box<vector<u8>>(b"Hello");
        assert!(*string_box.get_box_value() == b"Hello", 1302);
        
        // 3. 布尔盒子 - 存储 bool 类型
        let bool_box = new_box<bool>(true);
        assert!(*bool_box.get_box_value() == true, 1303);
        
        // 打印所有盒子的值进行验证
        debug::print(number_box.get_box_value());
        debug::print(string_box.get_box_value());
        debug::print(bool_box.get_box_value());
    }
    
    #[test]
    public fun test_generic_pair() {
        // 测试 Pair 结构体 - 可以存储两个不同类型的值
        
        // 创建包含数字和字符串的对
        let pair = new_pair<u64, vector<u8>>(123, b"ABC");
        
        // 验证第一个和第二个值
        assert!(*pair.get_first() == 123, 1400);
        assert!(*pair.get_second() == b"ABC", 1401);
        
        // 创建包含两个布尔值的对
        let bool_pair = new_pair<bool, bool>(true, false);
        assert!(*bool_pair.get_first() == true, 1402);
        assert!(*bool_pair.get_second() == false, 1403);
        
        // 打印值进行验证
        debug::print(pair.get_first());
        debug::print(pair.get_second());
    }
    
    #[test]
    public fun test_generic_container() {
        // 测试 Container 结构体 - 可以存储多个同类型的元素
        
        // 1. 数字容器
        let number_container = new_container<u64>();
        
        // 向容器添加多个数字
        number_container.add_item(10);
        number_container.add_item(20);
        number_container.add_item(30);
        
        // 验证容器的大小和内容
        assert!(number_container.get_item_count() == 3, 1500);
        assert!(*number_container.get_item(0) == 10, 1501);
        assert!(*number_container.get_item(1) == 20, 1502);
        assert!(*number_container.get_item(2) == 30, 1503);
        
        // 2. 字符串容器
        let string_container = new_container<vector<u8>>();
        string_container.add_item(b"First");
        string_container.add_item(b"Second");
        
        // 验证字符串容器
        assert!(string_container.get_item_count() == 2, 1504);
        assert!(*string_container.get_item(0) == b"First", 1505);
        assert!(*string_container.get_item(1) == b"Second", 1506);
        
        // 打印容器大小进行验证
        debug::print(&number_container.get_item_count());
        debug::print(&string_container.get_item_count());
    }
    
    #[test]
    public fun test_tuple_generics() {
        // 测试元组结构体泛型 - 使用位置索引访问字段
        
        // 1. 元组对 - 使用位置索引访问
        let tuple_pair = new_tuple_pair<u64, vector<u8>>(456, b"XYZ");
        assert!(*tuple_pair.get_tuple_first() == 456, 1600);
        assert!(*tuple_pair.get_tuple_second() == b"XYZ", 1601);
        
        // 2. 三元组 - 直接使用位置索引
        let triple = new_triple<bool, u64, vector<u8>>(true, 789, b"Triple");
        assert!(triple.0 == true, 1602);      // 第一个元素
        assert!(triple.1 == 789, 1603);       // 第二个元素
        assert!(triple.2 == b"Triple", 1604); // 第三个元素
        
        // 3. 包装器 - 包装单个值
        let wrapper = new_wrapper<u64>(999);
        assert!(*wrapper.get_wrapper_value() == 999, 1605);
        
        // 打印值进行验证
        debug::print(tuple_pair.get_tuple_first());
        debug::print(&triple.1);
        debug::print(wrapper.get_wrapper_value());
    }
    
    #[test]
    public fun test_generic_destructuring() {
        // 测试泛型结构体的解构 - 将结构体分解为单独的变量
        
        // 1. 元组结构体解构
        let tuple_pair = new_tuple_pair<u64, bool>(777, true);
        let TuplePair(number, flag) = tuple_pair;  // 解构为 number 和 flag
        
        assert!(number == 777, 1606);
        assert!(flag == true, 1607);
        
        // 2. 三元组解构
        let triple = new_triple<u8, u16, u32>(255, 65535, 4294967295);
        let Triple(small, medium, large) = triple;  // 解构为三个变量
        
        assert!(small == 255, 1608);
        assert!(medium == 65535, 1609);
        assert!(large == 4294967295, 1610);
        
        // 3. 包装器解构
        let wrapper = new_wrapper<vector<u8>>(b"Wrapped");
        let Wrapper(content) = wrapper;  // 解构为 content
        
        assert!(content == b"Wrapped", 1611);
        
        // 4. 命名字段结构体解构
        let box_value = new_box<u64>(888);
        let Box { value } = box_value;  // 使用字段名解构
        
        assert!(value == 888, 1612);
        
        // 5. Pair 结构体解构
        let pair_value = new_pair<bool, vector<u8>>(false, b"Test");
        let Pair { first, second } = pair_value;  // 使用字段名解构
        
        assert!(first == false, 1613);
        assert!(second == b"Test", 1614);
        
        // 打印解构后的变量进行验证
        debug::print(&number);
        debug::print(&content);
        debug::print(&value);
    }

    #[test]
    public fun test_generic_destructuring_functions() {
        // 测试使用函数访问元组结构体的值
        
        // 使用函数获取元组对的第一个值
        let pair = new_tuple_pair<u64, vector<u8>>(123, b"ABC");
        let first_value = pair.get_tuple_first();
        assert!(*first_value == 123, 1615);
        
        // 使用函数获取包装器的值
        let wrapper = new_wrapper<bool>(true);
        let wrapped_value = wrapper.get_wrapper_value();
        assert!(*wrapped_value == true, 1616);
        
        // 打印获取的值进行验证
        debug::print(first_value);
        debug::print(wrapped_value);
    }
}
```

## 实际应用示例

### Token 元数据结构

看了一大堆基础，可以来看看模拟一个 Token Metadata 是如何记录的吧

```rust
module my_addr::token_example {
    #[test_only]
    use std::debug;
    use std::string::{Self, String};
    use std::option::Option;
    
    // ========================================
    // 代币相关结构体定义
    // ========================================
    
    // 代币元数据结构体 - 存储代币的基本信息
    // 具有 copy, drop, store 能力，可以在函数间传递和存储
    struct TokenMetadata has copy, drop, store {
        name: String,           // 代币名称，如 "Bitcoin"
        symbol: String,         // 代币符号，如 "BTC"
        decimals: u8,           // 小数位数，如 8 表示支持 8 位小数
        icon_url: Option<String>,      // 代币图标 URL（可选）
        project_url: Option<String>,   // 项目官网 URL（可选）
    }
    
    // 代币信息结构体 - 存储代币的完整信息
    // 具有 key 能力，可以作为全局存储的资源
    struct TokenInfo has key {
        metadata: TokenMetadata,    // 代币元数据
        total_supply: u64,          // 当前总供应量
        max_supply: Option<u64>,    // 最大供应量（可选，None 表示无上限）
    }
    
    // 账户结构体 - 存储用户账户信息
    // 具有 key 能力，可以作为全局存储的资源，但是不能带有 copy 能力，防止被复制
    struct Account has key {
        balance: u64,  // 账户余额
    }
    
    // ========================================
    // 构造函数
    // ========================================
    
    // 创建代币元数据
    // 参数使用 vector<u8> 类型，然后转换为 String 类型
    public fun create_token_metadata(
        name: vector<u8>,           // 代币名称的字节数组
        symbol: vector<u8>,         // 代币符号的字节数组
        decimals: u8,               // 小数位数
        icon_url: Option<vector<u8>>,      // 图标 URL 的字节数组（可选）
        project_url: Option<vector<u8>>    // 项目 URL 的字节数组（可选）
    ): TokenMetadata {
        TokenMetadata {
            name: string::utf8(name),      // 将字节数组转换为 UTF-8 字符串
            symbol: string::utf8(symbol),  // 将字节数组转换为 UTF-8 字符串
            decimals,
            // 使用 map 函数处理可选值：如果有值则转换为字符串，否则保持 None
            icon_url: icon_url.map(|url| string::utf8(url)),
            project_url: project_url.map(|url| string::utf8(url)),
        }
    }
    
    // ========================================
    // 获取器方法（Getter Methods）
    // ========================================
    
    // 获取代币名称
    public fun get_name(self: &TokenMetadata): String {
        self.name
    }
    
    // 获取代币符号
    public fun get_symbol(self: &TokenMetadata): String {
        self.symbol
    }
    
    // 获取代币小数位数
    public fun get_decimals(self: &TokenMetadata): u8 {
        self.decimals
    }
    
    // 获取代币图标 URL（可能为 None）
    public fun get_icon_url(self: &TokenMetadata): Option<String> {
        self.icon_url
    }
    
    // 获取项目官网 URL（可能为 None）
    public fun get_project_url(self: &TokenMetadata): Option<String> {
        self.project_url
    }
    
    // ========================================
    // 测试函数
    // ========================================
    
    #[test]
    public fun test_token_metadata() {
        // 创建一个代币元数据实例进行测试
        
        // 创建包含所有字段的代币元数据
        let metadata = create_token_metadata(
            b"My Token",                                    // 代币名称
            b"MTK",                                        // 代币符号
            8,                                             // 8 位小数
            option::some(b"https://example.com/icon.png"), // 图标 URL
            option::some(b"https://myproject.com")         // 项目 URL
        );
        
        // 验证所有字段的值是否正确
        assert!(metadata.get_name() == string::utf8(b"My Token"), 2000);
        assert!(metadata.get_symbol() == string::utf8(b"MTK"), 2001);
        assert!(metadata.get_decimals() == 8, 2002);
        assert!(metadata.get_icon_url().is_some(), 2003);      // 验证图标 URL 存在
        assert!(metadata.get_project_url().is_some(), 2004);   // 验证项目 URL 存在
        
        // 打印元数据信息进行验证
        debug::print(&metadata.name);
        debug::print(&metadata.symbol);
        debug::print(&metadata.decimals);
    }
}
```

## 小结

通过本章的学习，我们掌握了：

1. **结构体定义**：如何定义和命名结构体（命名字段和元组结构体）
2. **实例创建**：不同的创建和初始化方式
3. **字段操作**：访问和修改结构体字段（包括索引访问）
4. **🆕 结构体解构**：使用模式匹配解构结构体，简化代码
5. **方法定义**：为结构体定义相关的操作函数
6. **复制和移动**：理解值语义和引用语义
7. **嵌套结构体**：构建复杂的数据结构
8. **能力系统**：copy、drop、store、key 四种能力
9. **泛型结构体**：参数化的结构体定义（命名字段和元组形式）
10. **实际应用**：Token 元数据等实际场景

### 结构体特性对比

| 特性 | 命名字段结构体 | 元组结构体 |
|------|---------------|-----------|
| 定义语法 | `struct Point { x: u64, y: u64 }` | `struct Point(u64, u64)` |
| 创建语法 | `Point { x: 10, y: 20 }` | `Point(10, 20)` |
| 字段访问 | `point.x`, `point.y` | `point.0`, `point.1` |
| 解构语法 | `let Point { x, y } = point` | `let Point(x, y) = point` |
| 部分解构 | `let Point { x, .. } = point` | 不支持部分解构 |
| 适用场景 | 复杂数据结构，字段含义明确 | 简单数据组合，临时数据结构 |
| 可读性 | 高（字段名称清晰） | 中等（需要记住字段顺序） |

### 解构的使用场景

✅ **函数参数解构** - 直接在参数中解构，简化函数体  
✅ **模式匹配** - 根据结构体内容进行条件判断  
✅ **批量赋值** - 一次性提取多个字段值  
✅ **部分解构** - 只提取需要的字段，忽略其他字段  
✅ **泛型解构** - 在泛型函数中使用解构提高代码复用性  

结构体是 Move 中构建复杂数据类型的基础，掌握它们将帮助我们更好地设计和实现 Move 程序的数据模型。

---

**上一节**：[3.1 基本数据类型](./01-basic-types.md)  
**下一节**：[3.3 引用和借用](./03-references.md)
