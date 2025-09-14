---
description: Execute a specific, approved design document by selecting from available designs.
scripts:
  sh: .specify/scripts/bash/execute-design.sh --json {ARGS}
  ps: .specify/scripts/powershell/execute-design.ps1 -Json {ARGS}
---

**Objective**: Execute an implementation based on a user-selected, approved design document.

1.  **Initial Script Execution**:
    - Run the script `{SCRIPT}` from the repo root **without any arguments**.
    - The script will output a list of available design documents.

2.  **User Interaction**:
    - **If the script output indicates "No design documents found"**, inform the user and stop.
    - **If the script lists available designs**, present the list to the user and ask them to choose which one to execute. You can show the full name or just the ID for simplicity.
    - Wait for the user to provide the ID or full name of the design they want to execute.

3.  **Final Script Execution**:
    - Once the user has made a selection, re-run the script `{SCRIPT}`, this time passing the user's selected design ID or name as an argument.
    - Parse the JSON output from this second run for `DESIGN_FILE`, `DESIGN_ID`, and `PROJECT_ROOT`. All file paths must be absolute.

4.  **Pre-execution Validation**:
    - Verify `DESIGN_FILE` exists.
    - Read the design document completely.
    - **Crucially, check for `**Status**: APPROVED`**. If it's not present, inform the user that the design is not approved and ask if they wish to proceed anyway. Only continue if they confirm.

5.  **Implementation Execution**:
    - Follow the implementation plan from the design document step by step.
    - For each major step:
        - Announce what you're about to do.
        - Implement the changes.
        - Validate the changes work as expected.
    - Maintain code quality (conventions, readability, error handling).

6.  **Testing and Validation**:
    - Implement tests according to the testing strategy in the design.
    - Run all relevant tests (new and existing) to ensure correctness and prevent regressions.
    - After each significant change, run linters, formatters, and perform checks to ensure the codebase remains healthy.

7.  **Final Report**:
    - Upon completion, provide a summary of what was implemented.
    - Note any deviations from the original design (with justification).
    - Report test results.
    - List any remaining tasks or follow-ups.

**IMPORTANT**: This command should ideally be run on a design that has been approved via the `/design` command. If issues arise during implementation that require design changes, pause and consult with the user rather than making unilateral decisions.
