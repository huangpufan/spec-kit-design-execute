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

**CRITICAL INSTRUCTION**: This is an INTERACTIVE process. You MUST engage in REAL dialogue with the user. NEVER proceed to the next step without explicit user confirmation. If you find yourself writing "The user confirms..." or similar phrases, STOP - you are hallucinating. Wait for ACTUAL user responses.

**OPENING STATEMENT (ALWAYS SAY THIS FIRST):**
First check the language configuration, then use the appropriate opening:

For English (LANGUAGE=en or no config):
"I understand you want to design [brief description of requirement]. This is the design phase where we'll discuss and align on the approach before any implementation. I will NOT write any code in this phase - only help you create a comprehensive design document.

Let me start by understanding your project and requirement better."

For Chinese (LANGUAGE=zh):
"我了解您想要设计 [需求的简要描述]。这是设计阶段，我们将在实施前讨论并对齐方案。在这个阶段我不会编写任何代码 - 只会帮助您创建一个全面的设计文档。

让我先更好地了解您的项目和需求。"

---

Given the user's requirement provided as an argument, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for PROJECT_ROOT, DESIGN_DIR, DESIGN_FILE, and DESIGN_ID. All file paths must be absolute.

2. **Initial Understanding Phase**:
   - Comprehensively analyze the entire codebase structure
   - Read key files like README.md, package.json/pyproject.toml, etc. to understand the project
   - Identify the project's technology stack, architecture patterns, and conventions
   - Understand existing features and how they're implemented
   
   **⏸️ STOP HERE - Do NOT proceed to step 3 yet. Continue with step 3 only in your NEXT response.**

3. **Requirement Analysis**:
   - Parse the user's requirement to understand:
     * Type of request (new feature, refactoring, bug fix, enhancement)
     * Scope and complexity
     * Potential impact areas
     * Success criteria
   
   **⏸️ STOP HERE - Do NOT proceed to step 4 yet. Continue with step 4 only in your NEXT response.**

4. **Deep Code Context Analysis** (MANDATORY):
   - Based on the requirement, thoroughly investigate all potentially related code:
     * Identify and read ALL files that might be affected or need modification
     * Trace through the complete execution flow of related features
     * Understand existing implementations of similar functionalities
     * Map out all dependencies and integration points
     * Examine data models, APIs, and interfaces that will be touched
     * Review existing tests to understand expected behaviors
   - Document your findings and share with the user to confirm understanding
   - If any part of the codebase seems relevant but you're unsure, investigate it
   - This step is CRITICAL - incomplete understanding leads to flawed designs
   
   **⏸️ MANDATORY STOP - Present your analysis to the user and WAIT for their response. Do NOT proceed to step 5 until the user explicitly confirms or provides feedback.**

5. **Interactive Alignment Process**:
   
   **🛑 CRITICAL: This is the MOST IMPORTANT step. You MUST have a REAL conversation with the user here.**
   
   **⚠️ REMINDER: DO NOT IMPLEMENT ANYTHING! This is DESIGN ONLY!**
   
   a) **First, present your understanding:**
      * The current project state and architecture
      * The user's requirement and its implications
      * Your findings from the deep code analysis
      * How the requirement relates to existing code
      * Initial thoughts on approach and design (WITHOUT code snippets)
   
   **⏸️ STOP AND WAIT for user response.**
   
   b) **Then, ask clarifying questions** (in subsequent responses based on user feedback):
      * Specific behaviors and edge cases
      * Performance and scalability requirements
      * Integration with existing features
      * UI/UX preferences (if applicable)
      * Testing requirements
      * Any technical details you're not 100% certain about
   
   **⏸️ After EACH question, STOP AND WAIT for user response.**
   
   c) **Continue this back-and-forth dialogue until:**
      * All your questions are answered
      * The user explicitly confirms they're satisfied with the alignment
      * You have 100% clarity on all aspects
   
   **🚫 NEVER write phrases like "The user confirms..." or "After discussion..." - these indicate you're hallucinating a conversation that hasn't happened.**

6. **Design Documentation**:
   
   **⏸️ CHECKPOINT: Before proceeding, the user MUST have explicitly said something like "Yes, let's proceed with the design document" or "I'm satisfied with our alignment". If they haven't, GO BACK to step 5.**
   
   **🚫 NO CODE IN DESIGN DOCUMENT! Only architectural decisions, data flow, and high-level approach.**
   
   **📝 IMPORTANT - Design Status Management:**
   - The design document will be created with **Status: DRAFT** (or **Status: 草稿** in Chinese)
   - To make the design no longer a draft, you need to change this field to:
     - **PENDING** (待审批): Ready for review/approval
     - **APPROVED** (已批准): Officially approved for implementation
   - The status field appears at the top of the document and in the "Approval Status" section at the bottom
   - Only designs with **APPROVED** status should be implemented using `/execute`
   
   - Once aligned, write a comprehensive design to DESIGN_FILE following the KISS principle:
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

7. **Final Confirmation**:
   - Present the complete design document location to the user
   - Ask: "I've created the design document at [location]. Would you like me to make any adjustments to it?"
   
   **⏸️ STOP AND WAIT for user response. Do NOT assume approval.**
   
   - Make any adjustments based on user feedback
   - Only mark as complete when user explicitly approves

8. **Completion**:
   - Only after explicit user approval, report completion with design file location
   - Inform user they can now use `/execute` command when ready

## 🚨 ANTI-HALLUCINATION AND NO-IMPLEMENTATION RULES:

1. **NEVER write user responses** - If you catch yourself writing "The user says...", "The user confirms...", or "After the user agrees...", STOP immediately.

2. **REAL stops, not fake ones** - When you see **⏸️ STOP**, you MUST end your response there. Don't continue with "After the user responds..." or similar.

3. **One step per response** - Each of your responses should cover only ONE step or sub-step. Wait for user input before moving to the next.

4. **Explicit confirmations only** - The user must ACTUALLY type their confirmation. Assumed or implied confirmations don't count.

5. **Questions need answers** - Every question you ask must receive an actual answer from the user before you continue.

6. **ABSOLUTELY NO IMPLEMENTATION** - If you catch yourself:
   - Writing code snippets
   - Using code editing tools
   - Creating implementation files
   - Suggesting specific code changes
   STOP immediately and remind yourself: "This is design phase only!"

## Example of CORRECT behavior:
```
AI: "I've analyzed the codebase and found that you have a React frontend with Redux for state management. Based on your requirement to add comments, I have some questions:
1. Should comments require user authentication?
2. Do you want nested/threaded comments?
[STOPS HERE AND WAITS]"

User: "Yes to authentication, and yes we want nested comments with up to 3 levels"

AI: "Got it. I have a few more questions:
1. Should comments support rich text formatting?
2. Do you need comment moderation features?
[STOPS HERE AND WAITS]"
```

## Example of INCORRECT behavior (hallucination):
```
AI: "I'll analyze the codebase... [analysis]... The user confirms that they want authenticated comments with nesting. Moving on to create the design document..."
[This is WRONG - the AI assumed user confirmation without waiting]
```

User requirement: {ARGS}
