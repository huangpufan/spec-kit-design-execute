# Spec-Lite

**A lightweight AI-assisted development workflow, optimized for Cursor.**

[简体中文](./README.md)

## 🎯 Core Philosophy

We've found that for daily development, a full-fledged Spec-Driven Development process (like [Spec-Kit](https://github.com/github/spec-kit)) can be too cumbersome, while for large-scale projects, it might not be comprehensive enough.

**Spec-Lite** focuses on the need for a lightweight process in daily development. It distills the workflow into two core steps: **Design → Execute**. This helps you:

1.  **Design Clearly**: Structure your ideas into a clear design document through an interactive dialogue with AI.
2.  **Execute Precisely**: Let the AI implement the code with high quality, based on the finalized design document.

Our philosophy is: **Thorough Project Understanding + Precise Human-AI Alignment = High-Quality Code**.

## 🚀 Use Cases

- **New Feature Development**: For features that need to be designed before implementation.
- **Code Refactoring**: When you have clear refactoring goals and plans.
- **Complex Bug Fixing**: When you need to analyze the root cause and devise a solution first.
- **Performance Optimization**: When you need to identify bottlenecks and create optimization strategies.

Essentially, any coding task that benefits from "thinking it through before coding" is a great fit for Spec-Lite.

## 🛠️ Core Features

- **One-Command Initialization**: The `sk-init` command quickly configures the workflow for your project.
- **Interactive Design**: The `/design` command guides you in creating a design document with AI.
- **Automated Execution**: The `/execute` command lets the AI precisely implement the code based on the design document.

## 📦 Installation & Usage

### Installation

Install it with a single command. The script will automatically add the `sk-init` command to your system.

```bash
curl -sSL https://raw.githubusercontent.com/huangpufan/spec-lite/master/install.sh | bash
```
> The script clones the repo to `~/.spec-lite` and creates a symlink for `sk-init` in `/usr/local/bin/` (which may require `sudo` permissions).

### Usage

Run the initialization command in your project's root directory:

```bash
sk-init
```

After that, you can start using the `/design` and `/execute` commands in Cursor.

## ✨ Workflow Example: Adding a New Feature

1.  **Start Designing**:
    ```
    /design Add a comment feature to the blog system, supporting nested replies and likes
    ```

2.  **Dialogue with AI**: The AI will analyze your existing code, ask for key details (e.g., "Do comments need moderation?"), and confirm the technical approach with you.

3.  **Generate Design Document**: Once the dialogue is complete, the AI will generate a detailed design document in the `designs/` directory.

4.  **Execute Implementation**:
    ```
    /execute
    ```
    The AI will then implement the feature strictly according to the design document.

## 📊 Comparison with Spec-Kit

| Feature | Spec-Kit | Spec-Lite |
|---|---|---|
| **Workflow Steps** | 4 steps (specify→plan→tasks→implement) | 2 steps (design→execute) |
| **Initialization** | Script-based, more flexible | One-command, more convenient |
| **Learning Curve** | Steeper | Gentle, intuitive |
| **Scope** | Mainly for new projects/features | Various daily development needs |
| **AI Tool Support** | Multiple supported | Focused on Cursor |

## Management

- **Update**: 
  ```bash
  sk-update
  ```
  Or re-run the installation script:
  ```bash
  curl -sSL https://raw.githubusercontent.com/huangpufan/spec-lite/master/install.sh | bash
  ```
- **Uninstall**:
  ```bash
  curl -sSL https://raw.githubusercontent.com/huangpufan/spec-lite/master/uninstall.sh | bash
  ```

## 🤝 Contributing

Contributions are welcome via Forks and Pull Requests.

## 📝 License

This project is licensed under the [MIT License](LICENSE).
