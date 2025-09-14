---
description: Deeply analyze the project and generate an onboarding document for AI and humans.
scripts:
  sh: .specify/scripts/bash/onboarding.sh
---

# 🌐 LANGUAGE CONFIGURATION

**IMPORTANT**: Check the language configuration at `.specify/config/language.conf`:
- If `LANGUAGE=zh`: Use Chinese (中文) for all dialogues and messages
- If `LANGUAGE=en`: Use English for all dialogues and messages
- If the config file doesn't exist: Default to English

# 🎯 Objective

Create a comprehensive "Project Onboarding Document" for future development (including AI agents) by deeply reading the repository.

# 📌 How This Command Works

1. Run the script `{SCRIPT}` from the repo root with no arguments.
   - `/onboard` → analyze the whole repo; output to `.specify/onboarding.md`.
2. Treat the script's stdout as the authoritative project context and instructions. Do not ignore any of its sections.
3. Generate a well-structured Markdown onboarding document using that context.
4. Save the generated document to `.specify/onboarding.md`. If the parent directory does not exist, create it.

# ✅ Document Requirements

- Title: "Project Onboarding Document"
- Sections (at minimum):
  1. Project Overview
  2. Tech Stack
  3. Architecture Analysis
  4. Code Structure
  5. Core Logic Entrypoint
  6. Development Guide (setup, run, test)
  7. Conventions & Patterns (naming, code style, common utilities)
  8. Important Scripts/Tasks (build, lint, test, start)
  9. Risks & Caveats (gotchas, known limitations)
- Keep it practical and KISS-oriented. Prefer clarity over completeness.

# 🧭 Notes

- Prefer absolute file paths in any references.
- If information is ambiguous or missing, state reasonable assumptions explicitly.
- If the repo uses monorepo structure, clarify top-level vs package-level entrypoints and scripts.
