# Commit Message Generator

Generate a commit message following the Conventional Commits specification (https://www.conventionalcommits.org/en/v1.0.0/).

## Instructions

1. First, run `git status` and show the output so the user can see what files are staged, modified, and untracked
2. Run `git diff --staged` to see what changes are staged for commit
3. If no changes are staged, automatically stage all modified files using `git add -u` (tracked files only), then run `git status` and `git diff --staged` again
4. If there are untracked files shown by `git status`, explicitly call them out to the user so they can decide whether to include them
5. Analyze the staged changes and generate a commit message

## Conventional Commits Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types (required)
- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **build**: Changes that affect the build system or external dependencies
- **ci**: Changes to CI configuration files and scripts
- **chore**: Other changes that don't modify src or test files
- **revert**: Reverts a previous commit

### Scope (optional)
A noun describing a section of the codebase surrounded by parentheses, e.g., `feat(parser):` or `fix(api):`.

**Important:** Only include a scope when the repository contains multiple distinct modules, packages, or applications. For single-project repositories (like a single web app or API), omit the scope entirely. The scope adds value only when it helps distinguish which part of a monorepo or multi-module project is affected.

### Description (required)
- Use the imperative, present tense: "change" not "changed" nor "changes"
- Don't capitalize the first letter
- No period (.) at the end
- Keep it concise (50 characters or less ideally)

### Body (optional)
- Use the imperative, present tense
- Include motivation for the change and contrast with previous behavior
- Wrap at 72 characters

### Footer (optional)
- **BREAKING CHANGE:** for breaking API changes (triggers major version bump)
- Reference issues: `Fixes #123` or `Closes #456`

## Output

After analyzing the changes, output:
1. The recommended commit message
2. A brief explanation of why you chose that type and description

Ask the user if they want to proceed with the commit using the generated message.
