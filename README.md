# Spec-Kit Design & Execute

**轻量级的 AI 辅助开发工作流，专为 Cursor 优化。**

## 🎯 为什么需要这个项目？

在使用 [Spec-Kit](https://github.com/github/spec-kit) 的过程中，我发现了一个两难的境地：

### Spec-Kit 的局限性

1. **不够轻**：完整的 Spec-Driven Development 流程（specify → plan → tasks → implement）对于日常开发来说过于繁重
   - 修复 bug 不需要写完整的规范文档
   - 代码重构不需要制定详细的技术计划
   - 小功能迭代不需要分解任务列表
   
2. **不够重**：对于真正的大型项目，现有流程又显得不够完善
   - 缺少架构设计的深度
   - 缺少多模块协作的支持
   - 缺少持续迭代的管理

### 我们的解决方案

**Spec-Kit Design & Execute** 专注于解决"足够轻"的问题：

- ✅ **极简流程**：只保留最核心的 Design → Execute 两步
- ✅ **开箱即用**：一行命令完成初始化，立即开始使用
- ✅ **Cursor 优化**：专门为 Cursor 的工作流程优化，充分利用其 AI 能力
- ✅ **灵活适配**：适用于各种开发场景 - 新功能、重构、Bug 修复、性能优化等

## 💡 核心理念

我们相信：**好的设计文档 + AI 执行 = 高质量代码**

这个工具帮助你：
1. 用结构化的方式描述你想要什么（Design）
2. 让 AI 根据设计文档精准实现（Execute）
3. 保持设计与实现的一致性，便于后续维护

## 🚀 典型使用场景

### ✅ 适合使用本工具的场景

- **新功能开发**：需要先设计再实现的功能
- **代码重构**：需要明确重构目标和方案
- **Bug 修复**：复杂 bug 需要先分析根因和解决方案
- **性能优化**：需要先分析瓶颈和优化策略
- **API 设计**：需要先定义接口规范
- **数据库设计**：需要先设计表结构和关系

### ❌ 不适合的场景

- 简单的文案修改
- 样式微调
- 配置文件更新
- 一两行代码的小改动

## 📊 与 Spec-Kit 的对比

| 特性 | Spec-Kit | Spec-Kit Design & Execute |
|------|----------|---------------------------|
| **流程步骤** | 4步（specify → plan → tasks → implement） | 2步（design → execute） |
| **初始化时间** | 需要配置多个工具和环境 | 一行命令，30秒完成 |
| **学习曲线** | 陡峭，需要理解完整的 SDD 方法论 | 平缓，符合直觉的设计-实现流程 |
| **适用范围** | 主要针对新项目开发 | 任何需要 AI 辅助的开发场景 |
| **AI 工具支持** | Claude、Gemini、Copilot、Cursor | 专注 Cursor |
| **文档要求** | 严格的规范文档模板 | 灵活的设计文档格式 |
| **最佳场景** | 大型新项目的完整开发 | 日常开发的各种需求 |

## 🛠️ 核心功能

1. **一键初始化**
   - `sk-init` 命令自动创建项目结构
   - 智能检测项目类型，生成对应的模板
   - 自动配置 Cursor 命令

2. **`/design` 命令**
   - 引导式的设计文档生成
   - 自动补充技术细节
   - 支持迭代优化设计

3. **`/execute` 命令**
   - 基于设计文档的精准实现
   - 自动处理依赖和配置
   - 保持代码与设计的一致性

## 安装

你可以通过一行命令来安装本工具。脚本会自动将 `sk-init` 命令安装到你的系统中。

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

## 📖 工作流程示例

### 示例：添加用户认证功能

1. **使用 `/design` 命令生成设计文档**
   ```
   /design 我需要为我的 Express 应用添加用户认证功能，支持注册、登录、JWT token 验证
   ```
   
   AI 会深入理解代码仓，并与你持续交互，确认你的设计选择，最终生成一个详细的设计文档，包括：
   - 功能需求分析
   - API 接口设计
   - 数据库结构
   - 安全考虑
   - 实现步骤

2. **审查和优化设计**
   - 查看生成的 `designs/xxx_user_auth/design.md`
   - 根据需要调整设计细节
   - 确保设计符合你的需求

3. **使用 `/execute` 命令实现**
   ```
   /execute
   ```
   
   AI 会根据设计文档：
   - 安装必要的依赖
   - 创建数据库模型
   - 实现 API 接口
   - 添加中间件
   - 编写测试代码

### 示例：重构遗留代码

1. **设计重构方案**
   ```
   /design 重构 user service，将臃肿的单个文件拆分为多个模块，改善代码结构
   ```

2. **执行重构**
   ```
   /execute
   ```

## 🎨 设计哲学

我们坚信：
- **设计先行**：好的设计是好代码的前提
- **保持简单**：工具应该降低复杂度，而不是增加
- **聚焦价值**：把时间花在思考"做什么"，让 AI 处理"怎么做"
- **持续迭代**：设计和代码都应该能够轻松迭代

## 更新

如果你想更新到最新版本，只需重新运行安装命令即可：

```bash
curl -sSL https://raw.githubusercontent.com/huangpufan/spec-kit-design-execute/master/install.sh | bash
```

## 卸载

如果你想卸载本工具，可以运行以下命令：

```bash
curl -sSL https://raw.githubusercontent.com/huangpufan/spec-kit-design-execute/master/uninstall.sh | bash
```

## 🚧 路线图

### 长期愿景
- 探索与其他 AI 编程工具的集成
- 建立设计模式库和最佳实践
- 支持自定义工作流程

## 🤝 贡献

欢迎贡献！如果你有好的想法或发现了问题：

1. Fork 本仓库
2. 创建你的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交你的改动 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启一个 Pull Request

## 📝 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

- 感谢 [Spec-Kit](https://github.com/github/spec-kit) 项目提供的灵感和方法论基础
- 感谢 Cursor 团队打造的优秀 AI 编程工具
- 感谢所有贡献者和用户的支持

---

**记住：优秀的软件始于清晰的设计。** 🚀
