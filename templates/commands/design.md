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
   - Section headers: "Design Document" → "设计文档", "Requirement" → "需求描述", "Summary" → "概要说明", "Context" → "背景分析", "Detailed Design" → "详细设计", "Implementation Plan" → "实施计划", "Testing Strategy" → "测试策略", "Risk Analysis" → "风险分析", "Alternatives Considered" → "备选方案"
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

**INTERACTION PRINCIPLE**: Be efficient and focused. Require exactly one alignment check after investigation to confirm key design decisions. Outside of that, only pause when you genuinely need clarification or when the user must make a choice. Do NOT ask if the user is ready or make unnecessary confirmations.

**OPENING STATEMENT:**
First check the language configuration, then use the appropriate opening:

For English (LANGUAGE=en or no config):
"I'll analyze your requirement for [brief description] and create a design document. I'll only ask questions if I need clarification or you need to make a choice."

For Chinese (LANGUAGE=zh):
"我将分析您关于 [简要描述] 的需求并创建设计文档。只有在需要澄清或您需要做选择时，我才会提问。"

---

Given the user's requirement provided as an argument, do this:

1. **Prepare Requirement Slug**:
   - Analyze the user's requirement `{ARGS}`.
   - Generate a short, descriptive, kebab-case English slug. This slug will be used for the design document's directory name.
   - **Example**: If the requirement is "修复登录页面的一个bug", the slug should be something like "fix-login-page-bug".
   - Let's call the result `SLUG_ARGS`.

2. Run the script `{SCRIPT}` with `SLUG_ARGS` as the argument from the repo root and parse its JSON output for PROJECT_ROOT, DESIGN_DIR, DESIGN_FILE, and DESIGN_ID. All file paths must be absolute.

3. **Requirement & Codebase Context Analysis** (Do all of this in one go):
   - **Consult Project Onboarding**:
     * Read and fully understand the project's core concepts, architecture, and conventions from `@.specify/onboarding.md`.
     * Ensure your design aligns with the principles and guidelines described in the onboarding document.
   - **Deconstruct the Requirement**: 
     * Identify the core goal of the user's request.
     * Determine the request type (new feature, refactoring, bug fix).
     * Define the scope, complexity, and success criteria.
   - **Gather Full Context from Codebase**: 
     * Perform an exhaustive search for all code related to the requirement.
     * Analyze existing implementations, data structures, and patterns that are relevant.
     * Map out dependencies and potential impact areas.
   - **Synthesize and Connect**: 
     * Create a brief analysis connecting the existing code to the new requirement.
     * Factually assess how the current implementation can support the new feature (synergies).
     * Factually identify any architectural or code-level obstacles (impediments).

4. **Design Formulation**:
   - Based on the context analysis, formulate a clear design approach.
   - **Conduct Impact Analysis**:
     * Identify all files and modules that will be added, modified, or deleted.
     * Assess the potential ripple effects on other parts of the system (e.g., performance, security, existing functionality).
     * Honestly evaluate the risks and side effects of the proposed changes, and how they will be mitigated.
   - Make reasonable assumptions based on codebase patterns.
   - Prepare a concise "Proposed Design" summary. This summary MUST transparently include:
     * **Goal & Scope**: What we are building and why.
     * **Approach**: How we will build it.
     * **Key Changes**: A list of primary files/modules to be touched.
     * **Impact & Risks**: The results of the impact analysis, including potential disruptions to the existing codebase.
     * **Alternatives**: Other options considered and why they were discarded.
   - Collect all open questions/choices to align in the next step.

5. **Single Alignment Check (MANDATORY)**:
   - Present the "Proposed Design" summary and all critical decisions/choices to the user in one message
   - Ask for explicit confirmation or selections (e.g., choose between options, approve/reject)
   - On approval, proceed to create the design document
   - If adjustments are requested, integrate them and present a short final confirmation (at most one iteration)
   
   **⏸️ STOP HERE - Wait for the user's decision before creating the design document.**

6. **Design Documentation**:
   
   **🚫 NO CODE IN DESIGN DOCUMENT! Only architectural decisions, data flow, and high-level approach.**
   
   Write a comprehensive design to DESIGN_FILE following KISS principle:
     * **Header**: Include ID and Date
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

7. **Design Delivery**:
   - Create the design document and inform user of its location
   - State: "Design document created at [location]. You can review it and request adjustments if needed, or use `/execute` when ready to implement."
   - Make any requested adjustments promptly

## 🚨 KEY RULES:

1. **BE EFFICIENT** - Complete the analysis and design with minimal interactions.

2. **ONE MANDATORY ALIGNMENT CHECK** - After investigation and before writing the design doc, present a consolidated "Proposed Design" and wait for the user's decision once. Outside of this checkpoint, only pause for real issues.

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
