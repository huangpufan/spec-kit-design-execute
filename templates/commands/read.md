---
description: Perform deep codebase analysis and understanding through AI-driven exploration. Ask complex questions about your repository and receive comprehensive answers with text, code snippets, and diagrams.
---

# 🌐 LANGUAGE CONFIGURATION

**IMPORTANT**: Check the language configuration at `.specify/config/language.conf`:
- If `LANGUAGE=zh`: Use Chinese (中文) for all analysis results and explanations
- If `LANGUAGE=en`: Use English for all analysis results and explanations
- If the config file doesn't exist: Default to English

When using Chinese, provide all explanations, summaries, and technical descriptions in Chinese while keeping code snippets and technical terms as-is.

# Deep Codebase Analysis Command

**Objective**: Provide thorough, AI-driven analysis of the codebase to answer user questions about existing code, architecture, logic flows, and dependencies.

## Command Syntax

The user will provide a natural language query that may include:
- General questions about the codebase
- Specific file or directory paths to focus on
- Questions about architecture, patterns, or implementations

## Execution Workflow

### 1. Query Analysis
- Parse the user's complete query to understand the primary question
- Identify any file names, directory paths, or specific components mentioned
- Determine the intended scope of analysis

### 2. Scope Inference
- If specific paths are mentioned, use them as the primary focus
- Even with specific paths, perform repository-wide searches to find all relevant connections
- If no paths are specified, analyze the entire repository

### 3. Comprehensive Code Analysis (CRITICAL)

**MANDATORY**: You MUST perform an exhaustive search to ensure completeness:

1. **Consult Project Onboarding First**:
   - Before any code search, read and fully understand `@.specify/onboarding.md`.
   - Use it as the primary source of truth for architecture, conventions, and core concepts.
   - Frame your entire analysis within the context provided by this document.

2. **Initial Broad Search**:
   - Use semantic search (`codebase_search`) with broad queries to identify ALL potentially relevant files
   - Search for related concepts, not just exact matches
   - Look for imports, exports, function calls, and references across the entire codebase
   
3. **Deep File Analysis**:
   - Read all identified files thoroughly
   - Trace function calls and data flows
   - Map dependencies and relationships
   - Analyze patterns and architectural decisions

4. **Cross-Reference Verification**:
   - Search for usages of identified components
   - Find all files that import or reference the core logic
   - Identify configuration files, tests, and documentation

**WARNING**: Incomplete analysis leads to incorrect or misleading answers. Always err on the side of being too thorough rather than missing important context.

### 4. Answer Synthesis and Generation

Structure your response for maximum clarity:

1. **Direct Answer**: Start with a clear, concise answer to the user's question

2. **Detailed Explanation**: 
   - Break down complex concepts into understandable sections
   - Explain the "why" behind implementations
   - Highlight important patterns or design decisions

3. **Code Examples**:
   - Include relevant code snippets with proper formatting
   - Show key functions, classes, or configurations
   - Add inline comments to explain complex parts

4. **Visual Representations** (when appropriate):
   - Generate Mermaid.js diagrams for:
     - Flow charts showing process flows
     - Sequence diagrams for interactions
     - Class diagrams for architecture
     - State diagrams for complex state management
   - Use diagrams to clarify complex relationships that are hard to explain in text

5. **Connections and Dependencies**:
   - List all related files and their roles
   - Explain how different parts connect
   - Mention any external dependencies

## Best Practices

1. **Thoroughness Over Speed**: Take time to explore all angles. Missing context is worse than taking longer.

2. **Clear Communication**: 
   - Use simple language for complex concepts
   - Define technical terms when first used
   - Structure information hierarchically

3. **Practical Focus**:
   - Relate findings to practical implications
   - Mention potential issues or considerations
   - Suggest related areas worth exploring

4. **Honesty About Limitations**:
   - If something is unclear or ambiguous, say so
   - If multiple interpretations exist, present them
   - Acknowledge when you need more context

## Example Queries and Expected Responses

**Example 1**: "How is user authentication implemented?"
- Search for auth-related files across the entire codebase
- Identify authentication strategies, middleware, and flows
- Create sequence diagrams showing the auth process
- List all files involved in authentication

**Example 2**: "Explain the data flow in src/api/"
- Analyze all files in src/api/ and their connections
- Search for all files that call APIs from this directory
- Create flow diagrams showing request/response cycles
- Identify data transformations and validations

**Example 3**: "What design patterns are used in this project?"
- Perform repository-wide analysis for common patterns
- Identify and explain each pattern with examples
- Show where each pattern is implemented
- Discuss the benefits of chosen patterns

Remember: The goal is to provide the user with a complete understanding of their codebase. Be thorough, be clear, and use visuals when they add value.
