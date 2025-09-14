# Spec-Lite

**A lightweight AI-assisted development workflow, optimized for Cursor.**

[简体中文](./README.md)

## 🎯 Why This Project?

While using [Spec-Kit](https://github.com/github/spec-kit), I found myself in a dilemma:

### Limitations of Spec-Kit

1.  **Not "light" enough**: The full Spec-Driven Development process (specify → plan → tasks → implement) is too cumbersome for daily development.
    -   Fixing a bug doesn't require a full specification document.
    -   Refactoring code doesn't require a detailed technical plan.
    -   Small feature iterations don't need a decomposed task list.

2.  **Not "heavy" enough**: For truly large-scale projects, the existing process feels incomplete.
    -   Lacks depth in architectural design.
    -   Lacks support for multi-module collaboration.
    -   Lacks management for continuous iteration.

### Our Solution

**Spec-Lite** focuses on solving the "light enough" problem:

-   ✅ **Minimalist Flow**: Keeps only the core two steps: Design → Execute.
-   ✅ **Out-of-the-Box**: A single command to initialize and get started immediately.
-   ✅ **Cursor Optimized**: Specifically optimized for Cursor's workflow, leveraging its full AI capabilities.
-   ✅ **Flexible Adaptation**: Suitable for various development scenarios - new features, refactoring, bug fixes, performance optimization, etc.

## 💡 Core Philosophy

We believe that: **Good Design Document + AI Execution = High-Quality Code**

This tool helps you:
1.  Describe what you want in a structured way (Design).
2.  Let AI implement it precisely based on the design document (Execute).
3.  Maintain consistency between design and implementation for easier future maintenance.

## 🚀 Typical Use Cases

### ✅ Suitable Scenarios for This Tool

-   **New Feature Development**: For features that need to be designed before implementation.
-   **Code Refactoring**: When clear refactoring goals and plans are needed.
-   **Bug Fixing**: For complex bugs that require root cause analysis and a solution plan first.
-   **Performance Optimization**: When bottlenecks and optimization strategies need to be analyzed.
-   **API Design**: When API specifications need to be defined first.
-   **Database Design**: When table structures and relationships need to be designed first.

### ❌ Unsuitable Scenarios

-   Simple text changes.
-   Minor style adjustments.
-   Configuration file updates.
-   Small changes involving only one or two lines of code.

## 📊 Comparison with Spec-Kit

| Feature                | Spec-Kit                                | Spec-Lite          |
| ---------------------- | --------------------------------------- | ---------------------------------- |
| **Workflow Steps**     | 4 steps (specify→plan→tasks→implement)  | 2 steps (design→execute)           |
| **Initialization Time**| Script-based, more flexible     | One-command, more convenient|
| **Learning Curve**     | Steep, requires understanding full SDD  | Gentle, intuitive design-to-code   |
| **Scope**              | Mainly for new projects/features        | Any AI-assisted development task   |
| **AI Tool Support**    | Claude, Gemini, Copilot, Cursor         | Focused on Cursor                  |
| **Doc Requirements**   | Strict specification templates          | Flexible design document formats   |
| **Best For**           | Full development of large new projects  | Various daily development needs    |

## 🛠️ Core Features

1.  **One-Click Initialization**
    -   `sk-init` command automatically creates the project structure.
    -   Intelligently detects project type and generates corresponding templates.
    -   Automatically configures Cursor commands.

2.  **`/design` Command**
    -   Guided generation of design documents.
    -   Automatically supplements technical details.
    -   Supports iterative design optimization.

3.  **`/execute` Command**
    -   Precise implementation based on the design document.
    -   Automatically handles dependencies and configurations.
    -   Maintains consistency between code and design.

## Installation

You can install this tool with a single command. The script will automatically install the `sk-init` command into your system.

```bash
curl -sSL https://raw.githubusercontent.com/huangpufan/spec-lite/master/install.sh | bash
```

The installation script will perform the following actions:
1.  Clone the repository to the `~/.spec-kit` directory.
2.  Create a symbolic link named `sk-init` in `/usr/local/bin/`, making it a globally available command. It may request `sudo` permissions if necessary.

## Usage

After installation, run the following command in any Git project where you want to integrate the "Design & Execute" workflow:

```bash
# 1. Navigate to your project directory
cd /path/to/your/project

# 2. Run the initialization command
sk-init
```

This command will automatically create the necessary files in your project's `.cursor/commands` and `.specify/scripts` directories.

After that, you can start using the `/design` and `/execute` commands in Cursor.

## 📖 Workflow & Examples

This section demonstrates the interactive flow of the `/design` and `/execute` commands in practical development through several typical scenarios.

### Scenario 1: Adding a New Feature

**Requirement**: Add a comment feature to a blog system, supporting nested replies and likes.

1.  **Start a design conversation with the `/design` command**
    ```
    /design Add a comment feature to my blog system, with support for nested replies and likes
    ```

2.  **Interactive analysis and alignment with the AI assistant**
    *   **Analyze existing code**: "I see your blog system uses Next.js and PostgreSQL..."
    *   **Ask for details to clarify requirements**:
        *   "Do comments need a moderation mechanism?"
        *   "Is login required to 'like' a comment?"
        *   "What is the nesting limit for replies?"
    *   **Confirm technical approach**: "Based on your needs, I recommend using a recursive query to handle nested comments..."

3.  **Generate the design document**
    After a thorough discussion and alignment, the AI will create a detailed design document in the `designs/` directory.

4.  **Execute with the `/execute` command**
    Once the design is confirmed, simply run:
    ```
    /execute
    ```
    The AI assistant will strictly follow the design document to implement the feature step by step.

### Scenario 2: Refactoring Existing Code

**Requirement**: Refactor the user authentication module from session-based to JWT token-based.

1.  **Use the `/design` command**
    ```
    /design Refactor the user authentication module from session to JWT token
    ```

2.  **Analysis by the AI assistant**
    *   **Understand the current state**: Analyze the current session implementation.
    *   **Assess the impact**:
        *   "Which API endpoints will be affected?"
        *   "What changes are needed on the frontend?"
    *   **Develop a migration plan**: Including data migration and compatibility considerations.
    *   **Risk analysis**: List potential issues and their solutions.

### Scenario 3: Fixing a Complex Bug

**Requirement**: Fix a memory overflow issue when users upload large files.

1.  **Use the `/design` command**
    ```
    /design Fix the memory overflow issue when uploading large files
    ```

2.  **Root cause analysis and solution discussion with the AI assistant**
    *   **Identify the problem**: Analyze the current file upload implementation.
    *   **Discuss solutions**:
        *   "Should we consider using streaming uploads?"
        *   "Is chunked upload necessary?"
    *   **Performance considerations**: Discuss the performance impact of different solutions.
    *   **Testing strategy**: How to verify the fix is effective.

### Key Differences between `/design` and Traditional Flows

#### Difference from `/specify` + `/plan` + `/tasks`

*   **Traditional Flow**:
    *   `/specify`: Create functional specifications.
    *   `/plan`: Generate a technical plan.
    *   `/tasks`: Decompose into tasks.
    *   The process is less interactive and more of a one-way generation.
*   **Design & Execute Flow**:
    *   `/design`: **Interactive** design alignment, confirming understanding through dialogue, which is a two-way communication.
    *   `/execute`: Strictly executes according to the finally confirmed design.

#### Scenario Comparison

**Scenarios for using `/specify` + `/plan` + `/tasks`**:
*   Rapid setup of a brand new project.
*   Functional requirements are very clear with almost no ambiguity.
*   There is a standardized implementation plan.

**Scenarios for using `/design` + `/execute`**:
*   Adding complex features to an existing project.
*   Refactoring tasks that require a deep understanding of the existing code.
*   Multiple implementation options need to be weighed and discussed.
*   Bug fixes that require comprehensive analysis.

## 🎨 Design Philosophy

We firmly believe in:
-   **Design First**: Good design is the prerequisite for good code.
-   **Keep It Simple**: Tools should reduce complexity, not add to it.
-   **Focus on Value**: Spend time thinking about "what to do" and let AI handle "how to do it".
-   **Continuous Iteration**: Both design and code should be easy to iterate on.

## Updating

If you want to update to the latest version, simply re-run the installation command:

```bash
curl -sSL https://raw.githubusercontent.com/huangpufan/spec-lite/master/install.sh | bash
```

## Uninstalling

If you want to uninstall this tool, you can run the following command:

```bash
curl -sSL https://raw.githubusercontent.com/huangpufan/spec-lite/master/uninstall.sh | bash
```

## 🚧 Roadmap

### Long-term Vision
-   Explore integration with other AI programming tools.
-   Build a library of design patterns and best practices.
-   Support custom workflows.

## 🤝 Contributing

Contributions are welcome! If you have great ideas or find a problem:

1.  Fork the repository.
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`).
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4.  Push to the branch (`git push origin feature/AmazingFeature`).
5.  Open a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgements

-   Thanks to the [Spec-Kit](https://github.com/github/spec-kit) project for the inspiration and methodological foundation.
-   Thanks to the Cursor team for creating an excellent AI programming tool.
-   Thanks to all contributors and users for their support.

---

**Remember: Great software starts with a clear design.** 🚀
