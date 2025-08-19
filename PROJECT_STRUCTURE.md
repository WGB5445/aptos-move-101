# Move 基础语法教程 - 项目结构

## 📁 目录结构

```
aptos_move_basic_grammar_tutorial/
├── README.md                    # 项目主页面
├── PROJECT_STRUCTURE.md         # 项目结构说明
├── SUMMARY.md                   # 教程目录索引
├── book.toml                    # mdBook 配置文件
├── book/                        # 生成的静态网站
│   ├── index.html              # 主页
│   ├── examples/               # 示例代码的 HTML 版本
│   └── [各章节的 HTML 文件]
├── examples/                    # 实际代码示例
│   ├── README.md               # 示例说明
│   ├── 01-hello_blockchain/    # Hello Blockchain 示例
│   │   ├── Move.toml
│   │   ├── sources/
│   │   │   └── hello_blockchain.move
│   │   ├── scripts/
│   │   └── tests/
│   └── 02-simple-token/        # 简单代币示例
│       ├── Move.toml
│       ├── sources/
│       │   └── coin.move
│       └── tests/
│           └── coin_tests.move
├── 01-basics/                  # 第一章：Move 基础概念
│   ├── 01-introduction.md      # Move 语言简介
│   ├── 02-setup.md            # 开发环境搭建
│   ├── 03-first-program.md    # 第一个 Move 程序
│   └── 01-hello_blockchain/    # Hello Blockchain 项目示例
│       ├── Move.toml
│       ├── sources/
│       │   └── hello_blockchain.move
│       ├── scripts/
│       └── tests/
├── 02-modules/                 # 第二章：Module 基础
│   └── 01-module-basics-fixed.md # Module 概念与结构
├── 03-data-types/             # 第三章：数据类型
│   ├── 01-basic-types.md      # 基本数据类型
│   ├── 02-structs.md          # 结构体 (Struct)
│   ├── 03-references.md       # 引用和可变引用
│   └── sources/               # 示例代码
│       └── 10_struct_best_practices.move # 结构体最佳实践
├── 04-functions/              # 第四章：函数
│   └── README.md              # 函数基础
├── 05-resources/              # 第五章：资源 (Resource)
│   └── README.md              # 资源概念
├── 06-generics-abilities/     # 第六章：泛型与能力
│   └── README.md              # 泛型与能力基础
├── 07-testing/                # 第七章：测试
│   └── README.md              # 测试基础
├── 08-advanced-types/         # 第八章：高级类型
│   └── 01-advanced-types.md   # 高级类型概念
├── 08-object-model/           # 对象模型（待开发）
├── 09-advanced-types/         # 第九章：枚举等高级类型
│   └── 01-enum.md             # 枚举类型
└── 10-cross-contract/         # 第十章：跨合约调用
    └── 01-cross-contract.md   # 跨合约调用基础
```

## 🎯 学习路径

### 初学者路径
1. **环境准备**：阅读 `01-basics/02-setup.md` 搭建开发环境
2. **基础概念**：从 `01-basics/01-introduction.md` 开始了解 Move
3. **第一个程序**：跟随 `01-basics/03-first-program.md` 编写 Hello World
4. **实践示例**：运行 `01-basics/01-hello_blockchain/` 中的项目
5. **模块学习**：深入 `02-modules/01-module-basics-fixed.md` 理解模块概念
6. **数据类型**：学习 `03-data-types/` 掌握各种数据类型
   - 基本类型：`01-basic-types.md`
   - 结构体：`02-structs.md`
   - 引用：`03-references.md`
   - 最佳实践：`sources/10_struct_best_practices.move`
7. **函数编程**：通过 `04-functions/README.md` 学习函数基础
8. **资源模型**：重点学习 `05-resources/README.md` 理解 Move 核心概念
9. **高级特性**：学习 `06-generics-abilities/README.md` 掌握泛型和能力
10. **测试开发**：学习 `07-testing/README.md` 进行测试
11. **高级类型**：学习 `08-advanced-types/01-advanced-types.md` 和 `09-advanced-types/01-enum.md`
12. **跨合约调用**：学习 `10-cross-contract/01-cross-contract.md`

### 实践项目
- **Hello Blockchain**：`examples/01-hello_blockchain/` - 最基础的 Move 程序
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
- Aptos CLI
- VS Code（推荐）+ Move on Aptos 插件
- Git

### 运行示例
```bash
# 进入示例目录
cd examples/01-hello_blockchain

# 编译项目
aptos move compile --named-addresses hello_blockchain=default

# 运行测试
aptos move test --named-addresses hello_blockchain=default

# 检查代码
aptos move check --named-addresses hello_blockchain=default
```

### 运行代币示例
```bash
# 进入代币示例目录
cd examples/02-simple-token

# 编译项目
aptos move compile --named-addresses coin_addr=default

# 运行测试
aptos move test --named-addresses coin_addr=default
```

### 生成电子书
```bash
# 安装 mdBook（如果还没有安装）
cargo install mdbook

# 生成并预览电子书
mdbook serve

# 仅生成静态文件
mdbook build
```

### 学习建议
1. **按顺序学习**：不要跳过基础章节
2. **动手实践**：每个代码示例都要自己编写和运行
3. **理解概念**：重点理解 Move 的资源模型和引用系统
4. **多做练习**：运行和修改每章的示例代码
5. **项目实践**：尝试修改和扩展示例项目

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request 来改进教程：

1. **报告错误**：如果发现教程中的错误
2. **改进内容**：提供更好的解释或示例
3. **添加章节**：补充缺失的内容
4. **翻译优化**：改进中文表达

## 📄 许可证

本教程采用 MIT 许可证，可以自由使用和修改。 