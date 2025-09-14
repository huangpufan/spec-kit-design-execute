# Spec-Kit Design & Execute

本工具提供了一套命令行脚本，用于在你的项目中快速集成和使用 "Design & Execute" 工作流。

这个工作流旨在通过结构化的方式，帮助你将需求（Design）转化为可执行的代码（Execute），并确保两者之间的一致性。

## 功能

- **一键初始化**: 通过 `sk-init` 命令，自动在你的项目中创建所需的配置文件和脚本。
- **`/design` 命令**: 在 Cursor 中用于根据你的需求描述，生成详细、标准化的设计文档。
- **`/execute` 命令**: 在 Cursor 中用于读取已批准的设计文档，并指导 AI 完成编码任务。

## 安装

你可以通过一行命令来安装本工具。脚本会自动将 `sk-init` 命令安装到你的系统中。

> **注意**: 请将下面的 `YOUR_USERNAME/YOUR_REPO` 替换为你自己的 GitHub 用户名和仓库名。

```bash
curl -sSL https://raw.githubusercontent.com/huangpufan/spec-kit-design-execute/master/install.sh | bash
```

安装脚本会做以下几件事:
1.  将代码克隆到 `~/.spec-kit` 目录。
2.  在 `/usr/local/bin/` 目录下创建一个名为 `sk-init` 的符号链接，使其成为一个全局可用的命令。在需要时，它可能会请求 `sudo` 权限。

## 使用方法

安装完成后，在你希望集成 "Design & Execute" 工作流的任何 Git 项目中，运行以下命令：

```bash
# 1. 进入你的项目目录
cd /path/to/your/project

# 2. 运行初始化命令
sk-init
```

该命令会自动在你项目的 `.cursor/commands` 和 `.specify/scripts` 目录下创建必要的文件。

之后，你就可以在 Cursor 中使用 `/design` 和 `/execute` 命令了。

## 更新

如果你想更新到最新版本，只需重新运行安装命令即可：

```bash
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/install.sh | bash
```

## 卸载

如果你想卸载本工具，可以运行项目中的 `uninstall.sh` 脚本。

> **注意**: 请将下面的 `YOUR_USERNAME/YOUR_REPO` 替换为你自己的 GitHub 用户名和仓库名。

```bash
curl -sSL https://raw.githubusercontent.com/huangpufan/spec-kit-design-execute/main/uninstall.sh | bash
```
