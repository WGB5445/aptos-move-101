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

```move
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

```move
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

```move
module my_addr::struct_creation {
    use std::debug;
    
    // 命名字段结构体
    struct Point {
        x: u64,
        y: u64,
    }
    
    struct Rectangle {
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
        
        // 元组结构体在函数参数中解构
        let tuple_point = TuplePoint(88, 99);
        let distance = calculate_distance_from_origin(tuple_point);
        assert!(distance == 187, 213); // 88 + 99 的简化距离
        
        // 在函数返回值中使用解构
        let rgb = create_custom_color();
        let RGB(red, green, blue) = rgb;
        assert!(red == 255, 214);
        assert!(green == 128, 215);
        assert!(blue == 0, 216);
        
        debug::print(&coord_x);
        debug::print(&coord_y);
        debug::print(&distance);
    }
    
    // 在函数参数中直接解构
    public fun calculate_distance_from_origin(TuplePoint(x, y): TuplePoint): u64 {
        x + y  // 简化的距离计算
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

```move
// 文件: my_module.move
module my_addr::my_module {
    struct Person {
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
    use my_addr::my_module::{Self, Person};
    
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

```move
module my_addr::struct_access {
    use std::debug;
    
    struct Student {
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
        let mut student = Student {
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
        
        // 在函数调用中使用解构
        let summary = get_student_summary(student);
        assert!(summary == b"Charlie:12", 410);
        
        debug::print(&id);
        debug::print(&name);
        debug::print(&summary);
    }
    
    // 函数参数解构示例
    public fun get_student_summary(Student { name, grade, .. }: Student): vector<u8> {
        // 这里只关心 name 和 grade，忽略其他字段
        let mut result = name;
        result.append(b":");
        // 简化的数字转字符串（实际应用中应该使用适当的转换函数）
        if (grade == 9) result.append(b"9")
        else if (grade == 10) result.append(b"10")
        else if (grade == 11) result.append(b"11")
        else if (grade == 12) result.append(b"12")
        else result.append(b"?");
        result
    }
}
```

### 结构体方法

```move
module my_addr::struct_methods {
    use std::debug;
    
    struct Circle {
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
    public fun area(circle: &Circle): u64 {
        // 简化计算：3 * r * r（近似 π）
        3 * circle.radius * circle.radius
    }
    
    // 获取圆的周长（简化计算，实际应该是 2 * π * r）
    public fun circumference(circle: &Circle): u64 {
        // 简化计算：6 * r（近似 2π）
        6 * circle.radius
    }
    
    // 移动圆心
    public fun move_circle(circle: &mut Circle, new_x: u64, new_y: u64) {
        circle.center_x = new_x;
        circle.center_y = new_y;
    }
    
    // 缩放圆
    public fun scale_circle(circle: &mut Circle, scale_factor: u64) {
        circle.radius = circle.radius * scale_factor;
    }
    
    // 检查点是否在圆内（简化计算）
    public fun contains_point(circle: &Circle, x: u64, y: u64): bool {
        let dx = if (x > circle.center_x) { 
            x - circle.center_x 
        } else { 
            circle.center_x - x 
        };
        let dy = if (y > circle.center_y) { 
            y - circle.center_y 
        } else { 
            circle.center_y - y 
        };
        
        // 简化的距离计算（实际应该用勾股定理）
        dx + dy <= circle.radius
    }
    
    #[test]
    public fun test_circle_methods() {
        let mut circle = new_circle(10, 10, 5);
        
        // 测试面积计算
        let area_val = area(&circle);
        debug::print(&area_val); // 75 (3 * 5 * 5)
        assert!(area_val == 75, 500);
        
        // 测试周长计算
        let circumference_val = circumference(&circle);
        debug::print(&circumference_val); // 30 (6 * 5)
        assert!(circumference_val == 30, 501);
        
        // 测试移动
        move_circle(&mut circle, 20, 20);
        assert!(circle.center_x == 20, 502);
        assert!(circle.center_y == 20, 503);
        
        // 测试缩放
        scale_circle(&mut circle, 2);
        assert!(circle.radius == 10, 504);
        
        // 测试点包含
        let contains = contains_point(&circle, 25, 25);
        assert!(contains == true, 505);
        
        let not_contains = contains_point(&circle, 35, 35);
        assert!(not_contains == false, 506);
    }
}
```

## 结构体的复制和移动

### 复制语义

```move
module my_addr::struct_copy {
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

```move
module my_addr::nested_structs {
    use std::debug;
    use std::vector;
    
