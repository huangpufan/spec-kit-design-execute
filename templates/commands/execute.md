---
description: Execute a specific, approved design document by selecting from available designs.
scripts:
  sh: .specify/scripts/bash/execute-design.sh --json {ARGS}
  ps: .specify/scripts/powershell/execute-design.ps1 -Json {ARGS}
---

# 🌐 LANGUAGE CONFIGURATION

**IMPORTANT**: Check the language configuration at `.specify/config/language.conf`:
- If `LANGUAGE=zh`: Use Chinese (中文) for all dialogues and messages
- If `LANGUAGE=en`: Use English for all dialogues and messages
- If the config file doesn't exist: Default to English

**Objective**: Execute an implementation based on an approved design document, automatically selecting it if only one exists, or letting the user choose from multiple options.

1.  **Initial Script Execution**:
    - Run the script `{SCRIPT}` from the repo root **without any arguments**.
    - The script will output a list of available design documents.

2.  **User Interaction**:
    - **If the script output indicates "No design documents found"**, inform the user and stop.
    - **If the script lists exactly one design**, inform the user and automatically proceed with that design without asking for selection.
    - **If the script lists multiple designs**, present the list to the user and ask them to choose which one to execute. You can show the full name or just the ID for simplicity.
    - When user selection is needed, wait for the user to provide the ID or full name of the design they want to execute.
    - **If the script lists exactly one design**, inform the user and automatically proceed with that design without asking for selection.
    - **If the script lists multiple designs**, present the list to the user and ask them to choose which one to execute. You can show the full name or just the ID for simplicity.
    - When user selection is needed, wait for the user to provide the ID or full name of the design they want to execute.

3.  **Final Script Execution**:
    - Once a design is selected (either automatically or by the user), re-run the script `{SCRIPT}`, this time passing the selected design ID or name as an argument.
    - Once a design is selected (either automatically or by the user), re-run the script `{SCRIPT}`, this time passing the selected design ID or name as an argument.
    - Parse the JSON output from this second run for `DESIGN_FILE`, `DESIGN_ID`, and `PROJECT_ROOT`. All file paths must be absolute.

4.  **Pre-execution Validation**:
    - Verify `DESIGN_FILE` exists.
    - Read the design document completely.

5.  **Implementation Execution**:
    - Follow the implementation plan from the design document step by step.
    - **Apply KISS Principle Throughout**:
        - Choose the simplest implementation that meets requirements
        - Avoid over-engineering or adding unnecessary complexity
        - Prefer straightforward, readable code over clever solutions
        - Don't add features or abstractions not specified in the design
    - For each major step:
        - Announce what you're about to do.
        - Implement the changes using the simplest approach possible.
        - Validate the changes work as expected.
    - Maintain code quality (conventions, readability, error handling) while keeping solutions simple.

6.  **Testing and Validation**:
    - Implement tests according to the testing strategy in the design.
    - Run all relevant tests (new and existing) to ensure correctness and prevent regressions.
    - After each significant change, run linters, formatters, and perform checks to ensure the codebase remains healthy.

7.  **Final Report**:
    - Upon completion, provide a summary of what was implemented.
    - Note any deviations from the original design (with justification).
    - Report test results.
    - List any remaining tasks or follow-ups.

**IMPORTANT**: 
- Always follow the KISS principle during implementation - simplicity is key.
- If issues arise during implementation that require design changes, pause and consult with the user rather than making unilateral decisions.
- If you find yourself implementing something complex when a simpler solution exists, stop and reconsider your approach.
