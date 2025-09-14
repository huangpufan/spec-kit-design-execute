---
description: Perform comprehensive design alignment for any type of requirement (new features, refactoring, bug fixes) through iterative dialogue.
scripts:
  sh: .specify/scripts/bash/design-alignment.sh --json "{ARGS}"
  ps: .specify/scripts/powershell/design-alignment.ps1 -Json "{ARGS}"
---

# 🌐 LANGUAGE CONFIGURATION

**IMPORTANT**: Check the language configuration at `.specify/config/language.conf`:
- If `LANGUAGE=zh`: Use Chinese (中文) for all dialogues and design documents
- If `LANGUAGE=en`: Use English for all dialogues and design documents
- If the config file doesn't exist: Default to English

When using Chinese (LANGUAGE=zh), you MUST:
1. Communicate with the user entirely in Chinese
2. When editing the design document, translate ALL content including:
   - Section headers: "Design Document" → "设计文档", "Requirement" → "需求描述", "Summary" → "概要说明", "Context" → "背景分析", "Detailed Design" → "详细设计", "Implementation Plan" → "实施计划", "Testing Strategy" → "测试策略", "Risk Analysis" → "风险分析", "Alternatives Considered" → "备选方案", "Approval Status" → "审批状态"
   - Status values: "DRAFT" → "草稿", "PENDING" → "待审批", "APPROVED" → "已批准"
   - All descriptions, comments, and content within sections
3. Keep technical terms, code snippets, and file paths in their original form

# 🚫 ABSOLUTE PROHIBITION: NO IMPLEMENTATION IN THIS COMMAND

**THIS IS A DESIGN-ONLY COMMAND. YOU ARE ABSOLUTELY FORBIDDEN FROM:**
- Writing any implementation code
- Creating any files except the design document
- Modifying any existing code files
- Suggesting code snippets or implementations
- Using any code editing tools (search_replace, write, MultiEdit, etc.)

**YOUR ONLY JOB IS TO:**
1. Understand the requirement through dialogue
2. Ask questions and align with the user
3. Create a design document

**IF THE USER ASKS YOU TO IMPLEMENT SOMETHING, YOUR RESPONSE MUST BE:**
For English: "This is the design phase. I cannot implement code here. Let's first complete the design alignment, and then you can use the `/execute` command for implementation."
For Chinese: "这是设计阶段。我不能在这里实现代码。让我们先完成设计对齐，然后您可以使用 `/execute` 命令进行实施。"

---

**INTERACTION PRINCIPLE**: Be efficient and focused. Only pause when you genuinely need clarification or when the user must make a choice between alternatives. Do NOT ask if the user is ready or make unnecessary confirmations.

**OPENING STATEMENT:**
First check the language configuration, then use the appropriate opening:

For English (LANGUAGE=en or no config):
"I'll analyze your requirement for [brief description] and create a design document. I'll only ask questions if I need clarification or you need to make a choice."

For Chinese (LANGUAGE=zh):
"我将分析您关于 [简要描述] 的需求并创建设计文档。只有在需要澄清或您需要做选择时，我才会提问。"

---

Given the user's requirement provided as an argument, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for PROJECT_ROOT, DESIGN_DIR, DESIGN_FILE, and DESIGN_ID. All file paths must be absolute.

2. **Comprehensive Analysis** (Do all of this in one go):
   - Analyze the entire codebase structure
   - Read key files like README.md, package.json/pyproject.toml, etc.
   - Identify the technology stack, architecture patterns, and conventions
   - Understand existing features and implementations
   - Parse the user's requirement to identify:
     * Type of request (new feature, refactoring, bug fix, enhancement)
     * Scope and complexity
     * Potential impact areas
     * Success criteria

3. **Deep Code Investigation & Design Formulation**:
   - Investigate all potentially related code:
     * Read ALL relevant files
     * Trace execution flows
     * Understand existing patterns
     * Map dependencies and integration points
   - Formulate a clear design approach based on analysis
   - Make reasonable assumptions based on codebase patterns
   - **ONLY ASK QUESTIONS IF**: You encounter critical ambiguities that block design creation. Present all questions at once, not piecemeal.

4. **Design Documentation**:
   
   **🚫 NO CODE IN DESIGN DOCUMENT! Only architectural decisions, data flow, and high-level approach.**
   
   **📝 Design Status Management:**
   - Create with **Status: DRAFT** (or **草稿** in Chinese)
   - Status options:
     - **PENDING** (待审批): Ready for review
     - **APPROVED** (已批准): Ready for implementation
   - Only **APPROVED** designs should be implemented via `/execute`
   
   Write a comprehensive design to DESIGN_FILE following KISS principle:
     * **Header with Status**: Include ID, Date, and **Status: DRAFT** (or 草稿)
     * **Summary**: Clear, simple description of what will be done
     * **Context**: Current state and why this change is needed
     * **Design Principles**: 
       - Explicitly state adherence to KISS principle
       - Prefer simple, straightforward solutions over complex ones
       - Avoid over-engineering and premature optimization
     * **Detailed Design**: 
       - Architecture decisions (keep it as simple as possible)
       - Component breakdown (minimize complexity)
       - Data flow and state management (choose simplest approach)
       - API changes (if any) - keep interfaces clean and minimal
       - Database schema changes (if any) - avoid unnecessary complexity
     * **Implementation Plan**: Step-by-step approach prioritizing simplicity
     * **Testing Strategy**: Focus on essential tests, avoid over-testing
     * **Risk Analysis**: Potential issues and mitigation
     * **Alternatives Considered**: Other approaches and why they were rejected (especially if simpler)
     * **Approval Status**: Include Status (DRAFT/PENDING/APPROVED), Approved By, and Approval Date fields

5. **Design Delivery**:
   - Create the design document and inform user of its location
   - State: "Design document created at [location]. You can review it and request adjustments if needed, or use `/execute` when ready to implement."
   - Make any requested adjustments promptly

## 🚨 KEY RULES:

1. **BE EFFICIENT** - Complete the entire analysis and design creation in minimal interactions. Don't ask unnecessary questions.

2. **ONLY STOP FOR REAL ISSUES** - Only pause if you encounter critical ambiguities that genuinely block design creation.

3. **NO FAKE INTERACTIONS** - Never write "The user says..." or assume responses. All user input must be real.

4. **ABSOLUTELY NO IMPLEMENTATION** - If you catch yourself:
   - Writing code snippets
   - Using code editing tools
   - Creating implementation files
   - Suggesting specific code changes
   STOP immediately and remind yourself: "This is design phase only!"

## Example of EFFICIENT behavior:
```
AI: "I'll analyze your requirement for adding a comment system and create a design document. I'll only ask questions if I need clarification or you need to make a choice.

[Performs comprehensive analysis...]

I need clarification on a few critical points before creating the design:
1. Should comments require user authentication or allow anonymous posting?
2. Do you need nested/threaded comments or flat comments?
3. Should comments support rich text formatting or plain text only?

These decisions will significantly impact the design approach."

User: "Authenticated only, nested up to 3 levels, plain text is fine"

AI: "Perfect. I'll create the design document based on these requirements.

[Creates design document...]

Design document created at designs/20240915_123456_add-comment-system.md. You can review it and request adjustments if needed, or use `/execute` when ready to implement."
```

## Example of INEFFICIENT behavior (too many pauses):
```
AI: "I'll analyze the codebase first... [STOPS]"
User: "Ok"
AI: "Now I'll look at your requirement... [STOPS]"
User: "Continue"
AI: "Let me ask you some questions... [STOPS]"
[This is WRONG - too many unnecessary pauses]
```

User requirement: {ARGS}
