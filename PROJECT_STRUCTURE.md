# Move 基础语法教程 - 项目结构

## 📁 目录结构

```
aptos_move_basic_grammar_tutorial/
├── README.md                    # 项目主页面
├── PROJECT_STRUCTURE.md         # 项目结构说明
├── examples/                    # 实际代码示例
│   ├── 01-hello-world/         # Hello World 示例
│   │   ├── Move.toml
│   │   ├── sources/
│   │   │   └── main.move
│   │   └── tests/
│   │       └── integration_tests.move
│   └── 02-simple-token/        # 简单代币示例
│       ├── Move.toml
│       ├── sources/
│       │   └── coin.move
│       └── tests/
│           └── coin_tests.move
├── 01-basics/                  # 第一章：Move 基础概念
│   ├── 01-introduction.md      # Move 语言简介
│   ├── 02-setup.md            # 开发环境搭建
│   └── 03-first-program.md    # 第一个 Move 程序
├── 02-modules/                 # 第二章：Module 基础
│   ├── 01-module-basics.md    # Module 概念与结构
│   ├── 02-create-module.md    # 创建第一个 Module
│   └── 03-import-export.md    # Module 的导入与导出
├── 03-data-types/             # 第三章：数据类型
│   ├── 01-basic-types.md      # 基本数据类型
│   ├── 02-structs.md          # 结构体 (Struct)
│   ├── 03-vectors.md          # 向量 (Vector)
│   └── 04-tables.md           # 映射 (Table)
├── 04-functions/              # 第四章：函数与表达式
│   ├── 01-function-basics.md  # 函数定义与调用
│   ├── 02-parameters-return.md # 参数与返回值
│   ├── 03-expressions.md      # 表达式与语句
│   └── 04-control-flow.md     # 控制流
├── 05-resources/              # 第五章：资源 (Resource)
│   ├── 01-resource-concept.md # 资源概念
│   ├── 02-create-resource.md  # 创建自定义资源
│   ├── 03-move-borrow.md      # 资源的移动与借用
│   └── 04-resource-safety.md  # 资源的安全操作
├── 06-generics-abilities/     # 第六章：泛型与能力
│   ├── 01-generics-basics.md  # 泛型基础
│   ├── 02-abilities.md        # 能力 (Abilities)
│   └── 03-generics-abilities.md # 泛型与能力的结合
├── 07-error-handling/         # 第七章：错误处理
│   ├── 01-error-types.md      # 错误类型
│   ├── 02-assertions.md       # 断言与检查
│   └── 03-custom-errors.md    # 自定义错误
├── 08-projects/               # 第八章：实战项目
│   ├── 01-simple-token.md     # 简单代币合约
│   ├── 02-voting-system.md    # 投票系统
│   └── 03-nft-contract.md     # 数字收藏品
├── 09-testing-deployment/     # 第九章：测试与部署
│   ├── 01-unit-tests.md       # 单元测试
│   ├── 02-integration-tests.md # 集成测试
│   └── 03-deployment.md       # 合约部署
└── 10-best-practices/         # 第十章：最佳实践
    ├── 01-coding-standards.md # 代码规范
    ├── 02-security.md         # 安全考虑
    └── 03-performance.md      # 性能优化
```

## 🎯 学习路径

### 初学者路径
1. **环境准备**：阅读 `01-basics/02-setup.md` 搭建开发环境
2. **基础概念**：从 `01-basics/01-introduction.md` 开始了解 Move
3. **第一个程序**：跟随 `01-basics/03-first-program.md` 编写 Hello World
4. **模块学习**：深入 `02-modules/` 章节理解模块概念
5. **数据类型**：学习 `03-data-types/` 掌握各种数据类型
6. **函数编程**：通过 `04-functions/` 学习函数和表达式
7. **资源模型**：重点学习 `05-resources/` 理解 Move 核心概念
8. **高级特性**：学习 `06-generics-abilities/` 掌握泛型和能力
9. **错误处理**：通过 `07-error-handling/` 学习健壮性编程
10. **实战项目**：完成 `08-projects/` 中的实际项目
11. **测试部署**：学习 `09-testing-deployment/` 进行测试和部署
12. **最佳实践**：阅读 `10-best-practices/` 提升代码质量

### 实践项目
- **Hello World**：`examples/01-hello-world/` - 最基础的 Move 程序
- **简单代币**：`examples/02-simple-token/` - 完整的代币合约

## 📚 内容特点

### 中文讲解
- 所有教程内容都使用中文编写
- 概念解释清晰易懂
- 代码注释详细

### 循序渐进
- 从最基础的 module 开始
- 逐步深入复杂概念
- 每个章节都有练习和示例

### 实战导向
- 提供完整的代码示例
- 包含测试用例
- 涵盖实际应用场景

### 最佳实践
- 遵循 Move 编程规范
- 注重安全性考虑
- 提供性能优化建议

## 🛠️ 使用说明

### 环境要求
- Rust 1.70+
- Move CLI
- VS Code（推荐）

### 运行示例
```bash
# 进入示例目录
cd examples/01-hello-world

# 编译项目
move build

# 运行测试
move test

# 检查代码
move check
```

### 学习建议
1. **按顺序学习**：不要跳过基础章节
2. **动手实践**：每个代码示例都要自己编写和运行
3. **理解概念**：重点理解 Move 的资源模型
4. **多做练习**：完成每章的练习题
5. **项目实践**：尝试修改和扩展示例项目

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request 来改进教程：

1. **报告错误**：如果发现教程中的错误
2. **改进内容**：提供更好的解释或示例
3. **添加章节**：补充缺失的内容
4. **翻译优化**：改进中文表达

## 📄 许可证

本教程采用 MIT 许可证，可以自由使用和修改。 