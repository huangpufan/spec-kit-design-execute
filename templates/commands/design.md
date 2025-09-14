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

4. **Interactive Alignment Process**:
   - Present your understanding of:
     * The current project state and architecture
     * The user's requirement and its implications
     * Initial thoughts on approach and design
   - Ask clarifying questions about:
     * Specific behaviors and edge cases
     * Performance and scalability requirements
     * Integration with existing features
     * UI/UX preferences (if applicable)
     * Testing requirements
   - Iterate until the user confirms complete alignment

5. **Design Documentation**:
   - Once aligned, write a comprehensive design to DESIGN_FILE including:
     * **Summary**: Clear description of what will be done
     * **Context**: Current state and why this change is needed
     * **Detailed Design**: 
       - Architecture decisions
       - Component breakdown
       - Data flow and state management
       - API changes (if any)
       - Database schema changes (if any)
     * **Implementation Plan**: Step-by-step approach
     * **Testing Strategy**: How to validate the implementation
     * **Risk Analysis**: Potential issues and mitigation
     * **Alternatives Considered**: Other approaches and why they were rejected

6. **Final Confirmation**:
   - Present the complete design to the user
   - Make any final adjustments based on feedback
   - Get explicit confirmation that the design is approved

7. Report completion with design file location and readiness for execution phase.

IMPORTANT: This is an INTERACTIVE process. You MUST engage in dialogue with the user throughout, not just generate a design document. The goal is complete alignment before any implementation begins.

User requirement: {ARGS}