    struct Address {
        street: vector<u8>,
        city: vector<u8>,
        country: vector<u8>,
        postal_code: vector<u8>,
    }
    
    struct Contact {
        email: vector<u8>,
        phone: vector<u8>,
    }
    
    struct Person {
        name: vector<u8>,
        age: u8,
        address: Address,
        contact: Contact,
    }
    
    struct Company {
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
    public fun add_employee(company: &mut Company, person: Person) {
        company.employees.push_back(person);
    }
    
    public fun get_employee_count(company: &Company): u64 {
        company.employees.length()
    }
    
    public fun get_company_city(company: &Company): vector<u8> {
        company.headquarters.city
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
        let mut tech_company = new_company(
            b"Tech Innovations Inc.",
            office_address
        );
        
        // 添加员工
        add_employee(&mut tech_company, alice);
        
        // 验证
        assert!(get_employee_count(&tech_company) == 1, 900);
        assert!(get_company_city(&tech_company) == b"San Francisco", 901);
        assert!(tech_company.employees[0].name == b"Alice Johnson", 902);
        assert!(tech_company.employees[0].age == 30, 903);
        assert!(tech_company.employees[0].address.city == b"New York", 904);
        
        debug::print(&tech_company.name);
        debug::print(&get_employee_count(&tech_company));
    }
}
```

## 结构体的能力 (Abilities)

### 四种基本能力

```move
module my_addr::struct_abilities {
    use std::debug;
    
    // 1. copy: 可以被复制
    struct Copyable has copy, drop {
        value: u64,
    }
    
    // 2. drop: 可以被丢弃（销毁）
    struct Droppable has drop {
        data: vector<u8>,
    }
    
    // 3. store: 可以被存储在全局存储中
    struct Storable has store {
        content: vector<u8>,
    }
    
