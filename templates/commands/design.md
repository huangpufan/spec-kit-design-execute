---
description: Perform comprehensive design alignment for any type of requirement (new features, refactoring, bug fixes) through iterative dialogue.
scripts:
  sh: .specify/scripts/bash/design-alignment.sh --json "{ARGS}"
  ps: .specify/scripts/powershell/design-alignment.ps1 -Json "{ARGS}"
---

Given the user's requirement provided as an argument, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for PROJECT_ROOT, DESIGN_DIR, DESIGN_FILE, and DESIGN_ID. All file paths must be absolute.

2. **Initial Understanding Phase**:
   - Comprehensively analyze the entire codebase structure
   - Read key files like README.md, package.json/pyproject.toml, etc. to understand the project
   - Identify the project's technology stack, architecture patterns, and conventions
   - Understand existing features and how they're implemented

3. **Requirement Analysis**:
   - Parse the user's requirement to understand:
     * Type of request (new feature, refactoring, bug fix, enhancement)
     * Scope and complexity
     * Potential impact areas
     * Success criteria

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

5. **Interactive Alignment Process**:
   - Present your understanding of:
     * The current project state and architecture
     * The user's requirement and its implications
     * Your findings from the deep code analysis
     * How the requirement relates to existing code
     * Initial thoughts on approach and design
   - **CRITICAL**: For ANY aspect you don't fully understand or are uncertain about, you MUST:
     * Explicitly state what you're unsure about
     * Ask for clarification before proceeding
     * Wait for user confirmation before making assumptions
   - Ask clarifying questions about:
     * Specific behaviors and edge cases
     * Performance and scalability requirements
     * Integration with existing features
     * UI/UX preferences (if applicable)
     * Testing requirements
     * Any technical details you're not 100% certain about
   - Iterate until the user confirms complete alignment
   - Never proceed with assumptions - when in doubt, always ask

6. **Design Documentation**:
   - Once aligned, write a comprehensive design to DESIGN_FILE following the KISS principle:
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

7. **Final Confirmation**:
   - Present the complete design to the user
   - Make any final adjustments based on feedback
   - Get explicit confirmation that the design is approved

8. Report completion with design file location and readiness for execution phase.

IMPORTANT: 
- This is an INTERACTIVE process. You MUST engage in dialogue with the user throughout, not just generate a design document.
- You MUST thoroughly understand the codebase context. A design without deep code understanding is fundamentally flawed.
- You MUST confirm EVERY uncertainty with the user. Never make assumptions about requirements, technical details, or design decisions.
- If you're unsure about ANYTHING, stop and ask for clarification. It's better to ask too many questions than to proceed with incorrect assumptions.
- The goal is complete alignment before any implementation begins.
- Always follow the KISS principle - when multiple solutions exist, choose the simplest one that meets the requirements.

User requirement: {ARGS}
