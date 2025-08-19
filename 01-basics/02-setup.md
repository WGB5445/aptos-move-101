# 1.2 开发环境搭建

## 环境要求

在开始学习 Move 之前，我们需要搭建一个完整的开发环境。

我们需要使用 Aptos cli 作为编译器和执行环境

### 🛠️ 必需工具
- **Git**：版本控制

## 安装步骤

### 1. 安装 Aptos CLI

本文列出目前几种安装方式，更多方式详情可以查看文档：

https://aptos.dev/build/cli

#### Mac

1. 使用 Homebrew 安装
```bash
brew install aptos
```
2. 使用 Shell 脚本安装
```bash
curl -fsSL "https://aptos.dev/scripts/install_cli.sh" | sh
``` 

#### Linux
1. 使用 Shell 脚本安装
```bash
curl -fsSL "https://aptos.dev/scripts/install_cli.sh" | sh
```
2. ArchLinux 用户可以使用 AUR 安装
```bash
yay -S aptos-cli
```

#### Windows
1. winget 安装
```powershell
winget install aptos
```

2. 使用 Chocolatey 安装
```powershell
choco install aptos
```

3. 使用 scoop 安装
```powershell
scoop install https://aptos.dev/scoop/aptos.json
```

4. 使用 PowerShell 脚本安装
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser; iwr https://aptos.dev/scripts/install_cli.ps1 | iex
```

## 验证安装
```bash
aptos --version
```

显示类似以下内容，表示安装成功（版本 7.6.0）：

```
aptos 7.6.0
```

### 2. 安装 IDE 和插件

#### VS Code（推荐）
1. 下载并安装 [VS Code](https://code.visualstudio.com/)
2. 安装以下插件：
    - **Move on Aptos**：Aptos Move 支持，语法高亮和代码补全
        - https://marketplace.visualstudio.com/items?itemName=AptosLabs.move-on-aptos

#### 其他 IDE 选项
- **IntelliJ IDEA**：Move on Aptos
    - https://plugins.jetbrains.com/plugin/14721-move-on-aptos

## 下一步

环境搭建完成后，我们就可以开始编写第一个 Aptos Move 程序了！

### 📋 检查清单
- [ ] Aptos CLI 安装成功
- [ ] IDE 配置完成

---

**下一节**：[1.3 第一个 Aptos Move 程序](./03-first-program.md) 