    // 4. key: 可以作为全局存储的键
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

```move
module my_addr::generic_structs {
    use std::debug;
    use std::vector;
    use std::option::{Self, Option};
    
    // 命名字段泛型结构体
    struct Box<T> has copy, drop, store {
        value: T,
    }
    
    struct Pair<T, U> has copy, drop, store {
        first: T,
        second: U,
    }
    
    struct Container<T> has drop, store {
        items: vector<T>,
    }
    
    // 🆕 元组结构体泛型
    struct TuplePair<T, U>(T, U) has copy, drop, store;
    struct Triple<T, U, V>(T, U, V) has copy, drop, store;
    struct Wrapper<T>(T) has copy, drop, store;
    
    // 约束泛型参数
    struct Comparable<T: copy + drop> has copy, drop, store {
        value: T,
    }
    
    // 构造函数
    public fun new_box<T>(value: T): Box<T> {
        Box { value }
    }
    
    public fun new_pair<T, U>(first: T, second: U): Pair<T, U> {
        Pair { first, second }
    }
    
    public fun new_container<T>(): Container<T> {
        Container { items: vector::empty<T>() }
    }
    
    // 🆕 元组结构体构造函数
    public fun new_tuple_pair<T, U>(first: T, second: U): TuplePair<T, U> {
        TuplePair(first, second)
    }
    
    public fun new_triple<T, U, V>(first: T, second: U, third: V): Triple<T, U, V> {
        Triple(first, second, third)
    }
    
    public fun new_wrapper<T>(value: T): Wrapper<T> {
        Wrapper(value)
    }
    
    // 操作方法
    public fun get_box_value<T>(box: &Box<T>): &T {
        &box.value
    }
    
    public fun set_box_value<T>(box: &mut Box<T>, value: T) {
        box.value = value;
    }
    
    public fun get_first<T, U>(pair: &Pair<T, U>): &T {
        &pair.first
    }
    
    public fun get_second<T, U>(pair: &Pair<T, U>): &U {
        &pair.second
    }
    
    // 🆕 元组结构体访问方法
    public fun get_tuple_first<T, U>(pair: &TuplePair<T, U>): &T {
        &pair.0
    }
    
    public fun get_tuple_second<T, U>(pair: &TuplePair<T, U>): &U {
        &pair.1
    }
    
    public fun get_wrapper_value<T>(wrapper: &Wrapper<T>): &T {
        &wrapper.0
    }
    
    public fun add_item<T>(container: &mut Container<T>, item: T) {
        container.items.push_back(item);
    }
    
    public fun get_item_count<T>(container: &Container<T>): u64 {
        container.items.length()
    }
    
    public fun get_item<T>(container: &Container<T>, index: u64): &T {
        &container.items[index]
    }
    
    #[test]
    public fun test_generic_box() {
        // 数字盒子
        let mut number_box = new_box<u64>(42);
        assert!(*get_box_value(&number_box) == 42, 1300);
        
        set_box_value(&mut number_box, 100);
        assert!(*get_box_value(&number_box) == 100, 1301);
        
        // 字符串盒子
        let string_box = new_box<vector<u8>>(b"Hello");
        assert!(*get_box_value(&string_box) == b"Hello", 1302);
        
        // 布尔盒子
        let bool_box = new_box<bool>(true);
        assert!(*get_box_value(&bool_box) == true, 1303);
        
        debug::print(get_box_value(&number_box));
        debug::print(get_box_value(&string_box));
        debug::print(get_box_value(&bool_box));
    }
    
    #[test]
    public fun test_generic_pair() {
        let pair = new_pair<u64, vector<u8>>(123, b"ABC");
        
        assert!(*get_first(&pair) == 123, 1400);
        assert!(*get_second(&pair) == b"ABC", 1401);
        
        let bool_pair = new_pair<bool, bool>(true, false);
        assert!(*get_first(&bool_pair) == true, 1402);
        assert!(*get_second(&bool_pair) == false, 1403);
        
        debug::print(get_first(&pair));
        debug::print(get_second(&pair));
    }
    
    #[test]
    public fun test_generic_container() {
        let mut number_container = new_container<u64>();
        
        add_item(&mut number_container, 10);
        add_item(&mut number_container, 20);
        add_item(&mut number_container, 30);
        
        assert!(get_item_count(&number_container) == 3, 1500);
        assert!(*get_item(&number_container, 0) == 10, 1501);
        assert!(*get_item(&number_container, 1) == 20, 1502);
        assert!(*get_item(&number_container, 2) == 30, 1503);
        
        let mut string_container = new_container<vector<u8>>();
        add_item(&mut string_container, b"First");
        add_item(&mut string_container, b"Second");
        
        assert!(get_item_count(&string_container) == 2, 1504);
        assert!(*get_item(&string_container, 0) == b"First", 1505);
        assert!(*get_item(&string_container, 1) == b"Second", 1506);
        
        debug::print(&get_item_count(&number_container));
        debug::print(&get_item_count(&string_container));
    }
    
    // 🆕 测试元组结构体泛型
    #[test]
    public fun test_tuple_generics() {
        // 元组对
        let tuple_pair = new_tuple_pair<u64, vector<u8>>(456, b"XYZ");
        assert!(*get_tuple_first(&tuple_pair) == 456, 1600);
        assert!(*get_tuple_second(&tuple_pair) == b"XYZ", 1601);
        
        // 三元组
        let triple = new_triple<bool, u64, vector<u8>>(true, 789, b"Triple");
        assert!(triple.0 == true, 1602);
        assert!(triple.1 == 789, 1603);
        assert!(triple.2 == b"Triple", 1604);
        
        // 包装器
        let wrapper = new_wrapper<u64>(999);
        assert!(*get_wrapper_value(&wrapper) == 999, 1605);
        
        debug::print(get_tuple_first(&tuple_pair));
        debug::print(&triple.1);
        debug::print(get_wrapper_value(&wrapper));
    }
    
    // 🆕 泛型结构体解构
    #[test]
    public fun test_generic_destructuring() {
        // 泛型元组结构体解构
        let tuple_pair = new_tuple_pair<u64, bool>(777, true);
        let TuplePair(number, flag) = tuple_pair;
        
        assert!(number == 777, 1606);
        assert!(flag == true, 1607);
        
        let triple = new_triple<u8, u16, u32>(255, 65535, 4294967295);
        let Triple(small, medium, large) = triple;
        
        assert!(small == 255, 1608);
        assert!(medium == 65535, 1609);
        assert!(large == 4294967295, 1610);
        
        let wrapper = new_wrapper<vector<u8>>(b"Wrapped");
        let Wrapper(content) = wrapper;
        
        assert!(content == b"Wrapped", 1611);
        
        // 泛型命名字段结构体解构
        let box_value = new_box<u64>(888);
        let Box { value } = box_value;
        
        assert!(value == 888, 1612);
        
        let pair_value = new_pair<bool, vector<u8>>(false, b"Test");
        let Pair { first, second } = pair_value;
        
        assert!(first == false, 1613);
        assert!(second == b"Test", 1614);
        
        debug::print(&number);
        debug::print(&content);
        debug::print(&value);
    }
    
    // 在泛型函数中使用解构
    public fun extract_first<T, U>(TuplePair(first, _): TuplePair<T, U>): T {
        first
    }
    
    public fun extract_wrapper_content<T>(Wrapper(content): Wrapper<T>): T {
        content
    }
    
    #[test]
    public fun test_generic_destructuring_functions() {
        let pair = new_tuple_pair<u64, vector<u8>>(123, b"ABC");
        let first_value = extract_first(pair);
        assert!(first_value == 123, 1615);
        
        let wrapper = new_wrapper<bool>(true);
        let wrapped_value = extract_wrapper_content(wrapper);
        assert!(wrapped_value == true, 1616);
        
        debug::print(&first_value);
        debug::print(&wrapped_value);
    }
}
```

## 实际应用示例

### Token 元数据结构

```move
module my_addr::token_example {
    use std::debug;
    use std::string::{Self, String};
    use std::option::{Self, Option};
    
    struct TokenMetadata has copy, drop, store {
        name: String,
        symbol: String,
        decimals: u8,
        icon_url: Option<String>,
        project_url: Option<String>,
    }
    
    struct TokenInfo has key {
        metadata: TokenMetadata,
        total_supply: u64,
        max_supply: Option<u64>,
    }
    
    struct Account has key {
        balance: u64,
    }
    
    // 构造函数
    public fun create_token_metadata(
        name: vector<u8>,
        symbol: vector<u8>,
        decimals: u8,
        icon_url: Option<vector<u8>>,
        project_url: Option<vector<u8>>
    ): TokenMetadata {
        TokenMetadata {
            name: string::utf8(name),
            symbol: string::utf8(symbol),
            decimals,
            icon_url: option::map(icon_url, |url| string::utf8(url)),
            project_url: option::map(project_url, |url| string::utf8(url)),
        }
    }
    
    // 获取器方法
    public fun get_name(metadata: &TokenMetadata): String {
        metadata.name
    }
    
    public fun get_symbol(metadata: &TokenMetadata): String {
        metadata.symbol
    }
    
    public fun get_decimals(metadata: &TokenMetadata): u8 {
        metadata.decimals
    }
    
    public fun get_icon_url(metadata: &TokenMetadata): Option<String> {
        metadata.icon_url
    }
    
    public fun get_project_url(metadata: &TokenMetadata): Option<String> {
        metadata.project_url
    }
    
    #[test]
    public fun test_token_metadata() {
        let metadata = create_token_metadata(
            b"My Token",
            b"MTK",
            8,
            option::some(b"https://example.com/icon.png"),
            option::some(b"https://myproject.com")
        );
        
        assert!(get_name(&metadata) == string::utf8(b"My Token"), 2000);
        assert!(get_symbol(&metadata) == string::utf8(b"MTK"), 2001);
        assert!(get_decimals(&metadata) == 8, 2002);
        assert!(option::is_some(&get_icon_url(&metadata)), 2003);
        assert!(option::is_some(&get_project_url(&metadata)), 2004);
        
        debug::print(&metadata.name);
        debug::print(&metadata.symbol);
        debug::print(&metadata.decimals);
    }
}
```

## 最佳实践和常见错误

### 1. 结构体设计原则

```move
module my_addr::best_practices {
    use std::vector;
    
    // ✅ 好的设计：字段相关且内聚
    struct User {
        id: u64,
        username: vector<u8>,
        email: vector<u8>,
        created_at: u64,
    }
    
    // ✅ 提供访问器函数（getter）
    public fun get_user_id(user: &User): u64 {
        user.id
    }
    
    public fun get_username(user: &User): vector<u8> {
        user.username
    }
    
    public fun get_email(user: &User): vector<u8> {
        user.email
    }
    
    // ✅ 提供修改器函数（setter）
    public fun update_email(user: &mut User, new_email: vector<u8>) {
        // 可以在这里添加验证逻辑
        assert!(new_email.length() > 0, 1);
        user.email = new_email;
    }
    
    // ✅ 好的设计：明确的职责
    struct BankAccount {
        account_number: u64,
        balance: u64,
        owner: address,
    }
    
    // ✅ 封装业务逻辑
    public fun deposit(account: &mut BankAccount, amount: u64) {
        assert!(amount > 0, 2);
        account.balance = account.balance + amount;
    }
    
    public fun withdraw(account: &mut BankAccount, amount: u64) {
        assert!(amount > 0, 3);
        assert!(account.balance >= amount, 4);
        account.balance = account.balance - amount;
    }
    
    public fun get_balance(account: &BankAccount): u64 {
        account.balance
    }
    
    // ❌ 不好的设计：字段不相关
    struct MixedData {
        user_name: vector<u8>,
        account_balance: u64,
        random_number: u64,
        is_weekend: bool,
    }
    
    // ✅ 好的设计：使用合适的能力
    struct Config has copy, drop, store {
        max_users: u64,
        fee_rate: u64,
    }
    
    // ✅ 好的设计：资源类型
    struct Coin has key {
        value: u64,
    }
    
    // 🆕 解构的最佳实践
    
    // ✅ 推荐：使用解构简化代码
    public fun process_user_data(user: User): (u64, vector<u8>) {
        let User { id, username, .. } = user;  // 只解构需要的字段
        (id, username)
    }
    
    // ✅ 推荐：在函数参数中直接解构
    public fun validate_bank_account(BankAccount { balance, owner, .. }: &BankAccount): bool {
        *balance > 0 && *owner != @0x0
    }
    
    // ✅ 推荐：使用解构进行模式匹配
    public fun categorize_config(config: Config): vector<u8> {
        let Config { max_users, fee_rate } = config;
        if (max_users > 1000 && fee_rate < 100) {
            b"Enterprise"
        } else if (max_users > 100) {
            b"Professional"
        } else {
            b"Basic"
        }
    }
    
    // ❌ 避免：过度解构，影响可读性
    /*
    public fun bad_destructuring(User { id: user_identification_number, username: user_display_name, email: user_contact_email, created_at: user_registration_timestamp }: User) {
        // 变量名过长，影响可读性
    }
    */
    
    // ✅ 推荐：简洁的变量名
    public fun good_destructuring(User { id, username, email, created_at }: User) {
        // 清晰简洁
    }
}
```

### 2. 构造函数模式

```move
module my_addr::constructor_patterns {
    use std::vector;
    
    struct Student {
        id: u64,
        name: vector<u8>,
        scores: vector<u64>,
    }
    
    // ✅ 基本构造函数
    public fun new_student(id: u64, name: vector<u8>): Student {
        Student {
            id,
            name,
            scores: vector::empty<u64>(),
        }
    }
    
    // ✅ 带验证的构造函数
    public fun new_student_validated(id: u64, name: vector<u8>): Student {
        assert!(id > 0, 100);
        assert!(name.length() > 0, 101);
        
        Student {
            id,
            name,
            scores: vector::empty<u64>(),
        }
    }
    
    // ✅ 构建器模式
    public fun new_student_builder(): StudentBuilder {
        StudentBuilder {
            id: 0,
            name: vector::empty<u8>(),
            scores: vector::empty<u64>(),
        }
    }
    
    struct StudentBuilder {
        id: u64,
        name: vector<u8>,
        scores: vector<u64>,
    }
    
    public fun with_id(builder: StudentBuilder, id: u64): StudentBuilder {
        StudentBuilder { id, ..builder }
    }
    
    public fun with_name(builder: StudentBuilder, name: vector<u8>): StudentBuilder {
        StudentBuilder { name, ..builder }
    }
    
    public fun build(builder: StudentBuilder): Student {
        assert!(builder.id > 0, 200);
        assert!(builder.name.length() > 0, 201);
        
        Student {
            id: builder.id,
            name: builder.name,
            scores: builder.scores,
        }
    }
}
```

### 3. 常见错误和解决方案

```move
module my_addr::common_mistakes {
    struct Data has drop {
        values: vector<u64>,
    }
    
    // ❌ 错误：直接修改不可变引用
    /*
    public fun wrong_modify(data: &Data) {
        data.values.push_back(10); // 编译错误！
    }
    */
    
    // ✅ 正确：使用可变引用
    public fun correct_modify(data: &mut Data, value: u64) {
        data.values.push_back(value);
    }
    
    // ❌ 错误：返回局部变量的引用
    /*
    public fun wrong_return(): &Data {
        let data = Data { values: vector::empty<u64>() };
        &data // 编译错误！
    }
    */
    
    // ✅ 正确：返回拥有所有权的值
    public fun correct_return(): Data {
        Data { values: vector::empty<u64>() }
    }
    
    // ✅ 正确：接受引用参数并返回计算结果
    public fun get_sum(data: &Data): u64 {
        let mut sum = 0;
        let mut i = 0;
        while (i < data.values.length()) {
            sum = sum + data.values[i];
            i = i + 1;
        };
        sum
    }
}

// 演示跨模块访问错误
module my_addr::field_access_errors {
    struct Person has drop {
        name: vector<u8>,
        age: u8,
    }
    
    public fun create_person(name: vector<u8>, age: u8): Person {
        Person { name, age }
    }
    
    // ✅ 正确：提供公共访问函数
    public fun get_name(person: &Person): vector<u8> {
        person.name
    }
    
    public fun get_age(person: &Person): u8 {
        person.age
    }
}

module my_addr::user_module {
    use my_addr::field_access_errors::{Self, Person};
    
    public fun use_person_correctly() {
        let person = field_access_errors::create_person(b"Alice", 25);
        
        // ❌ 错误：尝试直接访问其他模块的结构体字段
        /*
        let name = person.name;  // 编译错误！
        let age = person.age;    // 编译错误！
        */
        
        // ✅ 正确：通过公共函数访问
        let name = field_access_errors::get_name(&person);
        let age = field_access_errors::get_age(&person);
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
11. **最佳实践**：设计原则和常见错误避免

### 结构体特性对比

| 特性 | 命名字段结构体 | 元组结构体 |
|------|---------------|-----------|
| 定义语法 | `struct Point { x: u64, y: u64 }` | `struct Point(u64, u64)` |
| 创建语法 | `Point { x: 10, y: 20 }` | `Point(10, 20)` |
| 字段访问 | `point.x`, `point.y` | `point.0`, `point.1` |
| 解构语法 | `let Point { x, y } = point` | `let Point(x, y) = point` |
| 部分解构 | `let Point { x, .. } = point` | 不支持部分解构 |
| 函数参数解构 | `fn(Point { x, y }: Point)` | `fn(Point(x, y): Point)` |
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
