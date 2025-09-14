# Cursor 自定义命令设置指南

本文档说明如何在 Cursor 中设置和使用新的 `/design` 和 `/execute` 命令。

## 文件结构说明

对于 Cursor，文件应该按以下结构组织：

```
你的项目/
├── .cursor/
│   └── commands/          # Cursor 命令文件位置
│       ├── design.md      # /design 命令定义
│       └── execute.md     # /execute 命令定义
└── .specify/
    └── scripts/           # 脚本文件位置
        ├── bash/
        │   ├── design-alignment.sh
        │   └── execute-design.sh
        └── powershell/
            ├── design-alignment.ps1
            └── execute-design.ps1
```

## 快速安装

在你的项目根目录运行：

```bash
/home/hpf/project/spec-kit/setup-new-commands.sh
```

这个脚本会自动：
1. 创建 `.cursor/commands/` 目录
2. 复制命令文件到正确位置
3. 创建 `.specify/scripts/` 目录结构
4. 复制所有脚本文件
5. 设置脚本执行权限

## 手动安装

如果你想手动安装，执行以下步骤：

```bash
# 创建目录
mkdir -p .cursor/commands
mkdir -p .specify/scripts/bash
mkdir -p .specify/scripts/powershell

# 复制命令文件
cp /home/hpf/project/spec-kit/templates/commands/design.md .cursor/commands/
cp /home/hpf/project/spec-kit/templates/commands/execute.md .cursor/commands/

# 复制脚本文件
cp /home/hpf/project/spec-kit/scripts/bash/*.sh .specify/scripts/bash/
cp /home/hpf/project/spec-kit/scripts/powershell/*.ps1 .specify/scripts/powershell/

# 设置权限（Linux/macOS）
chmod +x .specify/scripts/bash/*.sh
```

## 验证安装

1. 重新加载 Cursor 项目（关闭并重新打开）
2. 在 Cursor 中输入 `/` 应该能看到新的命令：
   - `/design` - 创建交互式设计文档
   - `/execute` - 执行已批准的设计

## 使用说明

### /design 命令

用于任何类型的需求（新功能、重构、修复bug）：

```
/design 添加用户头像上传功能，支持裁剪和压缩
```

AI 会：
1. 分析你的项目结构
2. 理解现有代码和架构
3. 与你交互确认需求细节
4. 生成完整的设计文档

### /execute 命令

执行已确认的设计：

```
/execute
```

AI 会：
1. 找到最新的设计文档
2. 按照设计步骤实施
3. 创建必要的代码和测试
4. 报告执行结果

## 设计文档位置

所有设计文档保存在项目根目录的 `designs/` 文件夹中：

```
designs/
├── 20240315_143022_user-avatar-upload/
│   ├── design.md        # 设计文档
│   └── execution.log    # 执行日志
└── 20240316_091530_refactor-auth/
    └── design.md
```

## 注意事项

1. **Cursor 命令识别**：Cursor 只识别 `.cursor/commands/` 目录下的命令文件
2. **脚本位置灵活**：脚本可以放在 `.specify/scripts/` 中，这样可以与其他 spec-kit 工具兼容
3. **首次使用**：第一次使用可能需要重启 Cursor 才能识别新命令
4. **独立使用**：这两个命令完全独立，不依赖其他 spec-kit 命令
