# /onboard

Analyze the project deeply and generate a "Project Onboarding Document" for future AI programming reference.

## Description

This command performs a comprehensive analysis of the current project to create a detailed onboarding document. It inspects the file structure, identifies the tech stack, and extracts key code snippets to provide a holistic overview.

The final document is designed to be used as a persistent context for AI assistants, enabling them to understand the project's architecture, dependencies, and core logic, thus improving the accuracy and efficiency of subsequent coding tasks.

## Usage

- `/onboard`: Analyzes the entire project and saves the document to `.specify/onboarding.md`.
- `/onboard [path]`: Analyzes a specific directory within the project.
- `/onboard -o [file_path]`: Specifies a custom output path for the generated document.

## Script

This command will execute the bash script located at: `.specify/scripts/bash/onboarding.sh`
